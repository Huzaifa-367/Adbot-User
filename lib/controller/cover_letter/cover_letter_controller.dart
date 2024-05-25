
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../helper/unity_ad.dart';
import '../../routes/routes.dart';
import '../../services/api_services.dart';
import '../../utils/strings.dart';
import '../../views/pdf_view_screen.dart';

class CoverLetterController extends GetxController {

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
  RxInt count = 0.obs;
  RxBool isFresher = false.obs;


  final dateController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final linkedInController = TextEditingController();
  final portfolioController = TextEditingController();
  final educationalDetailsController = TextEditingController();

  final jobTitleController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();

  final skillsController = TextEditingController();
  final totalExperienceController = TextEditingController();
  final latestWorkController = TextEditingController();

  final latestCompanyNameController = TextEditingController();
  final latestCompanyMyRoleController = TextEditingController();
  final latestCompanyExperienceController = TextEditingController();
  final latestCompanyOthersController = TextEditingController();

  final responseController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString textResponse = ''.obs;
  RxList<int> pdfBytes = RxList<int>([]);


  void processChat(BuildContext context) async {
    isLoading.value = true;

    Map info = {
      "date": dateController.text,
      "personal_info": {
        'name': nameController.text,
        'address': addressController.text,
        'email': emailController.text,
        'number': numberController.text,
        'linkedin_url': linkedInController.text,
        'portfolio_url': portfolioController.text,
      },
      "qualification":{
        'educational_background_info': educationalDetailsController.text,
      },
      "company_info": {
        'job_title': jobTitleController.text,
        'name': companyNameController.text,
        'hiring_manager': "",
        'address': companyAddressController.text,
      },
      "skills": skillsController.text,
      "total_experience": totalExperienceController.text,
      "latest_work_description": latestWorkController.text,
      "latest_job_experience": {
        "company_name": latestCompanyNameController.text,
        'role': latestCompanyMyRoleController.text,
        'year': latestCompanyExperienceController.text,
        'others': latestCompanyOthersController.text
      }
    };

    String input = "$info \n create an easy and unique cover letter with this information in the cover letter don't use any brackets or special characters and if any key has an empty value then avoid it.";
    debugPrint("printing the input in the controller");
    debugPrint("--------------------------------------\n $input");

    update();

    _apiProcess(input, context);

    update();
  }





  _apiProcess(String input, context) async {
    await ApiServices.generateResponse2(input,) //  "text-davinci-003"
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

      debugPrint( "=> ${textResponse.value}");
      responseController.text = textResponse.value;

      count.value ++;

      isLoading.value = false;
      update();

      Get.toNamed(Routes.coverLetterResponseScreen);
      // generatePdf(context, response: textResponse.value);
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

    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    update();
    document.dispose();

    isLoading.value = false;
    Get.to(PdfViewScreen(pdfBytes: pdfBytes.toList(), name: 'cover-letter-${nameController.text}${DateTime.now().millisecondsSinceEpoch}.pdf',));
    update();
    document.dispose();

  }
}
