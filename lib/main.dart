import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  String expression = "";
  String result = "0";

  final List<String> buttons = [
    "7","8","9","/",
    "4","5","6","*",
    "1","2","3","-",
    "0",".","=","+",
    "C"
  ];

  bool isOperator(String v) => ["/","*","-","+"].contains(v);

  void onButton(String value) {

    setState(() {

      // CLEAR
      if (value == "C") {
        expression = "";
        result = "0";
        return;
      }

      // EQUAL
      if (value == "=") {
        calculate();
        return;
      }

      // CONTINUE FROM LAST ANSWER
      if (expression.isEmpty && result != "0") {
        expression = result;
        result = "0";
      }

      expression += value;

    });
  }

  void calculate() {

    try {
      final parser = Parser();
      final exp = parser.parse(expression);
      final val = exp.evaluate(EvaluationType.REAL, ContextModel());

      result = val.toString();

      if (result.endsWith('.0')) {
        result = result.replaceAll('.0', '');
      }

      expression = "";

    } catch (e) {
      result = "Error";
      expression = "";
    }
  }

  Widget buildButton(String text) {

    final bool op = isOperator(text);
    final bool equal = (text == "=");

    return Padding(
      padding: const EdgeInsets.all(4),
      child: AspectRatio(
        aspectRatio: 1,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: equal
              ? Colors.deepPurpleAccent
              : op
                ? Colors.grey[700]
                : Colors.grey[850],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => onButton(text),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [

            // DISPLAY PANEL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  // EXPRESSION
                  Text(
                    expression,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // RESULT
                  Text(
                    result,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),

            const Divider(color: Colors.grey),

            // BUTTON GRID LIMITED WIDTH
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 380,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1,
                    ),
                    itemCount: buttons.length,
                    itemBuilder: (context, index) {
                      final text = buttons[index];
                      return buildButton(text);
                    },
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
