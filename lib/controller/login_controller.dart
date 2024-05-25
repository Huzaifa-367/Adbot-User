import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/api/toast_message.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../helper/local_storage.dart';
import '../model/user_model/user_model.dart';
import '../routes/routes.dart';
import 'main_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// auth sector
  signInWithGoogle(BuildContext context) async {
    _isLoading.value = true;
    update();

    try {
      final authService = MainController();
      debugPrint(
          "-------signInWithGoogle  =>  after get userCredential--------");

      final userCredential = await authService.signInWithGoogle();
      debugPrint("-------signInWithGoogle  =>  1  --------");

      final user = userCredential.user!;
      debugPrint(
          "-------signInWithGoogle  =>  before get userCredential--------");

      _userFunctionDataStore(user, userCredential);
    } catch (e) {
      ToastMessage.error(e.toString());
      debugPrint("----------${e.toString()}---------");
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  signInWithApple(BuildContext context) async {
    try {
      final authService = MainController();

      final userCredential = await authService.signInWithApple();
      final user = userCredential.user!;

      debugPrint('uid: ${user.uid}');

      _userFunctionDataStore(user, userCredential);
    } catch (e) {
      ToastMessage.error(e.toString());
      debugPrint("----------${e.toString()}---------");
    }
  }

  void goToHomePage() {
    Get.toNamed(Routes.homeScreen);
  }

  _userFunctionDataStore(User? user, UserCredential userCredential) {
    debugPrint("----------Before Condition---------");
    debugPrint("----------${user?.uid}---------");

    if (user != null) {
      debugPrint("----------After Start Condition---------");

      // storing some data for future use
      ToastMessage.success("Login Success");
      LocalStorage.isLoginSuccess(isLoggedIn: true);
      LocalStorage.saveEmail(email: user.email ?? '');
      LocalStorage.saveName(name: user.displayName ?? "");
      LocalStorage.saveId(id: user.uid);

      debugPrint("----------Before Loc Save al Storage---------");

      // debugPrint(user.toString());

      debugPrint("_________________________________");

      UserModel userData = UserModel(
        name: user.displayName ?? "",
        uniqueId: user.uid,
        phoneNumber: user.phoneNumber ?? "",
        isActive: true,
        imageUrl: user.photoURL ?? "",
        isPremium: false,
        textCount: 0,
        imageCount: 0,
        contentCount: 0,
        hashTagCount: 0,
        date: 0,
        email: user.email ?? '',
      );

      if (userCredential.additionalUserInfo!.isNewUser) {
        MainController.setData(userData);
      } else {
        MainController.checkPremiumOrNot(userData);
      }
    } else {
      _isLoading.value = false;
      update();
    }
  }

  final nameController = TextEditingController();
  final userEmailController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    userEmailController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void loginBTN(BuildContext ctx) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (GetUtils.isEmail(emailController.text)) {
        _isLoading.value = true;
        update();

        try {
          final authService = MainController();

          final userCredential = await authService.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
          final user = userCredential.user!;

          debugPrint('uid: ${user.uid}');

          if (user.emailVerified) {
            _userFunctionDataStore(user, userCredential);
          } else {
            user.sendEmailVerification();

            ToastMessage.error("User is not valid, please check your mail.");
          }
        } catch (e) {
          debugPrint(e.toString());
        } finally {
          _isLoading.value = false;
          update();
        }
      } else {
        ToastMessage.error("Please Write valid email.");
      }
    } else {
      ToastMessage.error("Please Write email and password.");
    }
  }

  forgotPassword(BuildContext context) {
    if (emailController.text.isNotEmpty) {
      GetUtils.isEmail(emailController.text)
          ? _resetPasswordProcess()
          : ToastMessage.error("Write your valid email first.");
    } else {
      ToastMessage.error("Write your valid email first.");
    }
  }

  _resetPasswordProcess() async {
    await MainController.resetPassword(email: emailController.text);
  }
}
