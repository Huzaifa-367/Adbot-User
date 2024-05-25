import 'package:adbot/helper/admob_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import '../../controller/cover_letter/cover_letter_controller.dart';
import '../../helper/local_storage.dart';
import '../../helper/unity_ad.dart';
import '../../utils/config.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../widgets/api/custom_loading_api.dart';
import '../../widgets/api/toast_message.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/buttons/button.dart';
import '../../widgets/inputs_widgets/input_field.dart';

class CoverLetterScreen extends StatelessWidget {
  CoverLetterScreen({super.key});

  final controller = Get.put(CoverLetterController());

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(context),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: AdWidget(
          ad: AdMobHelper.getBannerAd()..load(),
          key: UniqueKey(),
        ),
      ),
      body: _bodyWidget(context),
    );
  }

  _appBarWidget(BuildContext context) {
    return AppBarWidget(
      context: context,
      actionVisible: false,
      onBackClick: () {
        Get.back();
      },
      appTitle: Strings.coverLetter.tr,
      onPressed: () {},
    );
  }

  _bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _inputWidget(context),
        ],
      ),
    );
  }

  _inputWidget(BuildContext context) {
    DateTime now = DateTime.now();
    controller.dateController.text = DateFormat('yyyy-MM-dd').format(now);

    return Obx(() => Flexible(
          child: Form(
            key: formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _input2Widget(context,
                    onTap: () => _selectDate(context),
                    label: Strings.date.tr,
                    hint: controller.dateController.text,
                    readOnly: true,
                    textController: controller.dateController),
                _personalInfo(context),
                _experienceInfo(context),
                SizedBox(height: Dimensions.heightSize * 1),
                CheckboxListTile(
                    dense: true,
                    title: Text(
                      Strings.doYouHaveWorkExperience.tr,
                      style: TextStyle(
                          fontSize: Dimensions.mediumTextSize * .8,
                          fontWeight: FontWeight.w600,
                          color: CustomColor.primaryColor),
                    ),
                    value: controller.isFresher.value,
                    onChanged: (value) {
                      controller.isFresher.value = value!;
                    }),
                controller.isFresher.value
                    ? _pastCompanyInfo(context)
                    : const SizedBox.shrink(),
                _buttonWidget(context),
              ],
            ),
          ),
        ));
  }

  _heading(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.heightSize * 1),
        Text(
          text.tr,
          style: TextStyle(
              fontSize: Dimensions.mediumTextSize * .8,
              fontWeight: FontWeight.w600,
              color: CustomColor.primaryColor),
        ),
        const Divider(),
      ],
    );
  }

  _personalInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(Strings.personalInformation.tr),
        _input2Widget(context,
            label: Strings.fullName.tr,
            hint: Strings.enterYourName.tr,
            textController: controller.nameController),
        _input2Widget(context,
            label: Strings.address.tr,
            hint: Strings.enterAddress.tr,
            maxLines: 2,
            textController: controller.addressController),
        _input2Widget(context,
            label: Strings.emailAddress.tr,
            hint: Strings.enterYourEmail.tr,
            maxLines: 1,
            textController: controller.emailController),
        _input2Widget(context,
            label: Strings.mobileNumber.tr,
            hint: Strings.enterMobileNumber.tr,
            maxLines: 1,
            textController: controller.numberController),
        _input2Widget(context,
            label: Strings.linkedInUrl.tr,
            hint: "https://...",
            maxLines: 1,
            textController: controller.linkedInController),
        _input2Widget(context,
            label: Strings.portfolioUrl.tr,
            hint: "https://...",
            maxLines: 1,
            textController: controller.portfolioController),
      ],
    );
  }

  _experienceInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(Strings.newCompanyInformation.tr),
        _input2Widget(context,
            label: Strings.jobTitle.tr,
            hint: Strings.enterJobTitle.tr,
            textController: controller.jobTitleController),
        _input2Widget(context,
            label: Strings.companyName.tr,
            hint: Strings.enterCompanyName.tr,
            maxLines: 1,
            textController: controller.companyNameController),
        _input2Widget(context,
            label: Strings.address.tr,
            hint: Strings.enterAddress.tr,
            maxLines: 2,
            textController: controller.companyAddressController),
        _heading(Strings.qualifications.tr),
        _input2Widget(context,
            label: Strings.educationalBackground.tr,
            hint: Strings.describeShortly.tr,
            maxLines: 4,
            textController: controller.educationalDetailsController),
        _input2Widget(context,
            label: Strings.skills.tr,
            hint: Strings.mentionSkills.tr,
            maxLines: 4,
            textController: controller.skillsController),
        _input2Widget(context,
            label: Strings.latestWorkDescribe.tr,
            hint: Strings.describeShortly.tr,
            maxLines: 4,
            textController: controller.latestWorkController),
      ],
    );
  }

  _pastCompanyInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _input2Widget(context,
            label: Strings.totalExperience.tr,
            hint: Strings.enterTotalExperience.tr,
            maxLines: 1,
            textController: controller.totalExperienceController),
        _heading(Strings.latestCompanyInformation.tr),
        _input2Widget(context,
            label: Strings.companyName.tr,
            hint: Strings.enterCompanyName.tr,
            textController: controller.latestCompanyNameController),
        _input2Widget(context,
            label: Strings.myRole.tr,
            hint: Strings.enterMyRole.tr,
            maxLines: 1,
            textController: controller.latestCompanyMyRoleController),
        _input2Widget(context,
            label: Strings.duration.tr,
            hint: Strings.enterTotalExperience.tr,
            maxLines: 1,
            textController: controller.latestCompanyExperienceController),
        _input2Widget(context,
            label: Strings.others.tr,
            hint: Strings.describeShortly.tr,
            maxLines: 3,
            textController: controller.latestCompanyOthersController),
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(controller.dateController.text),
      firstDate: DateTime.now(),
      lastDate: DateTime((DateTime.now().year + 1)),
    );

    if (picked != null) {
      String date = DateFormat('yyyy-MM-dd').format(picked);

      if (date != controller.dateController.text) {
        controller.dateController.text = date;
      }
    }
  }

  _input2Widget(BuildContext context,
      {required TextEditingController textController,
      required String label,
      required String hint,
      VoidCallback? onTap,
      bool readOnly = false,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.heightSize * 1),
        Text(
          label.tr,
          style: TextStyle(
              fontSize: Dimensions.mediumTextSize * .8,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.widthSize * .5),
          child: InputField(
              controller: textController,
              readOnly: readOnly,
              maxLines: maxLines,
              hintText: hint,
              onTap: onTap),
        ),
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? const CustomLoadingAPI()
          : Column(
              children: [
                SizedBox(height: Dimensions.heightSize * 1),
                Button(
                  child: Text(
                    Strings.create.tr,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onClick: () async {
                    if (formKey.currentState!.validate()) {
                      if (!LocalStorage.isFreeUser()) {
                        if (LocalStorage.getHashTagCount() <
                            ApiConfig.premiumHashTagLimit) {
                          controller.processChat(context);
                        } else {
                          ToastMessage.error(
                              'Subscription Limit is over. Buy subscription again.');
                        }
                      } else {
                        if (LocalStorage.getHashTagCount() <
                            ApiConfig.freeHashTagLimit) {
                          controller.processChat(context);

                          debugPrint(
                              (controller.count.value % 2 == 0).toString());
                          if (controller.count.value % 2 == 0) {
                            debugPrint("1");
                            AdManager.showIntAd();
                          } else {
                            debugPrint("2");
                          }
                        } else {
                          ToastMessage.error(
                              'Content Limit is over. Buy subscription.');
                        }
                      }
                    }
                  },
                ),
                SizedBox(height: Dimensions.heightSize * 1),
                const Divider(),
              ],
            ),
    );
  }
}
