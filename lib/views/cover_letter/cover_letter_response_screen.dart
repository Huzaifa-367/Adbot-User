import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controller/cover_letter/cover_letter_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../widgets/appbar/appbar_widget.dart';
import '../../widgets/buttons/button.dart';

class CoverLetterResponseScreen extends StatelessWidget {
  CoverLetterResponseScreen({super.key});

  final controller = Get.find<CoverLetterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(context),
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
          _heading(Strings.hereYouCanModifyBeforeGettingPDFFile),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controller.responseController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Write your note here...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buttonWidget(context)
        ],
      ),
    );
  }

  _heading(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

  _buttonWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimensions.heightSize * 1),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: controller.responseController.text)).then((_){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
                  });
                },
                icon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CustomColor.secondaryColor,
                    borderRadius: BorderRadius.circular(Dimensions.radius)
                  ),
                  child: const Icon(Icons.copy_all, color: CustomColor.whiteColor, size: 28,),
                )),
            IconButton(
                onPressed: () {
                  controller.responseController.text = controller.textResponse.value;
                },
                icon: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CustomColor.secondaryColor2,
                    borderRadius: BorderRadius.circular(Dimensions.radius)
                  ),
                  child: const Icon(Icons.refresh, color: CustomColor.whiteColor, size: 28,),
                )),

            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Button(
                child: Text(
                  Strings.create.tr,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                onClick: () async {
                  await controller.generatePdf(context, response:  controller.responseController.text);
                },
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.heightSize * 1),
        const Divider(),
      ],
    );
  }
}
