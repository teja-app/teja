import 'package:flutter/material.dart';

class DurationInputWidget extends StatefulWidget {
  final Function(String) onDurationChanged;

  DurationInputWidget({required this.onDurationChanged});

  @override
  _DurationInputWidgetState createState() => _DurationInputWidgetState();
}

class _DurationInputWidgetState extends State<DurationInputWidget> {
  final TextEditingController _primaryValueController = TextEditingController();
  final TextEditingController _secondaryValueController = TextEditingController();
  String _primaryUnit = 'Days';
  String _secondaryUnit = 'Hours';
  final List<String> _primaryUnits = ['Days', 'Hours', 'Mins'];
  final Map<String, List<String>> _secondaryUnits = {
    'Days': ['Hours', 'Mins'],
    'Hours': ['Mins'],
    'Mins': []
  };

  void _updateDuration() {
    int primaryValue = int.tryParse(_primaryValueController.text) ?? 0;
    int secondaryValue = int.tryParse(_secondaryValueController.text) ?? 0;
    String durationString = 'P';
    if (_primaryUnit == 'Days') {
      durationString += '${primaryValue}D';
    } else {
      if (_primaryUnit == 'Hours') {
        durationString += 'T${primaryValue}H';
      }
      if (_secondaryUnit == 'Mins') {
        durationString += '${secondaryValue}M';
      }
    }
    widget.onDurationChanged(durationString);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 100, // Reduced width for primary value
          child: TextField(
            controller: _primaryValueController,
            decoration: const InputDecoration(
              labelText: 'Value',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: _primaryUnit,
          onChanged: (String? newValue) {
            setState(() {
              _primaryUnit = newValue!;
              _secondaryUnit = _secondaryUnits[_primaryUnit]!.isNotEmpty ? _secondaryUnits[_primaryUnit]![0] : '';
              _updateDuration();
            });
          },
          items: _primaryUnits.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        if (_secondaryUnits[_primaryUnit]!.isNotEmpty) ...[
          const SizedBox(width: 8),
          SizedBox(
            width: 100, // Reduced width for secondary value
            child: TextField(
              controller: _secondaryValueController,
              decoration: const InputDecoration(
                labelText: 'Add',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 8),
          Text(_secondaryUnits[_primaryUnit]![0]),
        ],
      ],
    );
  }
}
