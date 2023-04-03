
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/check_in_screen/view/check_in_form_view.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/widgets/app_bars/global_app_bar.dart';
import 'package:hotel_pms/widgets/dialogs/dialod_builder.dart';
import 'package:hotel_pms/widgets/inputs/text_field_input.dart';
import 'package:hotel_pms/widgets/tables/padded_data_table_row.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';

import '../../../../core/services/table_services.dart';
import '../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../widgets/dropdown_menu/custom_dropdown_menu.dart';
import '../../../../widgets/forms/form_header.dart';
import '../../../../widgets/illustrations/empty_illustration.dart';
import '../../../../widgets/tables/paged_data_table_source.dart';
import '../../book_service/view/book_service_form.dart';
import '../../place_holders/paginated_table_place_holders.dart';
import '../../widgtes/forms/hotel_issues_form.dart';
import '../controller/handover_form_controller.dart';

class HandoverForm extends GetView<HandoverFormController> {
  const HandoverForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
      init: HandoverFormController(),
      builder: (controller)=>Scaffold(
        appBar: buildGlobalAppBar(context, appBarTitle: "Handover Form"),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 200),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children:  const [
                // EmptyIllustration(),
                RoomsUsedSection(),
                ConferenceUsageSection(),
                LaundryUsageSection(),
                RoomServiceTransactionsSection(),
                HotelIssuesSection(),
                HandoverDetailsForm(),
              ],
            ),
          ),
        ),
    ));
  }
}

class HandoverDetailsForm extends GetView<HandoverFormController> {
  const HandoverDetailsForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
      init: HandoverFormController(),
        builder: (controller)=>Card(
      child: Column(
        children: [
          buildFormHeader("Collected Payments",enableCancelButton: false),
          SizedBox(height: const Size.fromHeight(20).height,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: TextFieldInput(textEditingController: controller.roomPaymentsCtr, hintText: 'Room',)),
                    SizedBox(width: const Size.fromWidth(20).width,),
                    Expanded(child: TextFieldInput(textEditingController: controller.roomDebtPaymentsCtr, hintText: 'Room Debts',)),
                    SizedBox(width: const Size.fromWidth(20).width,),
                    Expanded(child: TextFieldInput(textEditingController: controller.conferencePaymentsCtr, hintText: 'Conference',)),
                    //SizedBox(width: const Size.fromWidth(20).width,),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: TextFieldInput(textEditingController: controller.roomServicePaymentsCtr, hintText: 'Room Service',)),
                    SizedBox(width: const Size.fromWidth(20).width,),
                    Expanded(child: TextFieldInput(textEditingController: controller.laundryPaymentsCtr, hintText: 'Laundry',)),
                    SizedBox(width: const Size.fromWidth(20).width,),
                    Expanded(child: TextFieldInput(textEditingController: controller.totalDailyPaymentsCtr, hintText: 'Total',)),
                    //SizedBox(width: const Size.fromWidth(20).width,),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

Widget reportEntryHeader({
  required Function onRefreshEntries,required String title,
  required Function onAddEntry,required Function onConfirmEntry}){
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyOutlinedButton(text: 'Add Entry', onClick: onAddEntry,borderColor:ColorsManager.primary,),
          SizedBox(width: const Size.fromWidth(20).width,),
          MyOutlinedButton(
            text: 'Confirm Entries', onClick: onConfirmEntry,
            backgroundColor: ColorsManager.white,textColor: ColorsManager.darkGrey,
            borderColor: ColorsManager.darkGrey,currentTextColor: ColorsManager.darkGrey,

          ),
          SizedBox(width: const Size.fromWidth(20).width,),

          IconButton(onPressed: (){onRefreshEntries();}, icon: Icon(Icons.refresh))
          //MyOutlinedButton(text: 'Update', onClick: onRefreshEntries,borderColor:ColorsManager.primary,),


        ],
      ),


    ],
  );
}

class HotelIssuesSection extends GetView<HandoverFormController> {
  const HotelIssuesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller)=>Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaginatedDataTable(
                header: const BigText(text: 'Hotel Issues',),
                //dataRowHeight: getDataRowHeight(controller.),
                actions: [
                  reportEntryHeader(
                    onRefreshEntries: controller.onInit,
                    title: "Hotel Issues",
                    onAddEntry: (){
                      buildDialog(
                          context,
                          'Hotel Issue',
                          const HotelIssuesForm(),
                          width: 400,height: 600,
                          alignment: Alignment.center
                      );
                    },
                    onConfirmEntry: (){}
                )],
                rowsPerPage: getMaxTableRows(controller.hotelIssuesInCurrentSession.value.length),
                columns: controller.hotelIssuesTableSource == null ? TablePlaceHolders.initColumn :
                const [
                  DataColumn(label: SmallText(text: 'ROOM NUMBER'),numeric: true),
                  DataColumn(label: SmallText(text: 'ISSUE TYPE')),
                  DataColumn(label: SmallText(text: 'STATUS')),
                  DataColumn(label: SmallText(text: 'DESCRIPTION')),
                  DataColumn(label: SmallText(text: 'STEPS TAKEN')),
                ], source: controller.hotelIssuesTableSource ?? TablePlaceHolders.initSource
            ),
          ],
        )
    );
  }
}

