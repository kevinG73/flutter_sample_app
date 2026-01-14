import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculatrice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _currentInput = '';
  double? _firstOperand;
  String? _operator;
  bool _shouldResetDisplay = false;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_shouldResetDisplay) {
        _display = digit;
        _currentInput = digit;
        _shouldResetDisplay = false;
      } else {
        if (_display == '0' && digit != '.') {
          _display = digit;
          _currentInput = digit;
        } else {
          if (digit == '.' && _display.contains('.')) {
            return;
          }
          _display += digit;
          _currentInput += digit;
        }
      }
    });
  }

  void _onOperatorPressed(String operator) {
    setState(() {
      if (_firstOperand == null) {
        _firstOperand = double.tryParse(_display);
        _operator = operator;
        _shouldResetDisplay = true;
      } else if (!_shouldResetDisplay) {
        _calculate();
        _operator = operator;
        _shouldResetDisplay = true;
      } else {
        _operator = operator;
      }
    });
  }

  void _calculate() {
    if (_firstOperand == null || _operator == null) return;

    final secondOperand = double.tryParse(_currentInput);
    if (secondOperand == null) return;

    double result;
    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '*':
        result = _firstOperand! * secondOperand;
        break;
      case '/':
        if (secondOperand == 0) {
          setState(() {
            _display = 'Erreur';
            _clear();
          });
          return;
        }
        result = _firstOperand! / secondOperand;
        break;
      default:
        return;
    }

    setState(() {
      if (result == result.toInt()) {
        _display = result.toInt().toString();
      } else {
        _display = result.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      _firstOperand = result;
      _currentInput = _display;
    });
  }

  void _onEqualsPressed() {
    _calculate();
    setState(() {
      _operator = null;
      _shouldResetDisplay = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _currentInput = '';
      _firstOperand = null;
      _operator = null;
      _shouldResetDisplay = false;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
        _currentInput = _display;
      } else {
        _display = '0';
        _currentInput = '';
      }
    });
  }

  void _onPercentPressed() {
    setState(() {
      final value = double.tryParse(_display);
      if (value != null) {
        final result = value / 100;
        if (result == result.toInt()) {
          _display = result.toInt().toString();
        } else {
          _display = result.toString();
        }
        _currentInput = _display;
      }
    });
  }

  void _onPlusMinusPressed() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
        _currentInput = _display;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildButtonRow(['C', '+/-', '%', '/']),
                    const SizedBox(height: 8),
                    _buildButtonRow(['7', '8', '9', '*']),
                    const SizedBox(height: 8),
                    _buildButtonRow(['4', '5', '6', '-']),
                    const SizedBox(height: 8),
                    _buildButtonRow(['1', '2', '3', '+']),
                    const SizedBox(height: 8),
                    _buildButtonRow(['0', '.', '<-', '=']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((button) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildButton(button),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String text) {
    Color backgroundColor;
    Color textColor = Colors.white;
    VoidCallback onPressed;

    if (text == 'C' || text == '+/-' || text == '%') {
      backgroundColor = Colors.grey.shade600;
      textColor = Colors.black;
    } else if (text == '/' || text == '*' || text == '-' || text == '+' || text == '=') {
      backgroundColor = Colors.orange;
    } else {
      backgroundColor = Colors.grey.shade800;
    }

    switch (text) {
      case 'C':
        onPressed = _clear;
        break;
      case '+/-':
        onPressed = _onPlusMinusPressed;
        break;
      case '%':
        onPressed = _onPercentPressed;
        break;
      case '<-':
        onPressed = _onBackspace;
        break;
      case '=':
        onPressed = _onEqualsPressed;
        break;
      case '+':
      case '-':
      case '*':
      case '/':
        onPressed = () => _onOperatorPressed(text);
        break;
      default:
        onPressed = () => _onDigitPressed(text);
    }

    return SizedBox.expand(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
