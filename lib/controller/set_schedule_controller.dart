import 'package:adbot/widgets/api/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/local_storage.dart';
import '../helper/unity_ad.dart';
import '../model/schedule/schedule_model.dart';
import '../utils/strings.dart';

class SetScheduleController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await AdManager.loadUnityIntAd();
      await AdManager.loadUnityRewardedAd();
    });
  }

  RxString scheduleType = "Once".obs;
  List radioValues = [Strings.daily, Strings.weekly, Strings.once];

  RxList<bool> selectedDays =
      [false, false, false, false, false, false, false].obs;
  List weeks = [
    Strings.saturday,
    Strings.sunday,
    Strings.monday,
    Strings.tuesday,
    Strings.wednesday,
    Strings.thursday,
    Strings.friday
  ];

  final timeController = TextEditingController();
  final dateController = TextEditingController();
  final titleController = TextEditingController();
  final detailsController = TextEditingController();

  late ScheduleModel scheduleModel;

  @override
  void dispose() {
    timeController.dispose();
    titleController.dispose();
    detailsController.dispose();
    dateController.dispose();

    super.dispose();
  }

  void setSchedule(BuildContext context) async {
    if (titleController.text.isNotEmpty && detailsController.text.isNotEmpty) {
      List<ScheduleModel> pastSchedules = LocalStorage.getScheduleModels();
      debugPrint(pastSchedules.length.toString());

      for (var element in pastSchedules) {
        debugPrint("ID: ${element.id}");
        debugPrint("title: ${element.title}");
        debugPrint("description: ${element.description}");
      }

      List<String> selectedWeeks = [];

      for (int i = 0; i < weeks.length; i++) {
        if (selectedDays[i]) {
          selectedWeeks.add(weeks[i]);
        }
      }

      scheduleModel = ScheduleModel(
          id: pastSchedules.length,
          title: titleController.text,
          description: detailsController.text,
          scheduleType: scheduleType.value,
          time: timeController.text,
          date: dateController.text,
          weeks: selectedWeeks);

      await LocalStorage.saveScheduleModels(scheduleModel);
    } else {
      ToastMessage.error(Strings.fillUpForm);
    }
  }
}
