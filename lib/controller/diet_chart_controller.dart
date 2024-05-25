
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../helper/unity_ad.dart';
import '../services/api_services.dart';
import '../utils/strings.dart';
import '../views/pdf_view_screen.dart';
import '../widgets/api/toast_message.dart';

class DietChartController extends GetxController {

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await AdManager.loadUnityIntAd();
      // await AdManager.loadUnityRewardedAd();
    });
  }
  late String firebaseUrl ;
  late String pdfFileName;
  String selectGenderHintText = 'Select Gender';
  Rx<String?> selectedGender = Rx<String?>(null);
  RxInt count = 0.obs;

  var genderList = [
    'Male',
    'Female',
  ];

  String selectLifeStyleHintText = 'Select Life Style';
  Rx<String?> selectedLifeStyle = Rx<String?>(null);
  var selectedLifeStyleList = [
    'sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extra Active'
  ];

  final currentWeightController = TextEditingController();
  final targetWeightController = TextEditingController();
  final heightController = TextEditingController();
  final dietDurationController = TextEditingController();
  final countryController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString textResponse = ''.obs;
  RxList<int> pdfBytes = RxList<int>([]);

  bool genderValidate() {
    return selectedGender.value != null;
  }

  bool lifeStyleValidate() {
    return selectedLifeStyle.value != null;
  }

  Future<void> process(BuildContext context) async {
    if (genderValidate() && lifeStyleValidate()) {
      if (currentWeightController.text.isNotEmpty &&
          targetWeightController.text.isNotEmpty &&
          heightController.text.isNotEmpty &&
          dietDurationController.text.isNotEmpty) {
        // Perform form processing here

        debugPrint("========>Test print of data #sayem<==========");

        debugPrint(
            "current weight: ${currentWeightController.text}, target weight: ${targetWeightController.text} , height: ${heightController.text}, diet Duration: ${dietDurationController.text} , Gender: ${selectedGender.value}, LifeStyle: ${selectedLifeStyle.value} ");
        processChat(context);
      } else {
        ToastMessage.error("Fill out all the fields");
      }
    } else {
      if (!genderValidate()) {
        ToastMessage.error("Please select a gender");
      } else if (!lifeStyleValidate()) {
        ToastMessage.error("Please select a lifestyle");
      }
    }
  }

  void processChat(BuildContext context) async {
    isLoading.value = true;

    var input =
        "${Strings.createDietChart.tr} ${Strings.nowWeight.tr}  ${currentWeightController.text} ${Strings.kg.tr} ${Strings.expectedWeight.tr} ${targetWeightController.text} ${Strings.kg.tr} ${Strings.heightIs.tr} ${heightController.text} ${Strings.cm.tr}  ${Strings.myDietDuration.tr} ${dietDurationController.text} ${Strings.weeks.tr} ${Strings.iAmA.tr}  ${selectedGender.value ?? 'Male'} ${Strings.myLifestyle.tr}   ${selectedLifeStyle.value ?? 'Sedentary'}  ${Strings.basedOn.tr} ${countryController.text} ${Strings.food.tr}  ";
    debugPrint("printing the input in the controller");
    debugPrint(input);



    update();

    _apiProcess(input, context);

    update();
  }

  _apiProcess(String input, context) async {
    await ApiServices.generateResponse1(input, "text-davinci-003")
        .then((value) {
      textResponse.value = "";
      isLoading.value = true;
      update();
      debugPrint("---------------Content Response------------------");
      debugPrint("RECEIVED");

      debugPrint("=========> printing response of chat gpt<=========");
      debugPrint(value);
      textResponse.value = value.replaceAll("#", "\n#");
      update();
      debugPrint("---------------END------------------");

      count.value ++;

      generatePdf(context, response: textResponse.value);
    });
  }

  Future<void> generatePdf(context, {required String response}) async {
    isLoading.value = true;
    update();
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final PdfTextElement textElement = PdfTextElement();
    textElement.text = response;
    textElement.font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final PdfLayoutResult? result = textElement.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width * .95,
          MediaQuery.of(context).size.height * .90),
    );
    if (result != null) {
      result.page.graphics.drawString(
        Strings.pdfHeader.tr,
        PdfStandardFont(PdfFontFamily.helvetica, 14),
        bounds: const Rect.fromLTWH(0, 0, 500, 50),
      );
    }
    pdfBytes.value = await document.save();

    currentWeightController.clear();
    targetWeightController.clear();
    heightController.clear();
    dietDurationController.clear();
    countryController.clear();
    selectedGender.value = null;
    selectedLifeStyle.value = null;
    update();
    document.dispose();

    isLoading.value = false;
    Get.to(PdfViewScreen(pdfBytes: pdfBytes.toList(), name: 'diet-plan-${DateTime.now().millisecondsSinceEpoch}.pdf',));
    update();
    document.dispose();
  }
}