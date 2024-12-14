import 'package:flutter/material.dart';
import 'package:flutter_application_1/feature/camera/camera_page.dart';
import 'package:flutter_application_1/feature/home/screens/home_screen.dart';
import 'package:flutter_application_1/feature/settings/screens/account_setting.dart';
import 'package:flutter_application_1/feature/users/screens/user_profile.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.pink[100],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home, color: Colors.white),
                selectedIcon: Icon(Icons.home, color: Colors.pinkAccent),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.camera, color: Colors.white),
                selectedIcon: Icon(Icons.camera, color: Colors.pinkAccent),
                label: 'Camera',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings, color: Colors.white),
                selectedIcon: Icon(Icons.settings, color: Colors.pinkAccent),
                label: 'Setting',
              ),
              NavigationDestination(
                icon: Icon(Icons.person, color: Colors.white),
                selectedIcon: Icon(Icons.person, color: Colors.pinkAccent),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const MakeupRecommendationScreen(),
    const CameraPage(),
    const AccountScreen(),
    const UserProfile(),
  ];
}
