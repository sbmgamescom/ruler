import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ruler(
        style: const TextStyle(fontSize: 15, color: Colors.black),
        tickColor: Colors.red,
        showZero: true,
      ),
    );
  }
}

class Ruler extends StatelessWidget {
  final Color? tickColor;
  final TextStyle? style;
  final bool? showZero;

  Ruler({Key? key, this.tickColor, this.style, this.showZero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        foregroundPainter:
            _RulerPainter(context: context, tickColor: tickColor, style: style),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final BuildContext? context;
  final Color? tickColor;
  final TextStyle? style;
  final bool showZero;

  late double dpr;
  _RulerPainter(
      {this.showZero = false, this.tickColor, this.style, this.context}) {
    dpr = MediaQuery.of(context!).devicePixelRatio;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint mmTick = Paint()
      ..color = tickColor!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    Paint cmTick = Paint()
      ..color = tickColor!
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    int ticker = 0;
    double physicaLogicalRatio = 3.2;
    double maxSize = size.height / physicaLogicalRatio * 100 / dpr;
    while (ticker <= maxSize) {
      double y = ticker * physicaLogicalRatio * dpr;
      //print('ticker: $ticker, y: $y');
      if (ticker % 10 == 0) {
        canvas.drawLine(Offset(0, y), Offset(15, y), cmTick);
        var paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle())
          ..pushStyle(style!.getTextStyle())
          ..addText('${ticker ~/ 10}');
        //..pop();
        var paragraph = paragraphBuilder.build()
          ..layout(ui.ParagraphConstraints(width: 20));

        if (ticker != 0.0 || showZero) {
          canvas.drawParagraph(
              paragraph, Offset(20, y - (paragraph.height / 2)));
        }
      } else if (ticker % 5 == 0) {
        canvas.drawLine(Offset(0, y), Offset(10, y), cmTick);
      } else {
        canvas.drawLine(Offset(0, y), Offset(5, y), mmTick);
      }
      ticker++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
