// singleton class responsible for showing the loading dialog
import 'dart:async';
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';

import 'loading_screen_controller.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

// can't be immutable as need to have a reference to controller
class LoadingScreen {
  LoadingScreen._sharedInstance();

  static final LoadingScreen _instance = LoadingScreen._sharedInstance();

  factory LoadingScreen.instance() => _instance;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    String message = Strings.loading,
  }) {
    if (_controller?.update(message) ?? false) {
      return;
    } else {
      _controller = showOverlay(
        context: context,
        message: message,
      );
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  // we have a function that creates the LoadingScreenController
  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String message,
  }) {
    final state = Overlay.of(context);
    if (state == null) {
      return null;
    }

    final textController = StreamController<String>();
    textController.add(message);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(100),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * .8,
                maxHeight: size.height * .8,
                minWidth: size.width * .5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder<String>(
                          stream: textController.stream,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                textAlign: TextAlign.center,
                                snapshot.data as String,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
