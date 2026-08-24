import 'package:flutter/foundation.dart';

/// Base controller class for MVI (Model-View-Intent) architecture.
/// 
/// - [I] represents the Intent (user action or event).
/// - [S] represents the immutable State.
abstract class MviController<I, S> extends ValueNotifier<S> {
  MviController(super.initialState);

  /// Helper to emit a new immutable state to listeners.
  @protected
  void emit(S newState) {
    value = newState;
  }

  /// Single entry point for processing user actions/intents.
  void onIntent(I intent);
}
