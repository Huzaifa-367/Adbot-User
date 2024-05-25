import 'package:adbot/helper/admob_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../controller/loves_notes/love_notes_controller.dart';
import '../../utils/assets.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../widgets/api/custom_loading_api.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/buttons/button.dart';

class LoveNotesScreen extends StatelessWidget {
  LoveNotesScreen({super.key});
  final controller = Get.put(LoveNotesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        context: context,
        onBackClick: () {
          Get.close(1);
        },
        moreVisible: false,
        appTitle: Strings.loveNotes.tr,
        onPressed: () {
          Get.close(1);
        },
      ),
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

  _bodyWidget(BuildContext context) {
    return ListView(
      padding:
          EdgeInsets.symmetric(horizontal: Dimensions.defaultPaddingSize * 0.6),
      children: [
        _imageWidget(context),
        _buttonWidget(context),
        _notesContainer(context),
      ],
    );
  }

  _imageWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.defaultPaddingSize),
      child: Image.asset(
        Assets.propose,
        fit: BoxFit.contain,
        height: MediaQuery.sizeOf(context).height * 0.2,
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.defaultPaddingSize,
      ),
      child: Obx(() => controller.isLoading.value
          ? const CustomLoadingAPI()
          : Button(
              child: Text(
                Strings.create,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              onClick: () {
                controller.generateLoveNote();
              })),
    );
  }

  _notesContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.defaultPaddingSize),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: CustomColor.primaryColor),
        borderRadius: BorderRadius.circular(Dimensions.radius * 0.6),
      ),
      child: Obx(() => Column(
            children: [
              Text(controller.loveNote.value.isEmpty
                  ? Strings.pressTheButton.tr
                  : controller.loveNote.value),
              Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: controller.loveNote.value.isNotEmpty,
                  child: IconButton(
                    onPressed: () => controller.copyResponse(context),
                    icon: const Icon(Icons.copy),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
