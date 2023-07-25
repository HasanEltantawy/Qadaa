import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class AppDashboardController extends GetxController {
  /* *************** Variables *************** */

  late final PageController pageController;
  int currentPageIndex = 0;
  bool isLoading = true;
  /* *************** Controller life cycle *************** */

  @override
  void onReady() {
    super.onReady();
    if (Hive.box("Prayers").get("is_app_locked", defaultValue: false)) {
      screenLock(
        context: Get.context!,
        title: const Text("أدخل كلمة المرور"),
        config: const ScreenLockConfig(
            backgroundColor: Color.fromARGB(255, 16, 35, 56)),
        correctString:
            Hive.box("Prayers").get("passcode", defaultValue: "0000"),
        canCancel: false,
      );
    }
  }

  @override
  void onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
    isLoading = false;
    update();
  }
}