import 'package:flutter/material.dart';

import 'cap_playground.widget.dart';
import 'rope.painter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2D Spring Simulation'),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: CapPlayground(
          background: Image.asset(
            'assets/wine.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.multiply,
          ),
          builder: (springPosition, anchorPosition) {
            return [
              CustomPaint(
                painter: Rope(
                  anchor: anchorPosition,
                  spring: springPosition,
                ),
              ),
              Transform.translate(
                offset: springPosition,
                child: FractionalTranslation(
                  translation: const Offset(-0.5, -0.5),
                  child: SizedBox.square(
                    dimension: MediaQuery.of(context).size.width * 0.3,
                    child: Image.asset('assets/crown_cap.png'),
                  ),
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}
