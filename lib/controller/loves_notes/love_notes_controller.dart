import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../helper/local_storage.dart';
import '../../services/api_services.dart';
import '../../utils/strings.dart';
import '../../widgets/api/toast_message.dart';
import '../main_controller.dart';

class LoveNotesController extends GetxController{
 final RxString loveNote = "".obs;
 RxBool isLoading = false.obs;

 void generateLoveNote() {
   isLoading.value = true;

   var input = "${Strings.createARandomLoveNote.tr} in ${LocalStorage.getLanguage()[2]}";

   update();

   _apiProcess(input);

   update();
  }

 _apiProcess(String input){

   ApiServices.generateResponse2(input).then((value) {
     isLoading.value = false;
     update();
     debugPrint("---------------Content Response------------------");
     debugPrint("RECEIVED");
     debugPrint(value);
     loveNote.value = value;
     update();
     debugPrint("---------------END------------------");

   });
 }




 RxInt count = 0.obs;

 addTextCount() async {
   debugPrint("-------${count.value.toString()}--------");
   count.value++;

   if(LocalStorage.isLoggedIn()) {
     MainController.updateContentCount(count.value);
   }
 }


 void copyResponse(BuildContext context) async{
   await Clipboard.setData(ClipboardData(text: loveNote.value));
   ToastMessage.success("Copied");
 }
}