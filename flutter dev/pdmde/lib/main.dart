import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String expressao = '';
  String resultado = '';

  void adicionar(String valor) {
    setState(() {
      expressao += valor;
    });
  }

  void limpar() {
    setState(() {
      expressao = '';
      resultado = '';
    });
  }

  void apagar() {
    setState(() {
      if (expressao.isNotEmpty) {
        expressao = expressao.substring(0, expressao.length - 1);
        resultado = '';
      }
    });
  }

  void calcular() {
    try {
      String expr = expressao.replaceAll('×', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();
      double res = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        resultado =
            res.toString().split('.')[1] == '0'
                ? '= ${res.toString().split('.')[0]}'
                : '= $res';
      });
    } catch (e) {
      setState(() {
        resultado = 'Erro';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora da Isa")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(expressao, style: TextStyle(fontSize: 32)),
                  SizedBox(height: 10),
                  Text(
                    resultado,
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [botao('7'), botao('8'), botao('9'), botao('÷')]),
              Row(children: [botao('4'), botao('5'), botao('6'), botao('×')]),
              Row(children: [botao('1'), botao('2'), botao('3'), botao('-')]),
              Row(
                children: [
                  botao('0'),
                  botao(
                    'C',
                    cor: const Color.fromARGB(255, 248, 46, 32),
                    func: limpar,
                  ),
                  botao(
                    '⌫',
                    cor: const Color.fromARGB(255, 179, 103, 16),
                    func: apagar,
                  ),
                  botao('+'),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: calcular,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        backgroundColor: const Color.fromARGB(
                          255,
                          245,
                          99,
                          184,
                        ),
                      ),
                      child: Text(
                        '=',
                        style: TextStyle(
                          fontSize: 24,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget botao(String texto, {Color cor = Colors.black, VoidCallback? func}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: func ?? () => adicionar(texto),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            backgroundColor: const Color.fromARGB(255, 248, 184, 216),
          ),
          child: Text(texto, style: TextStyle(fontSize: 24, color: cor)),
        ),
      ),
    );
  }
}
