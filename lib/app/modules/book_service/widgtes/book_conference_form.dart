import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/core/services/data_validation.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/buttons/icon_text_button.dart';
import 'package:hotel_pms/widgets/buttons/my_outlined_button.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/mydividers.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/resourses/color_manager.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../widgets/check_box/check_box.dart';
import '../../../../widgets/text/big_text.dart';
import '../controller/book_service_form_controller.dart';

class BookConferenceForm extends GetView<BookServiceFormController> {

  BookConferenceForm({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookServiceFormController>(
      init: BookServiceFormController(),
      builder: (controller) => Scaffold(
        appBar: buildGlobalAppBar(context,appBarTitle: 'Conference Booking'),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: SizedBox()),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: const Size.fromHeight(12).height,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: formKey,
                            child: Column(children: [
                              /// Name, Phone, People Count
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: TextFieldInput(
                                      textEditingController: controller.nameController,
                                      hintText: "Full Name",
                                      textInputType: TextInputType.text,
                                      useBorder: true,
                                      validation: DataValidation.isAlphabeticOnly,
                                    ),
                                  ),
                                  SizedBox(
                                    width: const Size.fromWidth(10).width,
                                  ),
                                  Expanded(
                                    child: TextFieldInput(
                                      textEditingController: controller.phoneController,
                                      hintText: "Number",
                                      textInputType: TextInputType.text,
                                      useBorder: true,
                                      validation: DataValidation.isNumeric,
                                    ),
                                  ),
                                  SizedBox(
                                    width: const Size.fromWidth(10).width,
                                  ),
                                  Expanded(
                                    child: TextFieldInput(
                                      textEditingController:
                                      controller.peopleCountController,
                                      hintText: "People count",
                                      textInputType: TextInputType.text,
                                      useBorder: true,
                                      validation: DataValidation.isNumeric,
                                      onChanged: controller.updateServiceValue,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: const Size.fromHeight(20).height,
                              ),

                              /// Date Range picker


                              /// Multi-Date Picker Button
                              Obx(() => controller.selectedDatesCount.value == 0
                                  ? MyOutlinedButton(
                                text: 'Add Dates',
                                onClick: () {
                                  buildDialog(
                                      context,
                                      '',
                                      alignment: Alignment.center,
                                      height: 400,
                                      width: 400,
                                      Obx(() => TableCalendar(
                                        firstDay: DateTime.utc(2010, 10, 16),
                                        lastDay: DateTime.utc(2030, 3, 14),
                                        focusedDay:
                                        controller.focusDate.value,
                                        selectedDayPredicate: controller.dateIsSelected,
                                        onDaySelected: controller.addSelectedConferenceDates,
                                      )));
                                },
                                currentTextColor: ColorsManager.darkGrey,
                                textColor: ColorsManager.darkGrey,
                                backgroundColor: ColorsManager.flutterGrey,
                                borderColor: controller.selectedConferenceDateStatus.value == '' ? ColorsManager.flutterGrey :
                                ColorsManager.error,
                              )
                                  : const SizedBox()),

                              /// Selected Multi-Date Editor
                              Obx(
                                    () => controller.selectedDatesCount.value > 0
                                    ? Container(
                                  width: const Size.fromWidth(900).width,
                                  // height: const Size.fromHeight(170).height,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsManager.darkGrey, width: 2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Scrollbar(
                                    thickness: 5,
                                    child: SingleChildScrollView(
                                      physics:
                                      const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: const Size.fromWidth(200).width,
                                            child: IconTextButton(
                                              icon: Icons.add,
                                              buttonLabel: 'Add Dates',
                                              backgroundColor: ColorsManager
                                                  .primaryAccent
                                                  .withOpacity(.7),
                                              textColor: ColorsManager.darkGrey,
                                              buttonWidth: 200,
                                              onPressed: () {
                                                buildDialog(
                                                    context,
                                                    '',
                                                    alignment: Alignment.center,
                                                    height: 400,
                                                    width: 400,
                                                    Obx(() => TableCalendar(
                                                      firstDay: DateTime(2010, 10, 16),
                                                      lastDay: DateTime(2030, 3, 14),
                                                      focusedDay: controller.focusDate.value,
                                                      selectedDayPredicate: controller.dateIsSelected,
                                                      onDaySelected: controller.addSelectedConferenceDates,
                                                    )));
                                              },
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Obx(() => Checkbox(
                                                      value: controller
                                                          .allDatesSelected.value,
                                                      onChanged: (value) {
                                                        if (value != null &&
                                                            value) {
                                                          controller
                                                              .checkedConferenceDates
                                                              .value
                                                              .addAll(controller
                                                              .selectedConferenceDates
                                                              .value);
                                                        } else if (value != null &&
                                                            value == false) {
                                                          controller
                                                              .checkedConferenceDates
                                                              .value
                                                              .clear();
                                                        }
                                                        controller
                                                            .checkedConferenceDates
                                                            .refresh();

                                                        controller.allDatesSelected
                                                            .value = value!;
                                                      }))),
                                              const Expanded(
                                                  flex: 4,
                                                  child: BigText(text: 'Date')),
                                              Expanded(
                                                  flex: 4,
                                                  child: Obx(
                                                        () => controller
                                                        .checkedConferenceDates
                                                        .value
                                                        .isEmpty
                                                        ? const BigText(
                                                      text: 'Start Time',
                                                    )
                                                        : SizedBox(
                                                      width: 100,
                                                      child: MyOutlinedButton(
                                                          text:
                                                          'Set Start Time',
                                                          onClick: () {
                                                            controller
                                                                .updateStartEndTimeForCheckedSelectedDates(
                                                                true);
                                                          }),
                                                    ),
                                                  )),
                                              Expanded(
                                                  flex: 4,
                                                  child: Obx(() => controller
                                                      .checkedConferenceDates
                                                      .value
                                                      .isEmpty
                                                      ? const BigText(
                                                    text: 'End Time',
                                                  )
                                                      : SizedBox(
                                                    width: 100,
                                                    child: MyOutlinedButton(
                                                        text: 'Set End Time',
                                                        onClick: () {
                                                          controller
                                                              .updateStartEndTimeForCheckedSelectedDates(
                                                              false);
                                                        }),
                                                  ))),
                                            ],
                                          ),
                                          thinDivider(),
                                          Column(
                                            children: List<Widget>.generate(
                                                controller.selectedConferenceDates
                                                    .value.length,
                                                    (index) => Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: Checkbox(
                                                            value: controller
                                                                .selectedConferenceDates
                                                                .value[index]
                                                            [
                                                            'checked'] ??
                                                                false,
                                                            onChanged: (value) {
                                                              if (value !=
                                                                  null &&
                                                                  value) {
                                                                if (!controller
                                                                    .checkedConferenceDates
                                                                    .value
                                                                    .contains(controller
                                                                    .selectedConferenceDates
                                                                    .value[index])) {
                                                                  controller
                                                                      .checkedConferenceDates
                                                                      .value
                                                                      .add(controller
                                                                      .selectedConferenceDates
                                                                      .value[index]);
                                                                }
                                                              } else if (value !=
                                                                  null &&
                                                                  value ==
                                                                      false) {
                                                                controller
                                                                    .checkedConferenceDates
                                                                    .value
                                                                    .remove(controller
                                                                    .selectedConferenceDates
                                                                    .value[index]);
                                                              }
                                                              controller
                                                                  .selectedConferenceDates
                                                                  .value[index]
                                                              [
                                                              'checked'] = value!;
                                                              controller
                                                                  .selectedConferenceDates
                                                                  .refresh();
                                                            })),
                                                    Expanded(
                                                        flex: 4,
                                                        child: BigText(
                                                            text: extractDate(controller
                                                                .selectedConferenceDates
                                                                .value[index]
                                                            ['date']))),
                                                    Expanded(
                                                      flex: 4,
                                                      child: InkWell(
                                                          onTap: () {
                                                            showTimePicker(context: context,
                                                                initialTime: TimeOfDay.now())
                                                                .then((value) {
                                                              if (value !=
                                                                  null) {
                                                                controller.selectedConferenceDates
                                                                    .value[index]
                                                                [
                                                                'startTime'] =
                                                                    controller
                                                                        .parseTimeOfDayToString(
                                                                        value);
                                                                controller
                                                                    .selectedConferenceDates
                                                                    .refresh();
                                                              }
                                                            });
                                                          },
                                                          child: Obx(
                                                                () => BigText(
                                                              text:
                                                              '${controller.selectedConferenceDates.value[index]['startTime']}',
                                                            ),
                                                          )),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: InkWell(
                                                        onTap: () {
                                                          showTimePicker(
                                                              context:
                                                              context,
                                                              initialTime:
                                                              TimeOfDay
                                                                  .now())
                                                              .then((value) {
                                                            if (value != null) {
                                                              controller.selectedConferenceDates
                                                                  .value[
                                                              index]
                                                              [
                                                              'endTime'] =
                                                                  controller
                                                                      .parseTimeOfDayToString(
                                                                      value);
                                                              controller
                                                                  .selectedConferenceDates
                                                                  .refresh();
                                                            }
                                                          });
                                                        },
                                                        child:
                                                        Obx(() => BigText(
                                                          text:
                                                          '${controller.selectedConferenceDates.value[index]['endTime']}',
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                    : const SizedBox(),
                              ),

                              SizedBox(
                                height: const Size.fromHeight(20).height,
                              ),

                              SizedBox(
                                height: const Size.fromHeight(20).height,
                              ),

                              /// PaymentMethod, Service Cost & Payment Input
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Row(
                                    children: [
                                      MyCheckBox(
                                          title: 'Package',
                                          value: controller.isPackage.value, onChanged: (state){

                                        controller.updateIsPackage(state);
                                      }
                                      ),
                                      MyCheckBox(
                                          title: 'Hourly',
                                          value: controller.isHourly.value, onChanged: (state){
                                        controller.updateIsHourly(state);
                                      }
                                      ),
                                      MyCheckBox(
                                          title: 'Daily',
                                          value: controller.isDaily.value, onChanged: (state){
                                            controller.updateIsDaily(state);
                                          }
                                        ),
                                      MyCheckBox(
                                          title: 'Restaurant',
                                          value: controller.isRestaurant.value, onChanged: (state){
                                            controller.updateIsRestaurant(state);
                                      }
                                      ),
                                    ],
                                  ),),
                                  Obx(() => controller.isHourly.value ?  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: SizedBox(
                                      width: Size.fromWidth(100).width,
                                      child: TextFieldInput(
                                        textEditingController:
                                        controller.hoursBookedController,
                                        hintText: 'Hours',
                                        useBorder: true,
                                        validation: DataValidation.isNumeric,
                                        onChanged: controller.updateServiceValue,
                                      ),
                                    ),
                                  ): SizedBox()),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: Obx(() => GeneralDropdownMenu(
                                            menuItems: PaymentMethods.toList(),
                                            callback: controller.setPayMethod,
                                            userBorder: true,
                                            initialItem: 'Pay Method',
                                            borderColor:
                                            controller.payMethodStatus.value == ''
                                                ? ColorsManager.darkGrey
                                                : ColorsManager.error,
                                          ))),
                                      SizedBox(
                                        width: const Size.fromWidth(20).width,
                                      ),
                                      Expanded(
                                          child: Obx(() => TextFieldInput(
                                            textEditingController:
                                            controller.conferencePackage,
                                            hintText: controller.getPackageTypeLabel(),
                                            useBorder: true,
                                            validation: DataValidation.isNumeric,
                                            onChanged: controller.updateServiceValue,
                                          )
                                          )),
                                      SizedBox(
                                        width: const Size.fromWidth(20).width,
                                      ),
                                      Expanded(
                                          child: TextFieldInput(
                                            textEditingController:
                                            controller.advancePaymentController,
                                            hintText: "Advance Payment",
                                            useBorder: true,
                                            validation: DataValidation.isNumeric,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: const Size.fromHeight(20).height,
                              ),

                              /// Invoice Number
                              Row(
                                children: [
                                  Expanded(
                                      child: TextFieldInput(
                                        textEditingController:
                                        controller.serviceValueController,
                                        hintText: "Service Value",
                                        useBorder: true,
                                        validation: DataValidation.isNumeric,
                                      )
                                  )
                                ],
                              ),
                              SizedBox(
                                height: const Size.fromHeight(20).height,
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: SizedBox()),
                ],
              ),
              Obx(() => Card(
                child: controller.bookingInitiated.value
                    ? loadingAnimation(size: 30)
                    : InkWell(
                  hoverColor: ColorsManager.primaryAccent,
                  onTap: () async {
                    if (formKey.currentState!.validate() &&
                        controller.validatePayMethod() &&
                        controller.validateConferenceDates()) {
                      await controller.createConferenceBooking(isRoom: 0);
                      controller.displayBookingCreationStatus();

                      Get.back();
                    }else{
                      controller.displayBookingCreationStatus();

                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        BigText(text: controller.bookingButtonText.value),
                        controller.payMethodStatus.value != ''
                            ? SmallText(
                          text: controller.payMethodStatus.value,
                          color: ColorsManager.error,
                        )
                            : const SizedBox(),
                        SmallText(text: controller.selectedConferenceDateStatus.value,color: ColorsManager.error,)
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
