
import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hotel_pms/app/modules/sales_module/controller/sales_controller.dart';
import '../../../../core/resourses/color_manager.dart';
import '../../../../core/resourses/size_manager.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/values/localization/local_keys.dart';
import '../../../../widgets/buttons/my_outlined_button.dart';
import '../../../../widgets/dropdown_menu/custom_dropdown_menu.dart';
import '../../../../widgets/inputs/text_field_input.dart';
import '../../../../widgets/text/big_text.dart';
import '../../../../widgets/text/title_subtitle.dart';
import 'filter_box_item.dart';

class FiltersBox extends GetView<SalesController> {
   FiltersBox({Key? key}) : super(key: key);

  final categorySearchFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SalesController>(
      builder: (controller)=> Padding(
        padding: EdgeInsets.symmetric(horizontal: const Size.fromWidth(35).width),
        child: Column(
          children: [
            ExpandablePanel(
              header:  BigText(text: LocalKeys.kFilters.tr,),
                collapsed:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Search Box and Category
                    ConstrainedBox(
                        constraints: BoxConstraints.loose(const Size.fromWidth(800)),
                      child: OverflowBar(
                        spacing: 16,
                        overflowSpacing: 1,
                        overflowAlignment: OverflowBarAlignment.center,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() => GeneralDropdownMenu(
                            userBorder: false,
                            menuItems:  controller.searchCategories,
                            callback: controller.setSearchCategory,
                            initialItem: LocalKeys.kSearchBy.tr,
                            resetButton: controller.categoryDropdownIsReset.value,
                          ),),
                          ConstrainedBox(
                            constraints: BoxConstraints.loose(const Size.fromWidth(750)),
                            child: Form(
                                key: categorySearchFormKey,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Obx(() => TextFieldInput(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        inputFieldHeight: 120,
                                        textEditingController: controller.searchCtrl,
                                        hintText: controller.searchCategory.value.tr,
                                        textInputType: TextInputType.text,
                                        validation: controller.validateSearchCategory,
                                      )),
                                    ),
                                    IconButton( onPressed: (){
                                      if(categorySearchFormKey.currentState!.validate()){
                                        controller.filterCollectedPaymentsByCategory();
                                      }
                                    }, icon: const Icon(Icons.search)),
                                  ],
                                )
                            ),
                          )
                        ],
                      ),

                    ),
                    /// Date Range
                    ConstrainedBox(
                      constraints: BoxConstraints.loose(const Size.fromWidth(500)),
                      child: OverflowBar(
                        spacing: 16,
                        overflowSpacing: 30,
                        overflowAlignment: OverflowBarAlignment.start,
                        alignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints.loose(const Size.fromWidth(320)),
                            child: Row(

                              children: [
                                //SizedBox(width: const Size.fromWidth(15).width,),
                                Obx(() => LabeledText(
                                  iconTitle: Icons.calendar_month_rounded,
                                  subtitle:extractDate(controller.startDate.value),
                                  titleColor: ColorsManager.darkGrey,
                                  iconButtonFunction: (){
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime(2024)
                                    ).then((value) {
                                      if(value!=null) controller.startDate.value = value;
                                    });
                                  },
                                  subtitleSize: AppSize.size18, title: '',isRow: true,
                                ),),
                                SizedBox(width: const Size.fromWidth(25).width,child: const Center(child: Icon(Icons.arrow_forward_outlined,color: ColorsManager.darkGrey,)),),

                                //SizedBox(width: const Size.fromWidth(15).width,),
                                Obx(() => LabeledText(
                                  iconTitle: Icons.calendar_month_rounded,
                                  subtitle:extractDate(controller.endDate.value),
                                  titleColor: ColorsManager.darkGrey,
                                  iconButtonFunction: (){
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime(2024)
                                    ).then((value) {
                                      if(value!=null) controller.endDate.value = value;
                                    });
                                  },
                                  subtitleSize: AppSize.size18, title: '',isRow: true,

                                ),),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                              constraints: BoxConstraints.loose(const Size.fromWidth(125)),
                              child: MyOutlinedButton(text: LocalKeys.kClearFilters.tr, onClick: controller.clearFilters,
                                width: 120,height: 40,backgroundColor: ColorsManager.primary,
                                textColor: ColorsManager.grey1,borderColor: ColorsManager.primary,
                              )),
                        ],
                      ),
                    ),



                  ],
                ),
                expanded: Container(
                  color: ColorsManager.primaryAccent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      /// Input RoomNumber or Guest Name
                      Column(
                        children: [
                          Row(
                            children: [
                            buildFilterBoxItem(LocalKeys.kRoomNumber.tr,TextFieldInput(
                                textEditingController: controller.roomNumberCtrl,
                                hintText: '${LocalKeys.kEnter.tr} ${LocalKeys.kRoomNumber.tr}',
                                textInputType: TextInputType.text,
                                hintTextColor: ColorsManager.white,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              buildFilterBoxItem(LocalKeys.kClient.tr,TextFieldInput(
                                textEditingController: controller.guestNameCtrl,
                                hintText: '${LocalKeys.kEnter.tr} ${LocalKeys.kClient.tr}',
                                textInputType: TextInputType.text,
                                hintTextColor: ColorsManager.white,
                              ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// Select Employee and Service
                      Column(
                        children: [
                          buildFilterBoxItem(LocalKeys.kEmployee.tr,Obx(() => GeneralDropdownMenu(
                            menuItems: controller.employees.value,
                            callback: controller.setEmployeeFilterValue,
                            initialItem: "select",
                            userBorder: true,
                            borderRadius: 2,hintTextColor: ColorsManager.white,
                          )),
                        ),

                          buildFilterBoxItem(LocalKeys.kService.tr,
                              GeneralDropdownMenu(
                                  menuItems: const [LocalKeys.kRoom,LocalKeys.kRoomService,LocalKeys.kLaundry],
                                  callback: controller.setServiceFilterValue,
                                  initialItem: "select",
                                userBorder: true,
                                borderRadius: 2,hintTextColor: ColorsManager.white,
                              ),
                        ),
                        ],
                      ),

                      /// Select Pay Method and Date Range
                      Column(
                        children: [
                          buildFilterBoxItem(LocalKeys.kPayMethod.tr,GeneralDropdownMenu(
                            menuItems: const ["CASH", "MOBILE MONEY","CARD"],
                            callback: controller.setPayMethodFilterValue,
                            initialItem: "select",
                            userBorder: true,
                            borderRadius: 2,hintTextColor: ColorsManager.white,
                          ),
                          ),

                          buildFilterBoxItem(LocalKeys.kDate.tr,Row(
                            children: [
                              Obx(() => LabeledText(
                                iconTitle: Icons.calendar_month_rounded,
                                subtitle:extractDate(controller.startDate.value),
                                titleColor: ColorsManager.white,
                                iconButtonFunction: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2024)
                                  ).then((value) {
                                    if(value!=null) controller.startDate.value = value;
                                  });
                                },
                                subtitleSize: AppSize.size18, title: '',isRow: true,
                              ),),

                              SizedBox(width: const Size.fromWidth(35).width,child: const Center(child: Icon(Icons.arrow_forward_outlined,color: ColorsManager.darkGrey,)),),

                              //SizedBox(width: const Size.fromWidth(15).width,),
                              Obx(() => LabeledText(
                                iconTitle: Icons.calendar_month_rounded,
                                subtitle:extractDate(controller.endDate.value),
                                titleColor: ColorsManager.white,
                                iconButtonFunction: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2024)
                                  ).then((value) {
                                    if(value!=null) controller.endDate.value = value;
                                  });
                                },
                                subtitleSize: AppSize.size18, title: '',isRow: true,

                              ),),
                            ],
                          ),width: 400
                          ),
                        ],
                      ),
                      /// Search and Clear Filters
                      Column(
                        children: [
                          buildFilterBoxItem("",
                            MyOutlinedButton(text: LocalKeys.kSearch.tr, onClick: controller.filterCollectedPayments,width: 70,height: 60,
                              backgroundColor: ColorsManager.primary,textColor: ColorsManager.grey1,borderColor: ColorsManager.primary,), width: 250),


                          buildFilterBoxItem("",
                            MyOutlinedButton(text: LocalKeys.kClearFilters.tr, onClick: controller.clearFilters,width: 70,height: 40,
                              backgroundColor: ColorsManager.white,textColor: ColorsManager.darkGrey,borderColor: ColorsManager.primary,),
                            width: 250

                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                theme:  const ExpandableThemeData(
                    alignment: Alignment.center,
                    bodyAlignment: ExpandablePanelBodyAlignment.center,
                    tapHeaderToExpand: true,
                    tapBodyToCollapse: true,
                    hasIcon: true,
                    iconColor: ColorsManager.primaryAccent,
                    animationDuration: Duration(milliseconds: 500)
                ),


            ),
            /// Selected Filters
            Obx(() => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

                children: [
                  BigText(text: controller.filterResultStatus.value),
                  Row(
                    children: List<Widget>.generate(controller.selectedFiltersCount.value,
                            (index) => MyOutlinedButton(
                              borderRadius: 22,
                                width: 200,height: 60,backgroundColor: ColorsManager.grey1,textColor: ColorsManager.darkGrey,borderColor: ColorsManager.primary,
                            text: controller.selectedFilters.value[index], onClick: (){})),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}