class LaundryUsageSection extends GetView<HandoverFormController> {
  const LaundryUsageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller)=>Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaginatedDataTable(
              header: const BigText(text: 'Laundry Transactions',),
                actions: [reportEntryHeader(
                    onRefreshEntries: controller.onInit,
                    title: "Laundry Transactions",
                    onAddEntry: (){
                      // buildDialog(
                      //     context,
                      //     'LAUNDRY',
                      //     BookServiceForm(isRoom: 0,),
                      //     width: 700,
                      //     height: 600,
                      //     alignment: Alignment.center
                      // );
                      // Get.to(()=>CheckInView());
                    },
                    onConfirmEntry: (){}
                )],
                rowsPerPage: getMaxTableRows(controller.laundryTransactionsInCurrentSession.value.length),
                columns: controller.laundryUsageTableSource == null ? TablePlaceHolders.initColumn :
                const [
                  DataColumn(label: SmallText(text: 'ROOM NUMBER')),
                  DataColumn(label: SmallText(text: 'CLIENT ')),
                  DataColumn(label: SmallText(text: 'AMOUNT COLLECTED')),
                  DataColumn(label: SmallText(text: 'SERVICE')),
                  DataColumn(label: SmallText(text: 'EMPLOYEE')),
                ], source: controller.laundryUsageTableSource ?? TablePlaceHolders.initSource
            ),
          ],
        )
    );
  }
}

class RoomServiceTransactionsSection extends GetView<HandoverFormController> {
  const RoomServiceTransactionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller)=>Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PaginatedDataTable(
              header: const BigText(text: 'Room Service Transactions'),
                actions: [
                  reportEntryHeader(
                      onRefreshEntries: controller.onInit,
                      title: "Room Service Transactions",
                      onAddEntry: (){
                      },
                      onConfirmEntry: (){}
                  ),
                ],
                rowsPerPage: getMaxTableRows(controller.roomServiceTransactionsInCurrentSession.value.length),
                columns: controller.roomServiceUsageTableSource == null ? TablePlaceHolders.initColumn :const[
                  DataColumn(label: SmallText(text: 'ROOM NUMBER')),
                  DataColumn(label: SmallText(text: 'CLIENT ')),
                  DataColumn(label: SmallText(text: 'AMOUNT COLLECTED')),
                  DataColumn(label: SmallText(text: 'SERVICE')),
                  DataColumn(label: SmallText(text: 'EMPLOYEE')),
                ],
                source: controller.roomServiceUsageTableSource ?? TablePlaceHolders.initSource),


          ],
        ));
  }
}
class ConferenceUsageSection extends GetView<HandoverFormController> {
  const ConferenceUsageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller)=>PaginatedDataTable(
          header: const BigText(text: 'Conference Usage',),
            actions: [
              reportEntryHeader(
                  onRefreshEntries: controller.onInit,
                  title: "Conference Transactions",
                  onAddEntry: (){
                    buildDialog(
                        context,
                        'CONFERENCE',
                        BookServiceForm(isRoom: 0,),
                        width: 700,
                        height: 600,
                        alignment: Alignment.center
                    );
                    // Get.to(()=>CheckInView());
                  },
                  onConfirmEntry: (){}
              ),
            ],
            rowsPerPage: getMaxTableRows(controller.conferenceActivityCurrentSession.value.length),
            columns: const [
              DataColumn(label: SmallText(text: 'NAME',)),
              DataColumn(label: SmallText(text: 'EVENT TYPE',)),
              DataColumn(label: SmallText(text: 'ADVANCE',)),
              DataColumn(label: SmallText(text: 'TOTAL COST',)),
            ],
            source: controller.conferenceUsageTableSource ?? TablePlaceHolders.initSource));
  }
}

class RoomsUsedSection extends GetView<HandoverFormController> {
  const RoomsUsedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
        init: HandoverFormController(),
        builder: (controller)=>PaginatedDataTable(
          showFirstLastButtons: true,
          rowsPerPage: getMaxTableRows(controller.roomsSoldInCurrentSession.value.length),
          actions: [
            reportEntryHeader(
              onRefreshEntries: controller.onInit,
              title: "Rooms Sold",
              onAddEntry: (){
                buildDialog(context, 'Used Rooms Form',const RoomUsedForm(),height: 200,width: 350);
                // Get.to(()=>CheckInView());
              },
              onConfirmEntry: (){}
            ),
          ],
          header: const BigText(text: 'Rooms Sold Today'),
          columns: controller.roomsUsedTableSource == null ? TablePlaceHolders.initColumn :
            const [
                DataColumn(label: SmallText(text:'ROOM NUMBER')),
                DataColumn(label: SmallText(text:'AMOUNT')),
                DataColumn(label: SmallText(text:'SOLD X')),
                DataColumn(label: SmallText(text:'EMPLOYEE')),
                DataColumn(label: SmallText(text:'GUEST')),
            ],
          source: controller.roomsUsedTableSource ?? TablePlaceHolders.initSource,
        ));
  }
}

class RoomUsedForm extends GetView<HandoverFormController> {
  const RoomUsedForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandoverFormController>(
      init: HandoverFormController(),
        builder: (controller)=>
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: TextFieldInput(textEditingController: controller.roomNumberController, hintText: 'Room Number',)),
                ],
              ),
              //SizedBox(height: const Size.fromHeight(100).height,),
              MyOutlinedButton(text: 'Submit', onClick: (){
                Navigator.of(Get.overlayContext!).pop();
                Get.to(()=> CheckInView(roomNumber: controller.roomNumberController.text,isReport: true,));

              })
          ],
          ),
        )
    );
  }
}





