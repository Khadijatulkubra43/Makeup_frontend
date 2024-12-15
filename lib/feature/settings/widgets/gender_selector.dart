import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class GenderSelector extends StatefulWidget {
  final TextEditingController controller;
  final bool isEnabled;

  const GenderSelector({
    super.key,
    required this.controller,
    this.isEnabled = true,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String _selectedGender = "M"; // Default gender is "Male"

  @override
  void initState() {
    super.initState();
    // Initialize controller value with the current gender
    widget.controller.text = _selectedGender;
  }

  void _onGenderChanged(String gender) {
    setState(() {
      _selectedGender = gender;
      widget.controller.text = gender; // Update the controller value
    });
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isEnabled)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _genderIconButton("M", Ionicons.male),
              const SizedBox(width: 20),
              _genderIconButton("F", Ionicons.female),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _genderIconButton(_selectedGender,
                  (_selectedGender == "M") ? Ionicons.male : Ionicons.female),
              const SizedBox(width: 20),
            ],
          );
  }

  // Gender IconButton Widget
  Widget _genderIconButton(String value, IconData icon) {
    return IconButton(
      enableFeedback: widget.isEnabled,
      icon: Icon(
        icon,
        color: _selectedGender == value ? Colors.white : Colors.black,
        size: 22,
      ),
      style: IconButton.styleFrom(
        backgroundColor:
            _selectedGender == value ? Colors.deepPurple : Colors.grey.shade200,
        fixedSize: const Size(50, 50),
      ),
      onPressed: () {
        if (widget.isEnabled) {
          _onGenderChanged(value);
        }
      },
    );
  }
}
