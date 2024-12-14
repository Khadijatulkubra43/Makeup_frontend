import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/feature/auth/services/api_service.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  bool _isInitialized = false;
  bool _isFrontCamera = true;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        // Handle the case where no cameras are available
        setState(() {
          _isInitialized = true;
        });
        return;
      }

      _controller = CameraController(
        _cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => _cameras.first),
        ResolutionPreset.high,
      );

      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle initialization error
      _scaffoldMessengerKey.currentState
          ?.showSnackBar(const SnackBar(content: Text("ERROR Happend")));
    }
  }

  Future<void> _toggleCamera() async {
    try {
      final newCamera = _isFrontCamera
          ? _cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first);

      await _controller.dispose();
      _controller = CameraController(newCamera, ResolutionPreset.high);

      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isFrontCamera = !_isFrontCamera;
        });
      }
    } catch (e) {
      // Handle camera switching error
      // print('Error toggling camera: $e');
      _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text("Error toggling camera")));
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile picture = await _controller.takePicture();
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(imagePath: picture.path),
          ),
        );
      }
    } catch (e) {
      // Handle picture taking error
      _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text("Error: taking picture")));
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayPictureScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      // Handle image picking error
      _scaffoldMessengerKey.currentState
          ?.showSnackBar(const SnackBar(content: Text("Error picking camera")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text('Camera'),
        actions: [
          IconButton(
            icon: Icon(
              _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
            ),
            onPressed: _toggleCamera,
          ),
        ],
      ),
      body: CameraPreview(_controller),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _pickImage,
              child: const Icon(Icons.image),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: _takePicture,
              child: const Icon(Icons.camera),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// ignore: must_be_immutable
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  String _imgUrl = '';

  DisplayPictureScreen({super.key, required this.imagePath});

  void pickAndUploadFile(String imgPath) async {
    File file = File(imgPath);
    // Call the upload function
    Map<String, dynamic>? response = await ApiService.uploadFile(file);

    if (response != null) {
      _imgUrl = response['url'];
    } else {
      _scaffoldKey.currentState
          ?.showSnackBar(const SnackBar(content: Text("File Upload Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Display Picture'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
            onPressed: () {
              pickAndUploadFile(imagePath);
              if (_imgUrl != '') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageScreen(
                      imageUrl: _imgUrl,
                    ),
                  ),
                );
              }
            },
            child: const Text("Apply Make-up")),
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imageUrl;

  // Constructor to receive the image URL
  const ImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Image'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Image is fully loaded
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.red),
                  );
                },
                fit: BoxFit.contain,
              )
            : const Text('No image URL provided'),
      ),
    );
  }
}
