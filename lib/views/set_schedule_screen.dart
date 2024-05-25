import 'package:adbot/helper/admob_helper.dart';
import 'package:adbot/utils/custom_color.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import '../controller/set_schedule_controller.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../widgets/appbar/appbar_widget.dart';
import '../widgets/buttons/button.dart';
import '../widgets/inputs_widgets/input_field.dart';

class SetScheduleScreen extends StatelessWidget {
  SetScheduleScreen({Key? key}) : super(key: key);

  final controller = Get.put(SetScheduleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarWidget(context),
      bottomNavigationBar: SizedBox(
          height: 50,
          child: AdWidget(
              ad: AdMobHelper.getBannerAd()..load(), key: UniqueKey())),
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
      appTitle: Strings.setSchedule.tr,
      onPressed: () {},
    );
  }

  _bodyWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _visibleInputFeildsWidget(context),
          _radioButtons(context),
          Obx(() => Visibility(
              visible: controller.scheduleType.value != "Daily",
              child: _scheduleTypeInputFeildsWidget(context))),
          _buttonWidget(context),
        ],
      ),
    );
  }

  _radioButtons(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(controller.radioValues.length,
            (index) => _radioWidget(context, controller.radioValues[index])));
  }

  _radioWidget(BuildContext context, String value) {
    return Row(
      children: [
        Obx(() => Radio(
              activeColor: CustomColor.primaryColor,
              value: value,
              groupValue: controller.scheduleType.value,
              onChanged: (value) {
                controller.scheduleType.value = value!;
              },
            )),
        Text(
          value.tr,
          style: TextStyle(
              fontSize: Dimensions.mediumTextSize * .7,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }

  _visibleInputFeildsWidget(BuildContext context) {
    return Column(
      children: [
        _inputTimeWidget(context, label: Strings.scheduleTime.tr),
        _inputWidget(context,
            label: Strings.scheduleName.tr,
            hint: Strings.enterScheduleName.tr,
            textController: controller.titleController),
        _inputWidget(context,
            label: Strings.scheduleDescription.tr,
            hint: Strings.description.tr,
            textController: controller.detailsController),
      ],
    );
  }

  _scheduleTypeInputFeildsWidget(BuildContext context) {
    DateTime now = DateTime.now();
    controller.dateController.text = DateFormat('yyyy-MM-dd').format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: controller.scheduleType.value == "Once",
            child: _inputWidget(context,
                onTap: () => _selectDate(context),
                label: Strings.scheduleDate.tr,
                hint: controller.dateController.text,
                readOnly: true,
                textController: controller.dateController)),
        Visibility(
            visible: controller.scheduleType.value == "Weekly",
            child: Text(
              Strings.selectWeeks.tr,
              style: TextStyle(
                  fontSize: Dimensions.mediumTextSize * .8,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor),
            )),
        Visibility(
            visible: controller.scheduleType.value == "Weekly",
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.weeks.length,
                itemBuilder: (context, index) {
                  return Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              activeColor: CustomColor.primaryColor,
                              value: controller.selectedDays[index],
                              onChanged: (value) {
                                controller.selectedDays[index] = value!;
                              }),
                          Text(controller.weeks[index])
                        ],
                      ));
                })),
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

  _inputWidget(BuildContext context,
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
          label,
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
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  _inputTimeWidget(BuildContext context, {required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.heightSize * 1),
        Text(
          label,
          style: TextStyle(
              fontSize: Dimensions.mediumTextSize * .8,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.widthSize * .5,
            vertical: Dimensions.widthSize * .5,
          ),
          child: DateTimeField(
            controller: controller.timeController,
            format: DateFormat('HH:mm:ss'),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
              ),
              hintText: "00:00:00",
              hintStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              suffixIcon: Icon(
                Icons.access_time_filled_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onShowPicker: (context, currentValue) async {
              var x = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.convert(x);
            },
          ),
        ),
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Dimensions.heightSize * 1),
        Button(
          child: Text(
            Strings.setSchedule.tr,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          onClick: () {
            controller.setSchedule(context);
          },
        ),
        SizedBox(height: Dimensions.heightSize * 1),
        const Divider(),
        Container()
      ],
    );
  }
}
