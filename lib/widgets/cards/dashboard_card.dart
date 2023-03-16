import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';
import 'package:hotel_pms/core/utils/dim_logic.dart';
import '../text/big_text.dart';
import '../text/small_text.dart';


class DashboardCard extends StatefulWidget {
  String title;
  String subtitle;
  Color backgroundColor;
  Function onTap;

   DashboardCard({
    Key? key,
     required this.title,
     required this.subtitle,
     required this.onTap,
     this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {



  @override
  Widget build(BuildContext context) {

    double currentScreenWidth = MediaQuery.of(context).size.width;
    double currentScreenHeight = MediaQuery.of(context).size.height;



    return InkWell(
      onTap: widget.onTap(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.radius4),
          border: Border.all(width: 2,color: Colors.white),
          color: widget.backgroundColor,
        ),

        child: Padding(
          padding: const EdgeInsets.only(left: AppSize.size12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BigText(text: widget.subtitle, size: 30,color: Colors.white,),

              SmallText(text: widget.title,size: 30,color: Colors.white,)
  ]
          ),
        )
      ),
    );
  }
}
