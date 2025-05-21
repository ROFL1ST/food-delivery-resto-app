import 'package:flutter/material.dart';
class CustomSwitch extends StatefulWidget {
  final String label;
  final bool value;
  final Function(bool) onChanged;

  const CustomSwitch({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  void _handleSwitch(bool newValue) {
    setState(() {
      _currentValue = newValue;
    });
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(widget.label),
      Switch(
        value: _currentValue,
        onChanged: _handleSwitch,
      ),
    ],
  );
  }
}
