import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Picture'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
