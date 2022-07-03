import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';

class SpringSimulation2D extends ChangeNotifier {
  SpringSimulation2D({
    required TickerProvider tickerProvider,
    required SpringDescription description,
  })  : _tickerProvider = tickerProvider,
        _springDescription = description;

  final TickerProvider _tickerProvider;
  final SpringDescription _springDescription;
  late SpringSimulation _springSimX, _springSimY;

  Offset _prevVelocity = Offset.zero;

  Offset _anchorPosition = Offset.zero;
  Offset get anchorPosition => _anchorPosition;
  set anchorPosition(Offset newPosition) {
    endSpring();
    _anchorPosition = newPosition;
    notifyListeners();
  }

  Offset _springPosition = Offset.zero;
  Offset get springPosition => _springPosition;
  set springPosition(Offset newPosition) {
    endSpring();
    _springPosition = newPosition;
    notifyListeners();
  }

  Ticker? _ticker;

  void startSpring() {
    _springSimX = SpringSimulation(
      _springDescription,
      springPosition.dx,
      _anchorPosition.dx,
      _prevVelocity.dx,
    );

    _springSimY = SpringSimulation(
      _springDescription,
      springPosition.dy,
      _anchorPosition.dy,
      _prevVelocity.dy,
    );

    (_ticker ??= _tickerProvider.createTicker(_onTick)).start();
  }

  void endSpring() => _ticker?.stop();

  void _onTick(Duration elapsedTime) {
    final elapsedTimeFraction = elapsedTime.inMilliseconds / 1000.0;

    _springPosition = Offset(
      _springSimX.x(elapsedTimeFraction),
      _springSimY.x(elapsedTimeFraction),
    );

    _prevVelocity = Offset(
      _springSimX.dx(elapsedTimeFraction),
      _springSimY.dx(elapsedTimeFraction),
    );

    if (_springSimX.isDone(elapsedTimeFraction) &&
        _springSimY.isDone(elapsedTimeFraction)) {
      endSpring();
    }

    notifyListeners();
  }
}
