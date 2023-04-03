
import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';


class EmptyIllustration extends StatelessWidget {
  const EmptyIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: UnDraw(
        color: Theme.of(context).primaryColor,
        illustration: UnDrawIllustration.empty,
      )
    );
  }
}

// Widget emptyIllustration(){
//   return FittedBox(
//     child: UnDraw(
//       color: Theme.of(context).primaryColor,
//       illustration: UnDrawIllustration.empty,
//     ),
//
//   );
// }