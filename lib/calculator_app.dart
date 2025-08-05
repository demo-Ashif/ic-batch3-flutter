import 'package:flutter/material.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  // Variables to store calculator state
  String _display = '0';
  String _firstNumber = '';
  String _operation = '';
  bool _isNewNumber = true;

  // Method to add a digit to the display
  void _addDigit(String digit) {
    setState(() {
      if (_isNewNumber) {
        // Start a new number
        _display = digit;
        _isNewNumber = false;
      } else {
        // Add digit to existing number
        if (_display == '0') {
          _display = digit;
        } else {
          _display += digit;
        }
      }
    });
  }

  // Method to add decimal point
  void _addDecimal() {
    setState(() {
      if (_isNewNumber) {
        // Start with 0.
        _display = '0.';
        _isNewNumber = false;
      } else if (!_display.contains('.')) {
        // Add decimal if not already present
        _display += '.';
      }
    });
  }

  // Method to set operation
  void _setOperation(String operation) {
    setState(() {
      _firstNumber = _display;
      _operation = operation;
      _isNewNumber = true;
    });
  }

  // Method to calculate result
  void _calculate() {
    if (_firstNumber.isNotEmpty && _operation.isNotEmpty) {
      setState(() {
        double first = double.parse(_firstNumber);
        double second = double.parse(_display);
        double result = 0;

        // Perform calculation based on operation
        switch (_operation) {
          case '+':
            result = first + second;
            break;
          case '-':
            result = first - second;
            break;
          case '×':
            result = first * second;
            break;
          case '÷':
            if (second != 0) {
              result = first / second;
            } else {
              _display = 'Error';
              _isNewNumber = true;
              _firstNumber = '';
              _operation = '';
              return;
            }
            break;
        }

        // Display result
        _display = result.toString();
        if (_display.endsWith('.0')) {
          _display = _display.substring(0, _display.length - 2);
        }

        _isNewNumber = true;
        _firstNumber = '';
        _operation = '';
      });
    }
  }

  // Method to clear everything
  void _clear() {
    setState(() {
      _display = '0';
      _firstNumber = '';
      _operation = '';
      _isNewNumber = true;
    });
  }

  // Method to clear last entry
  void _clearEntry() {
    setState(() {
      _display = '0';
      _isNewNumber = true;
    });
  }

  // Method to change sign
  void _changeSign() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧮 Calculator App'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info section for beginners
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 How setState() works here:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• When you press numbers: setState() updates _display\n'
                    '• When you press operation: setState() stores first number\n'
                    '• When you press =: setState() calculates and shows result\n'
                    '• When you press C: setState() resets all variables\n'
                    '• Multiple variables change together in one setState()',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _operation.isNotEmpty ? '$_firstNumber $_operation' : '',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Calculator buttons
            Expanded(
              child: Column(
                children: [
                  // Row 1
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildButton('C', Colors.red, _clear)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton('CE', Colors.red, _clearEntry),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton('±', Colors.orange, _changeSign),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '÷',
                            Colors.orange,
                            () => _setOperation('÷'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Row 2
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            '7',
                            Colors.grey[300]!,
                            () => _addDigit('7'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '8',
                            Colors.grey[300]!,
                            () => _addDigit('8'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '9',
                            Colors.grey[300]!,
                            () => _addDigit('9'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '×',
                            Colors.orange,
                            () => _setOperation('×'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Row 3
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            '4',
                            Colors.grey[300]!,
                            () => _addDigit('4'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '5',
                            Colors.grey[300]!,
                            () => _addDigit('5'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '6',
                            Colors.grey[300]!,
                            () => _addDigit('6'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '-',
                            Colors.orange,
                            () => _setOperation('-'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Row 4
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildButton(
                            '1',
                            Colors.grey[300]!,
                            () => _addDigit('1'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '2',
                            Colors.grey[300]!,
                            () => _addDigit('2'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '3',
                            Colors.grey[300]!,
                            () => _addDigit('3'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '+',
                            Colors.orange,
                            () => _setOperation('+'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Row 5
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildButton(
                            '0',
                            Colors.grey[300]!,
                            () => _addDigit('0'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton(
                            '.',
                            Colors.grey[300]!,
                            _addDecimal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildButton('=', Colors.green, _calculate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String text,
    Color color,
    VoidCallback onPressed, {
    int span = 1,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor:
            color == Colors.grey[300] ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
