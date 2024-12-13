// lib/ffi/bindings.dart
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

// Define the callback signature
typedef ConnectionResultCallbackNative = Void Function(
    Int32 success, Pointer<Utf8> message);
typedef ConnectionResultCallbackDart = void Function(
    int success, String message);

// Define the function signatures
typedef BluetoothInitNative = Int32 Function();
typedef BluetoothInitDart = int Function();

typedef BluetoothStartNative = Int32 Function(
  Pointer<NativeFunction<ConnectionResultCallbackNative>> callback,
);
typedef BluetoothStartDart = int Function(
  Pointer<NativeFunction<ConnectionResultCallbackNative>> callback,
);

typedef BluetoothStopNative = Void Function();
typedef BluetoothStopDart = void Function();

class BluetoothBindings {
  late DynamicLibrary _lib;

  late BluetoothInitDart bluetooth_init;
  late BluetoothStartDart bluetooth_start;
  late BluetoothStopDart bluetooth_stop;

  BluetoothBindings() {
    // Load the shared library
    if (Platform.isLinux) {
      _lib = DynamicLibrary.open('libbluetooth_service.so');
    } else {
      throw UnsupportedError('This library is only supported on Linux.');
    }

    // Lookup the functions
    bluetooth_init = _lib
        .lookup<NativeFunction<BluetoothInitNative>>('bluetooth_init')
        .asFunction();

    bluetooth_start = _lib
        .lookup<NativeFunction<BluetoothStartNative>>('bluetooth_start')
        .asFunction();

    bluetooth_stop = _lib
        .lookup<NativeFunction<BluetoothStopNative>>('bluetooth_stop')
        .asFunction();
  }
}
