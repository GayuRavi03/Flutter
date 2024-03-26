import 'package:flutter/material.dart';
import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String first = "";
  String opp = "";
  String second = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text(
          'Calculator',
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _getDisplayValue(),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // Buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButtgit on(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  String _getDisplayValue() {
    if (opp.isEmpty) {
      return first;
    } else {
      return second.isEmpty ? first : second;
    }
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isOperator(String value) {
    return value == Btn.add ||
        value == Btn.subtract ||
        value == Btn.multiply ||
        value == Btn.divide;
  }

  void calculate() {
    final int num1 = int.parse(first);
    final int num2 = int.parse(second);
    var result = 0;
    switch (opp) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 ~/ num2; // Use integer division
        break;
      default:
    }

    setState(() {
      first = result.toString();
      opp = "";
      second = "";
    });
  }

  void clearAll() {
    setState(() {
      first = "";
      opp = "";
      second = "";
    });
  }

  void delete() {
    if (second.isNotEmpty) {
      second = second.substring(0, second.length - 1);
    } else if (opp.isNotEmpty) {
      opp = "";
    } else if (first.isNotEmpty) {
      first = first.substring(0, first.length - 1);
    }
    setState(() {});
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.calculate) {
      if (first.isNotEmpty && second.isNotEmpty) {
        calculate();
      }
      return;
    }

    if (isOperator(value)) {
      if (first.isNotEmpty && second.isNotEmpty) {
        calculate();
      }
      setState(() {
        opp = value;
      });
    } else {
      setState(() {
        if (opp.isEmpty) {
          first += value;
        } else {
          second += value;
        }
      });

      // Perform calculation if both operands are entered
      if (opp.isNotEmpty && second.isNotEmpty) {
        calculate();
      }
    }
  }

  Color getBtnColor(String value) {
    if (isOperator(value) && opp == value) {
      return Colors.deepOrangeAccent;
    }
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.deepOrangeAccent
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.blueGrey
            : Colors.black87;
  }
}
