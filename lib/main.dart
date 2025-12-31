import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String display = '0';
  String _input = '';

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _input = '';
        display = '0';
      } else if (buttonText == '±') {
        if (_input.isNotEmpty && _input.startsWith('-')) {
          _input = _input.substring(1);
        } else {
          _input = '-' + _input;
        }
        display = _input;
      } else if (buttonText == '=') {
        display = _calculate(_input);
        _input = display;
      } else {
        _input += buttonText;
        display = _input;
      }
    });
  }

  String _calculate(String input) {
    try {
      String exp = input.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression expression = p.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget buildButton(
    String text, {
    Color? bgColor,
    Color textColor = Colors.white,
    double widthFactor = 1,
  }) {
    return Expanded(
      flex: widthFactor.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor ?? const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(22),
          ),
          onPressed: () => buttonPressed(text),
          child: Text(text, style: TextStyle(fontSize: 28, color: textColor)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Display
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Text(
                  display,
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Buttons
            Column(
              children: [
                Row(
                  children: [
                    buildButton('C', bgColor: const Color(0xFFFF5C5C)),
                    buildButton('±', bgColor: const Color(0xFF505050)),
                    buildButton('%', bgColor: const Color(0xFF505050)),
                    buildButton('÷', bgColor: const Color(0xFFFF9500)),
                  ],
                ),
                Row(
                  children: [
                    buildButton('7'),
                    buildButton('8'),
                    buildButton('9'),
                    buildButton('×', bgColor: const Color(0xFFFF9500)),
                  ],
                ),
                Row(
                  children: [
                    buildButton('4'),
                    buildButton('5'),
                    buildButton('6'),
                    buildButton('-', bgColor: const Color(0xFFFF9500)),
                  ],
                ),
                Row(
                  children: [
                    buildButton('1'),
                    buildButton('2'),
                    buildButton('3'),
                    buildButton('+', bgColor: const Color(0xFFFF9500)),
                  ],
                ),
                Row(
                  children: [
                    buildButton('0', widthFactor: 2),
                    buildButton('.'),
                    buildButton('=', bgColor: const Color(0xFFFF9500)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
