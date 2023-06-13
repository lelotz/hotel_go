import 'package:flutter/material.dart';
class SwitchButton extends StatefulWidget {
  final Function onSwitch;
  SwitchButton({required this.onSwitch,super.key});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool light0 = true;
  bool light1 = true;
  bool light2 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      // Thumb icon when the switch is selected.
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Switch(
          value: light1,
          onChanged: (bool value) {

            widget.onSwitch(value);
            setState(() {
              light1 = value;
            });
          },
        ),
        //Checkbox(value: value, onChanged: onChanged)
      ],
    );
  }
}