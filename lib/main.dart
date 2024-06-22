//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Calculator App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 0, 0)),
        ),
        home: const HomePage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  // Using strings for now for easier display and concatenation
  String _display = '0'; // Store the input/output display
  String _currentInput = ''; // Store the current number being entered
  String _operator = ''; // Store the selected operator

  String get display => _display;

  void _handleButtonPress(String buttonText) {
    if (buttonText == 'Clear') {
      _clearInput();
    } else if (buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '*' ||
        buttonText == '/' ||
        buttonText == '^' ||
        buttonText == '%' ||
        buttonText == '!') {
      _setOperator(buttonText);
    } else if (buttonText == '=') {
      _calculateResult();
    } else {
      _appendInput(buttonText);
    }
    notifyListeners();
  }

  void _clearInput() {
    _currentInput = '';
    _operator = '';
    _display = '0';
  }

  void _setOperator(String newOperator) {
    if (_currentInput.isNotEmpty) {
      // If there's already an operator, calculate the previous result first
      if (_operator.isNotEmpty) {
        _calculateResult();
      }
      _operator = newOperator;
      _display += ' $newOperator ';
      _currentInput = ''; // Reset current input after storing operator
    }
  }

  void _appendInput(String digit) {
    _currentInput += digit;
    _display = _display == '0' ? digit : _display + digit;
  }

  void _calculateResult() {
    if (_operator.isNotEmpty && _currentInput.isNotEmpty) {
      double num1 = double.parse(_display.split(' ${_operator} ')[0]);
      double num2 = double.parse(_currentInput);

      switch (_operator) {
        case '+':
          _display = (num1 + num2).toString();
        case '-':
          _display = (num1 - num2).toString();
        case '*':
          _display = (num1 * num2).toString();
        case '/':
          _display = (num1 / num2).toString();
        case '^':
          _display = (pow(num1, num2)).toString();
        case '%':
          _display = (num1 % num2).toString();
        case '!':
          var fact = 1;
          for (var i = 1; i <= num1; i++) {
            fact = fact * i;
          }
          _display = (fact).toString();
      }
      _currentInput = ''; // Reset current input after calculation
      _operator = '';
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> buttonLabels = [
    // Clear button
    '+',
    '-',
    '*',
    '/',
    '1',
    '2',
    '3',
    '^',
    '4',
    '5',
    '6',
    '%',
    '7',
    '8',
    '9',
    '!',
    '0',
    '.',
    '=',
    'Clear',
  ];
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      body: Center(
        // Center the calculator horizontally
        child: SizedBox(
          width: 400, // Adjust this value for your desired width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input/Output Display
              Container(
                padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  appState.display,
                  style: TextStyle(fontSize: 48.0),
                ),
              ),
              // Calculator Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemCount: buttonLabels.length,
                  itemBuilder: (BuildContext context, int index) {
                    final buttonText = buttonLabels[index];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onPressed: () {
                        appState._handleButtonPress(buttonText);
                      },
                      child: Text(buttonText),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
