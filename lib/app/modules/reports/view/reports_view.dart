import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_pms/app/modules/reports/controller/reports_controller.dart';
import 'package:hotel_pms/app/modules/reports/widgets/report_summary_card.dart';
import 'package:hotel_pms/core/resourses/color_manager.dart';
import 'package:hotel_pms/core/utils/date_formatter.dart';
import 'package:hotel_pms/widgets/tables/paged_data_controller.dart';
import 'package:hotel_pms/widgets/text/big_text.dart';
import 'package:hotel_pms/widgets/text/small_text.dart';
import '../../../../core/utils/useful_math.dart';
import '../../../../mock_data/mock_data_api.dart';
import '../../../../widgets/buttons/icon_text_button.dart';
import '../../../../widgets/cards/admin_user_card.dart';
import '../../../../widgets/text/title_subtitle.dart';
import '../../../data/models_n/admin_user_model.dart';
import '../../../data/models_n/internl_transaction_model.dart';
import 'hand_over_form_view.dart';


class ReportsView extends GetView<ReportsController> {
  ReportsView({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsController>(
      init: ReportsController(),
      builder: (controller)=>Scaffold(
        //appBar: buildGlobalAppBar(context,appBarTitle: "Reports"),
        backgroundColor: ColorsManager.flutterGrey,
        body: Row(
          children: [
             Expanded(
              flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
                  child: Column(
                    children: [
                      /// Title and UserCard
                      ReportTitleAndUserCard(adminUser: AdminUser(),),
                      SizedBox(height: const Size.fromHeight(20).height,),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              /// OverView and CreateReports Button
                              const OverviewRow(),
                              SizedBox(height: const Size.fromHeight(18).height,),

                              /// Sales Report  Cards
                              const SalesSummaryCards(),
                              SizedBox(height: const Size.fromHeight(18).height,),

                              /// Petty Cash
                              const PettyCashTable(),

                            ],
                          ),
                        ),
                      )



                    ],
                  ),
                )
             ),
             Expanded(
                 child: Padding(
                    padding: const EdgeInsets.all(8.0),
                     child: Container(
                         height: MediaQuery.of(context).size.height,
                         decoration: BoxDecoration(
                           color: ColorsManager.grey1,
                           borderRadius: BorderRadius.circular(8),
                         ),

                         child: SingleChildScrollView(
                           child: Column(
                             children:  [
                               const PowerStatusCard(),
                               BookedServicesCard(),
                               OperationsIssuesExpandable(),
                               SessionTransactions()

                             ]
                           ),
                         ),
                       )
                   ),
                )
            ]
        ),

      ),
    );
  }
}

class OverviewRow extends GetView<ReportsController> {
  const OverviewRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsController>(
      init: ReportsController(),
        builder: (controller)=>Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const BigText(text: "Overview ",size: 35,),
                SmallText(text: extractDate(DateTime.now()),size: 18,),
              ],
            ),
            IconTextButton(
              buttonLabel: 'Create Report', icon: Icons.add,
              onPressed: (){Get.to(()=> HandoverReport());},buttonWidth: 200,backgroundColor: ColorsManager.primary,
              iconColor: ColorsManager.grey1,textColor: ColorsManager.grey1,
            ),
            IconTextButton(
              buttonLabel: 'Refresh', icon: Icons.add,
              onPressed: controller.onInit,buttonWidth: 200,backgroundColor: ColorsManager.primary,
              iconColor: ColorsManager.grey1,textColor: ColorsManager.grey1,
            ),

      ],
    ));
  }
}

class ReportTitleAndUserCard extends StatelessWidget {
  final AdminUser adminUser;
  const ReportTitleAndUserCard({
    super.key,required this.adminUser
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back_ios,color: ColorsManager.darkGrey,),
                onPressed: () {Get.back();}),
            const BigText(text: "Reports"),
          ],
        ),
        AdminUserCard(
          titleColor:ColorsManager.darkGrey ,subtitleColor: ColorsManager.darkGrey,
          borderColor: ColorsManager.flutterGrey,
        )
      ],
    );
  }
}

class SalesSummaryCards extends GetView<ReportsController> {
  const SalesSummaryCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsController>(
      init: ReportsController(),
        builder: (controller)=>SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(controller.reportSummaryTitles.length, (index) =>
            Row(
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: buildReportSummaryCard(controller.reportSummaryTitles[index],
                      controller.getReportSummaryMockData(controller.reportSummaryTitles[index]), random(-9, 20)*1.0),
                ),
                //FractionallySizedBox(widthFactor: .01,),
              ],
            ),
      ),
    ),
        ));
  }
}

