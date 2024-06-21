import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(StringCalculatorApp());
}

class StringCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'String Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  TextEditingController _controller = TextEditingController();
  String _totalCount = "";
  int _numCount = 0;
  int _mathSymbolCount = 0;
  int _invalidSymbolCount = 0;

  void _calculate() {
    String input = _controller.text;
    _countCharacters(input);
    if (_invalidSymbolCount > 0) {
      setState(() {
        _totalCount = "Invalid";
      });
    } else {
      try {
        Parser p = Parser();
        Expression exp = p.parse(input);
        ContextModel cm = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, cm);
        setState(() {
          _totalCount = eval.toStringAsFixed(2);
        });
      } catch (e) {
        setState(() {
          _totalCount = "Error";
        });
      }
    }
  }

  void _countCharacters(String input) {
    RegExp numberRegExp = RegExp(r'\d+');
    RegExp mathSymbolRegExp = RegExp(r'[+\-*/%]');
    RegExp invalidSymbolRegExp = RegExp(r'[^\d+\-*/% ]');

    setState(() {
      _numCount = numberRegExp.allMatches(input).length;
      _mathSymbolCount = mathSymbolRegExp.allMatches(input).length;
      _invalidSymbolCount = invalidSymbolRegExp.allMatches(input).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('String Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter expression',
                labelStyle: TextStyle(color: Colors.blue),
              ),
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Calculate'),
            ),
            SizedBox(height: 20),
            Text(
              'Numbers: $_numCount',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            Text(
              'Math Symbols: $_mathSymbolCount',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            Text(
              'Invalid Symbols: $_invalidSymbolCount',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            SizedBox(height: 20),
            Text(
              'Total: $_totalCount',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
