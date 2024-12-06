// import 'package:flutter/material.dart';

// class WelcomeButton extends StatelessWidget {
//   const WelcomeButton(
//       {super.key, this.buttonText, this.onTap, this.color, this.textColor});
//   final String? buttonText;
//   final Widget? onTap;
//   final Color? color;
//   final Color? textColor;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (e) => onTap!,
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(30.0),
//         decoration: BoxDecoration(
//           color: color!,
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(50),
//           ),
//         ),
//         child: Text(
//           buttonText!,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//             color: textColor!,
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  const WelcomeButton({
    required this.buttonText,
    required this.onTap,
    required this.color,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger the function when tapped
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: textColor),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
