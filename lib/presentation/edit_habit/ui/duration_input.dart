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
  final List<String> _primaryUnits = ['Days', 'Hours', 'Minutes'];
  final Map<String, List<String>> _secondaryUnits = {
    'Days': ['Hours', 'Minutes'],
    'Hours': ['Minutes'],
    'Minutes': []
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
      if (_secondaryUnit == 'Minutes') {
        durationString += '${secondaryValue}M';
      }
    }
    widget.onDurationChanged(durationString);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        TextField(
          controller: _primaryValueController,
          decoration: InputDecoration(labelText: 'Enter primary unit value'),
          keyboardType: TextInputType.number,
          onChanged: (value) => _updateDuration(),
        ),
        if (_secondaryUnits[_primaryUnit]!.isNotEmpty)
          DropdownButton<String>(
            value: _secondaryUnit,
            onChanged: (String? newValue) {
              setState(() {
                _secondaryUnit = newValue!;
                _updateDuration();
              });
            },
            items: _secondaryUnits[_primaryUnit]!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        if (_secondaryUnits[_primaryUnit]!.isNotEmpty)
          TextField(
            controller: _secondaryValueController,
            decoration: InputDecoration(labelText: 'Enter secondary unit value'),
            keyboardType: TextInputType.number,
            onChanged: (value) => _updateDuration(),
          ),
      ],
    );
  }
}
