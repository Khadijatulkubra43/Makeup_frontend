import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/feature/camera/screens/display_picture_screen.dart';

class CamerPage extends StatefulWidget {
  const CamerPage({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  State<CamerPage> createState() => _CamerPageState();
}

class _CamerPageState extends State<CamerPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the CameraController to display the camera preview.
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    // Initialize the controller, which returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller to release the camera resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Preview')),
      // Camera preview and floating button inside the Scaffold
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Show camera preview when initialization is complete.
            return CameraPreview(_controller);
          } else {
            // Display a loading indicator until the camera is ready.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Take the picture and save it to a file.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // Navigate to display the picture.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            // If an error occurs, print it to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
