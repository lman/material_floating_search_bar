import 'package:flutter/material.dart'
    hide ImplicitlyAnimatedWidget, ImplicitlyAnimatedWidgetState;

// ignore_for_file: public_member_api_docs

/// A base Widget for implicit animations.
abstract class ImplicitlyAnimatedWidget extends StatefulWidget {
  final Duration duration;
  final Curve curve;
  const ImplicitlyAnimatedWidget(
    Key key,
    this.duration,
    this.curve,
  )   : assert(duration != null),
        super(key: key);
}

abstract class ImplicitlyAnimatedWidgetState<T,
        W extends ImplicitlyAnimatedWidget> extends State<W>
    with TickerProviderStateMixin {
  AnimationController _controller;

  Animation<double> _animation;

  T get newValue;
  T value;
  T oldValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..value = 1.0;

    _animation = CurvedAnimation(
      curve: widget.curve ?? Curves.linear,
      parent: _controller,
    );

    _animation.addListener(
      () => setState(
        () => value = lerp(oldValue, newValue, _animation.value),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    value = newValue;
    oldValue = newValue;
  }

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.curve != widget.curve) {
      _animation = CurvedAnimation(
        curve: widget.curve ?? Curves.linear,
        parent: _controller,
      );
    }

    if (value != newValue) {
      oldValue = value;
      _controller.reset();
      _controller.forward();
    }
  }

  T lerp(T a, T b, double t);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
