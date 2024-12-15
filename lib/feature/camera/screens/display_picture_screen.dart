import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_application_1/core/services/api_service.dart';
import 'package:flutter_application_1/feature/camera/screens/image_screen.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  DisplayPictureScreen({super.key, required this.imagePath});

  Future<String> pickAndUploadFile(String imgPath) async {
    File file = File(imgPath);
    // Call the upload function
    Map<String, dynamic>? response = await ApiService.uploadFile(file);

    if (response != null) {
      return response['url'];
    } else {
      _scaffoldKey.currentState
          ?.showSnackBar(const SnackBar(content: Text("File Upload Failed")));
      return '';
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
            onPressed: () async {
              // Await the Future to get the result
              String imgUrl = await pickAndUploadFile(imagePath);
              if (imgUrl != '') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageScreen(
                      imageUrl: imgUrl,
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