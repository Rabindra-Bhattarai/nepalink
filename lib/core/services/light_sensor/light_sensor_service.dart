import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sensors_plus/flutter_sensors_plus.dart';
import 'package:nepalink/core/providers/theme_provider.dart';

final lightSensorServiceProvider = Provider<LightSensorService>((ref) {
  return LightSensorService(ref);
});

class LightSensorService {
  final Ref _ref;
  StreamSubscription<dynamic>? _subscription;
  bool _isRunning = false;

  // Android TYPE_LIGHT = 5
  static const int _typeLightSensor = 5;

  LightSensorService(this._ref);

  Future<void> start() async {
    if (_isRunning) return;

    try {
      // Check if light sensor is available on device
      final isAvailable = await SensorManager().isSensorAvailable(
        _typeLightSensor,
      );

      if (!isAvailable) {
        debugPrint('💡 Light sensor not available on this device');
        return;
      }

      // Get the light sensor stream
      final stream = await SensorManager().sensorUpdates(
        sensorId: _typeLightSensor,
      );

      _subscription = stream.listen(
        (SensorEvent event) {
          // event.data[0] is the lux value
          final lux = event.data[0];
          debugPrint('💡 Light sensor: $lux lux');

          final isEnabled = _ref.read(lightSensorEnabledProvider);
          if (isEnabled) {
            _ref.read(themeModeProvider.notifier).setFromLux(lux);
          }
        },
        onError: (e) {
          debugPrint('Light sensor error: $e');
        },
        cancelOnError: false,
      );

      _isRunning = true;
      debugPrint('💡 Light sensor started successfully');
    } catch (e) {
      debugPrint('Light sensor failed to start: $e');
      _isRunning = false;
    }
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _isRunning = false;
    debugPrint('💡 Light sensor stopped');
  }

  bool get isRunning => _isRunning;
}
