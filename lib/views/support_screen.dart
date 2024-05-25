import 'package:adbot/controller/home_controller.dart';
import 'package:adbot/utils/custom_color.dart';
import 'package:adbot/utils/custom_style.dart';
import 'package:adbot/utils/dimensions.dart';
import 'package:adbot/utils/strings.dart';
import 'package:adbot/widgets/api/toast_message.dart';
import 'package:adbot/widgets/inputs_widgets/secondary_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';
import '../helper/unity_ad.dart';

class SupportFieldWidget extends StatefulWidget {
   const SupportFieldWidget({Key? key}) : super(key: key);

  @override
  State<SupportFieldWidget> createState() => _SupportFieldWidgetState();
}

class _SupportFieldWidgetState extends State<SupportFieldWidget> {
  final controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await AdManager.loadUnityIntAd();
      await AdManager.loadUnityRewardedAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _supportField(context);
  }

  _supportField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: Dimensions.heightSize * 2,
        left: Dimensions.widthSize * 2,
        right: Dimensions.widthSize * 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Strings.faceAnyProblem.tr,
            style: CustomStyle.primaryTextStyle
                .copyWith(fontSize: Dimensions.defaultTextSize * 2),
          ),
          SecondaryInputField(
            controller: controller.loginController.nameController,
            hintText: Strings.enterYourName,
          ),
          SecondaryInputField(
            controller: controller.loginController.userEmailController,
            hintText: Strings.enterYourEmail,
          ),
          SecondaryInputField(
            controller: controller.loginController.noteController,
            hintText: Strings.describeYourIssue,
            maxLine: 3,
          ),
          GestureDetector(
            onTap: () async{

              if (controller.loginController.nameController.text.isNotEmpty &&
                  controller.loginController.userEmailController.text.isNotEmpty &&
                  controller.loginController.noteController.text.isNotEmpty) {
                Get.back();

                AdManager.showIntAd();

                MainController.sendSupportTicket(
                    name: controller.loginController.nameController.text,
                    email: controller.loginController.userEmailController.text,
                    note: controller.loginController.noteController.text);
              } else {
                ToastMessage.error('!! Fill the Form');
              }
            },
            child: Card(
              color: CustomColor.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius * 2)),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: Dimensions.heightSize),
                child: const Icon(
                  Icons.send_outlined,
                  color: CustomColor.whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.heightSize,
          )
        ],
      ),
    );
  }
}
