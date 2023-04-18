import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/core/services/data_validation.dart';
import 'package:hotel_pms/core/values/app_constants.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/dropdown_menu/custom_dropdown_menu.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/loading_animation/loading_animation.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../../core/resourses/color_manager.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../widgets/cards/labled_widget.dart';
import '../../../../widgets/icons/app_icon.dart';
import '../../../../widgets/text/big_text.dart';
import '../controller/book_service_form_controller.dart';

class BookRoomForm extends GetView<BookServiceFormController> {


  BookRoomForm({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookServiceFormController>(
      init: BookServiceFormController(),
      builder: (controller) => Scaffold(
        appBar: buildGlobalAppBar(context,appBarTitle: 'Room Booking'),
        body: Column(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: const Size.fromHeight(20).height,
                            ),

                            /// Date Range picker
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: buildLabeledWidget(
                                      'Start Date',
                                      Row(
                                        children: [
                                          Obx(() => BigText(
                                              text: extractDate(controller
                                                  .bookingServiceStartDate
                                                  .value))),
                                          InkWell(
                                              onTap: () {
                                                showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                    DateTime.now(),
                                                    firstDate: DateTime(2023),
                                                    lastDate: DateTime(2024))
                                                    .then((selectedDate) {
                                                  controller
                                                      .bookingServiceStartDate
                                                      .value = selectedDate!;
                                                  controller
                                                      .updateBookingExpiryDate();
                                                });
                                              },
                                              child: const AppIcon(
                                                icon: Icons.calendar_month,
                                                useBackground: true,
                                              ))
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  width: const Size.fromWidth(10).width,
                                ),
                                Expanded(
                                  child: buildLabeledWidget(
                                      'End Date',
                                      Row(
                                        children: [
                                          Obx(() => BigText(
                                              text: extractDate(controller
                                                  .bookingServiceEndDate.value))),
                                          InkWell(
                                              onTap: () {
                                                showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                    DateTime.now(),
                                                    firstDate: DateTime(2023),
                                                    lastDate: DateTime(2024))
                                                    .then((selectedDate) {
                                                  controller.bookingServiceEndDate
                                                      .value = selectedDate!;
                                                  controller.calculateServiceCost(
                                                      1);
                                                });
                                              },
                                              child: const AppIcon(
                                                icon: Icons.calendar_month,
                                                useBackground: true,
                                              ))
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  width: const Size.fromWidth(10).width,
                                ),
                                Expanded(
                                  child: buildLabeledWidget(
                                    'Expiry Date',
                                    Obx(() => BigText(
                                        text:
                                        controller.bookingExpiryDate.value)),
                                  ),
                                )
                              ],
                            ),


                            SizedBox(
                              height: const Size.fromHeight(20).height,
                            ),

                            /// RoomNumber Input
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldInput(
                                    textEditingController:
                                    controller.roomNumberController,
                                    hintText: "Room Number",
                                    useBorder: true,
                                    validation: DataValidation.isNumeric,
                                  ),
                                ),
                                SizedBox(
                                  width: const Size.fromWidth(20).width,
                                ),
                                const Expanded(child: SizedBox())
                              ],
                            ),

                            SizedBox(
                              height: const Size.fromHeight(20).height,
                            ),

                            /// PaymentMethod, Service Cost & Payment Input
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
                                    child: TextFieldInput(
                                      textEditingController:
                                      controller.serviceValueController,
                                      hintText: "Service Value",
                                      useBorder: true,
                                      validation: DataValidation.isNumeric,
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
                      controller.validatePayMethod()) {
                    await controller.createRoomBooking(isRoom: 1);
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

                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
