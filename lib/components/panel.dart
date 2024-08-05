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
      this.closable = false,
      this.loaded = true});

  // final Logger _logger = Logger( level: Logger.level );
  final Logger _logger = Logger(level: Level.off);
  final ThemeProvider _theme = ThemeProvider();

  final String? label;
  final Widget child;
  final Widget? form;
  final bool loaded;
  final bool closable;
  final void Function(BuildContext)? callback;
  final TextStyle _style = const TextStyle(
      fontSize: 20, color: Colors.white, decoration: TextDecoration.none);

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

    _logger.w(_theme.color);

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
                      style: _style,
                    ),
                  ),
                  closable
                      ? SizedBox(
                          height: 32,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                // _theme.color,
                                // _theme.blendMode,
                                // _theme.color,
                                _theme.colorAccent,
                                _theme.blendMode,
                              ),
                              child: Image.asset(
                                "assets/ui/close.png",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            // Image.asset( "assets/ui/close.png", fit: BoxFit.fitHeight, height: 50, ),
                          ),
                        )
                      : Container(),
                ]),
          ]),
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
