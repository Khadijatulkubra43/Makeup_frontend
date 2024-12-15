import 'package:flutter_application_1/core/services/api_service.dart';
import 'package:flutter_application_1/feature/settings/widgets/gender_selector.dart';
import 'package:flutter_application_1/widgets/edit_item.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  bool _isEditEnabled = false;

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  String _gender = "M";

  Future<void> getUserDetails() async {
    try {
      dynamic userDetails = await ApiService.getUserDetails();
      setState(() {
        _firstnameController.text = userDetails["first_name"];
        _lastnameController.text = userDetails["last_name"];
        _emailController.text = userDetails["email"];
        _ageController.text = "${userDetails['age']}";
        _genderController.text = userDetails['gender'];
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to get user details"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _firstnameController.text = 'n\\a';
    _lastnameController.text = 'n\\a';
    _emailController.text = 'n\\a';
    _ageController.text = '0';
    _genderController.text = 'M';

    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.chevron_back_outline),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isEditEnabled = !_isEditEnabled; // Toggle on click for now
                });
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: const Size(60, 50),
                elevation: 3,
              ),
              icon: (_isEditEnabled == false)
                  ? const Icon(Icons.edit, color: Colors.white)
                  : const Icon(Ionicons.checkmark, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Photo",
                widget: Column(
                  children: [
                    Image.asset(
                      "assets/images/avatar.png",
                      height: 100,
                      width: 100,
                    ),
                    (_isEditEnabled)
                        ? TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.lightBlueAccent,
                            ),
                            child: const Text("Upload Image"),
                          )
                        : const SizedBox(
                            height: 5,
                          ),
                  ],
                ),
              ),
              EditItem(
                title: "First Name",
                widget: TextFormField(
                  controller: _firstnameController,
                  enabled: _isEditEnabled,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Last Name",
                widget: TextFormField(
                  controller: _lastnameController,
                  enabled: _isEditEnabled,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Gender",
                widget: GenderSelector(
                    controller: _genderController,
                    isEnabled:
                        _isEditEnabled // Change to false to disable editing
                    ),
              ),
              // EditItem(
              //   title: "Gender",
              //   widget: Row(
              //     children: [
              //       IconButton(
              //         onPressed: () {
              //           setState(() {
              //             _gender = "M";
              //           });
              //         },
              //         style: IconButton.styleFrom(
              //           backgroundColor: _gender == "M"
              //               ? Colors.deepPurple
              //               : Colors.grey.shade200,
              //           fixedSize: const Size(50, 50),
              //         ),
              //         icon: Icon(
              //           Ionicons.male,
              //           color: _gender == "M" ? Colors.white : Colors.black,
              //           size: 18,
              //         ),
              //       ),
              //       const SizedBox(width: 20),
              //       IconButton(
              //         onPressed: () {
              //           setState(() {
              //             _gender = "W";
              //           });
              //         },
              //         style: IconButton.styleFrom(
              //           backgroundColor: _gender == "W"
              //               ? Colors.deepPurple
              //               : Colors.grey.shade200,
              //           fixedSize: const Size(50, 50),
              //         ),
              //         icon: Icon(
              //           Ionicons.female,
              //           color: _gender == "W" ? Colors.white : Colors.black,
              //           size: 18,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(height: 40),
              EditItem(
                widget: TextFormField(
                  controller: _ageController,
                  enabled: _isEditEnabled,
                ),
                title: "Age",
              ),
              const SizedBox(height: 40),
              EditItem(
                widget: TextFormField(
                  controller: _emailController,
                  enabled: _isEditEnabled,
                ),
                title: "Email",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
