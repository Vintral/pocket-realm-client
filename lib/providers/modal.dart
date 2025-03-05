import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

class ModalProvider extends EventEmitter {
  static final ModalProvider _instance = ModalProvider._internal();

  factory ModalProvider() {
    return _instance;
  }

  final Logger _logger = Logger();

  final List<Widget> _modals = <Widget>[];
  bool get haveModals => _modals.isNotEmpty;

  ModalProvider._internal() {
    _logger.d("Created");
  }

  void addModal(Widget modal) {
    _logger.d("addModal");

    _modals.add(modal);
    emit("UPDATED");
  }

  void popModal() {
    _logger.d("popModal");

    if (_modals.isNotEmpty) {
      _modals.removeLast();
      emit("UPDATED");
    }
  }

  void removeModal(Type type) {
    _logger.t("removeModal: $type");

    for (var i = 0; i < _modals.length; i++) {
      if (_modals[i].runtimeType == type) {
        _modals.removeAt(i);
        break;
      }
    }

    emit("UPDATED");
  }

  Widget buildModal(Widget modal) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => popModal(),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Center(
          child: GestureDetector(
            onTap: () => {},
            child: modal,
          ),
        ),
      ),
    );
  }

  List<Widget> build() {
    _logger.t("build");

    return _modals.map((modal) => buildModal(modal)).toList();
  }
}
