import 'package:client/capitalize.dart';
import 'package:client/dictionary.dart';
import 'package:client/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Panel extends StatelessWidget {
  Panel(
      {super.key,
      required this.label,
      required this.child,
      this.callback,
      this.form,
      this.header,
      this.rightChild,
      this.closable = false,
      this.loaded = true});

  final Logger _logger = Logger();
  final ThemeProvider _theme = ThemeProvider();

  final String? label;
  final Widget? rightChild;
  final Widget child;
  final Widget? form;
  final Widget? header;
  final bool loaded;
  final bool closable;
  final void Function(BuildContext)? callback;

  Widget showLoading() {
    _logger.d("showLoading");

    var size = _theme.width / 5;
    return Center(
        child: SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: _theme.inactiveBorderColor,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (callback != null) {
      callback?.call(context);
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(_theme.color, BlendMode.modulate),
              child: const Image(
                image: AssetImage("assets/ui/panel-header.png"),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 7, 0, 5),
                    child: Text(
                      label?.capitalize() ?? Dictionary.missing,
                      style: _theme.textExtraLargeBold,
                    ),
                  ),
                  rightChild != null
                      ? rightChild as Widget
                      : closable
                          ? SizedBox(
                              height: 32,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    _theme.colorAccent,
                                    _theme.blendMode,
                                  ),
                                  child: Image.asset(
                                    "assets/ui/close.png",
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                ]),
          ]),
          if (header != null) ...[
            header as Widget,
          ],
          if (form != null) ...[
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: form),
          ],
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: loaded ? child : showLoading(),
            ),
          ),
        ],
      ),
    );
  }
}
