import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  Loading({@required this.isLoading, @required this.child});

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    } else {
      return Stack(
        children: <Widget>[
          child,
          Opacity(
            opacity: 0.3,
            child: ModalBarrier(
              barrierSemanticsDismissible: false,
              color: Colors.grey,
            ),
          ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
    }
  }
}
