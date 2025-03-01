import 'package:flutter/material.dart';

import 'package:eventify/eventify.dart';
import 'package:logger/logger.dart';

class ModalProvider extends EventEmitter {
  static final ModalProvider _instance = ModalProvider._internal();

  factory ModalProvider() {
    return _instance;
  }

  final Logger _logger = Logger(level: Logger.level);

  final List<Widget> _modals = <Widget>[];
  bool get haveModals => _modals.isNotEmpty;

  ModalProvider._internal() {
    _logger.d("Created");
  }

  void addModal(Widget modal) {
    _logger.d("addModal");
    _modals.add(modal);
  }

  void popModal() {
    _logger.d("popModal");

    if (_modals.isNotEmpty) {
      _modals.removeLast();
    }
  }

  void render() {
    _logger.t("render");
  }
}