class SessionTransactions extends GetView<ReportsController> {
   SessionTransactions({Key? key}) : super(key: key);
  final List<Icon> issueIcon = [
    Icon(Icons.bed,color: ColorsManager.error.withOpacity(0.6),),
    Icon(Icons.account_balance,color: ColorsManager.error.withOpacity(0.6),),
    Icon(Icons.restaurant,color: ColorsManager.error.withOpacity(0.6),)
  ];

  final List<String> transactionType = ['ROOM','CONFERENCE','LAUNDRY','ROOM SERVICE','BOOKING'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BigText(text: "Session Transactions"),
        Column(
          children: List<Widget>.generate(10, (index) {
            return Card(
              elevation: 0,
              margin: EdgeInsets.all(5),
              child: ListTile(
                leading: issueIcon[random(0, issueIcon.length)],
                title: BigText(text: transactionType[random(0, transactionType.length)],),
                subtitle: SmallText(text: 'Tbd',maxLines: 3,),
                trailing: BigText(text: random(5000, 150000).toString(),),
              ),
            );
          }),
        )

      ],
    );
  }
}

class OperationsIssuesExpandable extends GetView<ReportsController> {
  OperationsIssuesExpandable({Key? key}) : super(key: key);

  final List<Icon> issueIcon = [
    Icon(Icons.bed,color: ColorsManager.error.withOpacity(0.6),),
    Icon(Icons.account_balance,color: ColorsManager.error.withOpacity(0.6),),
    Icon(Icons.restaurant,color: ColorsManager.error.withOpacity(0.6),)
  ];

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BigText(text: 'Issues ',),
          SizedBox(width: const Size.fromWidth(15).width,),
          SmallText(text: '0'),
        ],
      ),
        collapsed: const SizedBox(), expanded: Card(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: List<Widget>.generate(3, (index) {
              return  ListTile(
                leading: issueIcon[index],
                title: BigText(text: 'title',),
                subtitle: const BigText(text: MockText.longText,maxLines: 3,),
                trailing: BigText(text: 'trailing',),
              );
            }),
          ),
        ),
    ));
  }
}

class BookedServicesCard extends GetView<ReportsController> {
  BookedServicesCard({Key? key}) : super(key: key);

  final List<String> services = ['ROOMS','CONFERENCE'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BigText(text: "Booked Services"),
        Row(
          children: List<Widget>.generate(2, (index) {
            return Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SmallText(text: services[index]),
                      BigText(text: random(0,4).toString())
                    ],
                  ),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}

class PowerStatusCard extends GetView<ReportsController> {
  const PowerStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const BigText(text: 'Power Usage',),
        Card(
          elevation: 1.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          BigText(text:extractDate(DateTime.now())),
                          const Icon(Icons.bolt_sharp,color: Colors.yellow,)
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          SmallText(text:'Units Given'),
                          BigText(text:'687.25'),
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          SmallText(text:'Units Left'),
                          BigText(text:'687.25'),
                        ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          SmallText(text:'Units Used'),
                          BigText(text:'687.25'),
                        ]
                    ),

                  ]
              ),
            )
        ),
      ],
    );
  }
}

class PettyCashTable extends GetView<ReportsController> {
  const PettyCashTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportsController>(
      init: ReportsController(),
        builder: (controller)=>SingleChildScrollView(
          child: controller.pettyCashTransactionAreEmpty.value ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BigText(text: "Petty Cash Transactions"),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,

                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      const SmallText(text: "No Transactions in your session"),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.add,size: 30,))
                    ],
                  ),
                ),
              ),
            ],
          ): PaginatedDataTable(
            arrowHeadColor: ColorsManager.primary,
            header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const BigText(text: 'Petty Cash Transactions',),
            Row(

              children: [
                LabeledText(title: 'Available', subtitle: '${random(100000, 1000000)}',isRow: true,),
                SizedBox(width: const Size.fromWidth(20).width,),
                LabeledText(title: 'Used', subtitle: '${random(100000, 1000000)}',isRow: true,),
              ],
            ),

          ],
        ),
            rowsPerPage: controller.pettyCashTransactions.value.length >= 8 ? 8: controller.pettyCashTransactions.value.length,
            columns: const [
              DataColumn(label: SmallText(text: 'DATE',fontWeight: FontWeight.w600,)),
              DataColumn(label: SmallText(text: 'NAME',fontWeight: FontWeight.w600,)),
              DataColumn(label: SmallText(text: 'DPT',fontWeight: FontWeight.w600,)),
              DataColumn(label: SmallText(text: 'VALUE',fontWeight: FontWeight.w600,)),
              DataColumn(label: SmallText(text: 'REASON',fontWeight: FontWeight.w600,)),
              DataColumn(label: SmallText(text: 'EMPLOYEE ID',fontWeight: FontWeight.w600,)),

            ],
        source: controller.pettyCashSource ?? PettyCashTableSource(pettyCashTransactions: [InternalTransaction()], isEmpty: true),
      ),
    ));
  }
}


