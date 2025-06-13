import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _operand = '';
  String _history = '';
  double? _currentValue;
  double? _previousValue;
  bool _newCalculation = true;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _operand = '';
        _history = '';
        _currentValue = null;
        _previousValue = null;
        _newCalculation = true;
      } else if (value == '<') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (value == '+' || value == '-' || value == 'x' || value == '÷') {
        if (_display.isNotEmpty) {
          _currentValue = double.parse(_display);
          if (_previousValue != null) {
            _previousValue =
                _calculateResult(_previousValue!, _currentValue!, _operand);
          } else {
            _previousValue = _currentValue;
          }
          _operand = value;
          _history = "$_previousValue $_operand";
          _display = '0';
          _newCalculation = false;
        }
      } else if (value == '=') {
        if (_previousValue != null &&
            _operand.isNotEmpty &&
            _display.isNotEmpty) {
          _currentValue = double.parse(_display);
          _previousValue =
              _calculateResult(_previousValue!, _currentValue!, _operand);
          _history += ' $_currentValue =';
          _display = _previousValue.toString();
          _operand = '';
          _newCalculation = true;
        }
      } else {
        if (_display == '0' || _newCalculation) {
          _display = value;
          if (_newCalculation) {
            _history = '';
          }
          _newCalculation = false;
        } else {
          _display += value;
        }
      }
    });
  }

  double _calculateResult(double first, double second, String operand) {
    switch (operand) {
      case '+':
        return first + second;
      case '-':
        return first - second;
      case 'x':
        return first * second;
      case '÷':
        return second != 0 ? first / second : 0;
      default:
        return second;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          (_display == '0' && _history == '')
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Do - Calc",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _history,
                    style: const TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                  Text(
                    _display,
                    style: const TextStyle(fontSize: 80, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          _buildButtonRow(['C', '<', '÷', 'x'], Colors.orange, Colors.white),
          _buildButtonRow(
              ['7', '8', '9', '-'], Colors.grey[850]!, Colors.white),
          _buildButtonRow(
              ['4', '5', '6', '+'], Colors.grey[850]!, Colors.white),
          _buildButtonRow(
              ['1', '2', '3', '='], Colors.grey[850]!, Colors.white),
          _buildButtonRow(['0'], Colors.grey[850]!, Colors.white),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons, Color bgColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons
          .map((button) => _buildButton(button, bgColor, textColor))
          .toList(),
    );
  }

  Widget _buildButton(String value, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(value),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: bgColor,
          foregroundColor: textColor,
        ),
        child: Text(
          value,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
