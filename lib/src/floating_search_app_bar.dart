// ignore_for_file: public_member_api_docs

part of 'floating_search_bar.dart';

typedef OnQueryChangedCallback = void Function(String query);

typedef OnFocusChangedCallback = void Function(bool isFocused);

class FloatingSearchAppBar extends ImplicitAnimation {
  final Key barKey;

  /// The widget displayed below the [FloatingSearchAppBar].
  final Widget body;

  // * --- Style properties --- *

  final Color accentColor;
  final Color backgroundColor;
  final Color colorOnScroll;
  final Color shadowColor;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry insets;
  final double height;
  final double elevation;
  final double liftOnScrollElevation;
  final TextStyle hintStyle;
  final TextStyle queryStyle;
  final Brightness brightness;

  // * --- Utility --- *
  final Widget bottom;
  final bool clearQueryOnClose;
  final bool showDrawerHamburger;
  final dynamic progress;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final Duration debounceDelay;
  final Widget title;
  final String hint;
  final List<Widget> actions;
  final List<Widget> startActions;
  final OnQueryChangedCallback onQueryChanged;
  final OnQueryChangedCallback onSubmitted;
  final OnFocusChangedCallback onFocusChanged;
  final FloatingSearchBarController controller;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool autocorrect;
  final ToolbarOptions toolbarOptions;
  const FloatingSearchAppBar({
    this.barKey,
    Duration implicitDuration = const Duration(milliseconds: 500),
    Curve implicitCurve = Curves.linear,
    @required this.body,
    this.accentColor,
    this.backgroundColor,
    this.colorOnScroll,
    this.shadowColor,
    this.iconColor,
    this.padding,
    this.insets,
    this.height = 56.0,
    this.elevation = 0.0,
    this.liftOnScrollElevation = 4.0,
    this.hintStyle,
    this.queryStyle,
    this.brightness,
    this.bottom,
    this.clearQueryOnClose = true,
    this.showDrawerHamburger = true,
    this.progress = 0.0,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.transitionCurve = Curves.easeOut,
    this.debounceDelay = Duration.zero,
    this.title,
    this.hint = 'Search...',
    this.actions,
    this.startActions,
    this.onQueryChanged,
    this.onSubmitted,
    this.onFocusChanged,
    this.controller,
    this.textInputAction = TextInputAction.search,
    this.textInputType = TextInputType.text,
    this.autocorrect = true,
    this.toolbarOptions,
  }) : super(null, implicitDuration, implicitCurve);

  static FloatingSearchAppBarState of(BuildContext context) {
    return context.findAncestorStateOfType<FloatingSearchAppBarState>();
  }

  @override
  _FloatingSearchBarAnimationState createState() => _FloatingSearchBarAnimationState();
}

class _FloatingSearchBarAnimationState
    extends ImplicitAnimationState<FloatingSearchAppBarStyle, FloatingSearchAppBar> {
  bool get hasActions => actions.isNotEmpty;
  List<Widget> get actions {
    final actions = widget.actions ?? [FloatingSearchBarAction.searchToClear()];
    final showHamburger =
        widget.showDrawerHamburger && (Scaffold.of(context)?.hasEndDrawer ?? false);
    return showHamburger
        ? <Widget>[...actions, FloatingSearchBarAction.hamburgerToBack()]
        : actions;
  }

  bool get hasStartActions => startActions.isNotEmpty;
  List<Widget> get startActions {
    final actions = widget.startActions ?? const <Widget>[];
    final showHamburger =
        widget.showDrawerHamburger && (Scaffold.of(context)?.hasDrawer ?? false);

    Widget leading;
    if (showHamburger) {
      leading = FloatingSearchBarAction.hamburgerToBack();
    } else if (Navigator.canPop(context) || widget.body != null) {
      leading = FloatingSearchBarAction.back(showIfClosed: Navigator.canPop(context));
    }

    return leading != null ? <Widget>[leading, ...actions] : actions;
  }

  @override
  FloatingSearchAppBarStyle get newValue {
    final theme = Theme.of(context);
    final appBar = theme.appBarTheme;
    final direction = Directionality.of(context);

    return FloatingSearchAppBarStyle(
      accentColor: widget.accentColor ?? theme.accentColor,
      backgroundColor: widget.backgroundColor ?? theme.cardColor ?? Colors.white,
      iconColor: widget.iconColor ?? theme.iconTheme.color,
      colorOnScroll: widget.colorOnScroll ?? appBar.color,
      shadowColor: widget.shadowColor ?? appBar.shadowColor ?? Colors.black54,
      elevation: widget.elevation ?? appBar.elevation,
      liftOnScrollElevation:
          widget.liftOnScrollElevation ?? widget.elevation ?? appBar.elevation,
      height: widget.height ?? kToolbarHeight,
      padding: widget.padding?.resolve(direction) ??
          EdgeInsetsDirectional.only(
            start: hasStartActions ? 12 : 16,
            end: hasActions ? 12 : 16,
          ).resolve(direction),
      insets: widget.insets?.resolve(direction) ??
          EdgeInsetsDirectional.only(
            start: hasStartActions ? 16 : 0,
            end: hasActions ? 16 : 0,
          ).resolve(direction),
      hintStyle: widget.hintStyle,
      queryStyle: widget.queryStyle,
    );
  }

  @override
  Widget builder(BuildContext context, FloatingSearchAppBarStyle style) {
    print(style.backgroundColor.computeLuminance());
    return _FloatingSearchAppBar(
      key: widget.barKey,
      body: widget.body,
      style: style,
      brightness: widget.brightness,
      bottom: widget.bottom,
      clearQueryOnClose: widget.clearQueryOnClose,
      showDrawerHamburger: widget.showDrawerHamburger,
      progress: widget.progress,
      transitionDuration: widget.transitionDuration,
      transitionCurve: widget.transitionCurve,
      debounceDelay: widget.debounceDelay,
      title: widget.title,
      hint: widget.hint,
      actions: actions,
      startActions: startActions,
      onQueryChanged: widget.onQueryChanged,
      onSubmitted: widget.onSubmitted,
      onFocusChanged: widget.onFocusChanged,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      textInputType: widget.textInputType,
      autocorrect: widget.autocorrect,
      toolbarOptions: widget.toolbarOptions,
      implicitCurve: widget.curve,
      implicitDuration: widget.duration,
    );
  }

  @override
  FloatingSearchAppBarStyle lerp(
    FloatingSearchAppBarStyle a,
    FloatingSearchAppBarStyle b,
    double t,
  ) =>
      a.scaleTo(b, t);
}

class _FloatingSearchAppBar extends StatefulWidget {
  final FloatingSearchAppBarStyle style;

  final Widget body;
  final Widget bottom;
  final Brightness brightness;
  final bool clearQueryOnClose;
  final bool showDrawerHamburger;
  final dynamic progress;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final Duration debounceDelay;
  final Widget title;
  final String hint;
  final List<Widget> actions;
  final List<Widget> startActions;
  final OnQueryChangedCallback onQueryChanged;
  final OnQueryChangedCallback onSubmitted;
  final OnFocusChangedCallback onFocusChanged;
  final FloatingSearchBarController controller;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool autocorrect;
  final ToolbarOptions toolbarOptions;
  final Duration implicitDuration;
  final Curve implicitCurve;
  const _FloatingSearchAppBar({
    Key key,
    @required this.style,
    @required this.body,
    @required this.bottom,
    @required this.brightness,
    @required this.clearQueryOnClose,
    @required this.showDrawerHamburger,
    @required this.progress,
    @required this.transitionDuration,
    @required this.transitionCurve,
    @required this.debounceDelay,
    @required this.title,
    @required this.hint,
    @required this.actions,
    @required this.startActions,
    @required this.onQueryChanged,
    @required this.onSubmitted,
    @required this.onFocusChanged,
    @required this.controller,
    @required this.textInputAction,
    @required this.textInputType,
    @required this.autocorrect,
    @required this.toolbarOptions,
    @required this.implicitDuration,
    @required this.implicitCurve,
  }) : super(key: key);

  @override
  FloatingSearchAppBarState createState() => FloatingSearchAppBarState();
}

class FloatingSearchAppBarState extends State<_FloatingSearchAppBar>
    with TickerProviderStateMixin {
  final ValueNotifier<String> queryNotifer = ValueNotifier('');
  final Handler _handler = Handler();

  AnimationController controller;
  Animation transitionAnimation;

  AnimationController scrollController;
  Animation scrollAnimation;

  TextController _input;

  bool _isAtTop = true;
  bool get isAtTop => _isAtTop;

  bool get isAppBar => widget.body != null;
  double get _statusBarHeight => MediaQuery.of(context).viewPadding.top;

  String get query => queryNotifer.value;

  double get height => style.height;
  double get elevation => style.elevation;
  Color get accentColor => style.accentColor;
  Color get iconColor => style.iconColor;
  Color get shadowColor => style.shadowColor;
  Color get backgroundColor =>
      Color.lerp(style.backgroundColor, style.colorOnScroll, scrollAnimation.value);

  Duration get transitionDuration => widget.transitionDuration;
  FloatingSearchAppBarStyle get style => widget.style;

  bool _isOpen = false;
  bool get isOpen => _isOpen;
  set isOpen(bool value) {
    if (value) {
      _input.requestFocus();
      controller.forward();
    } else {
      _input.clearFocus(context);
      controller.reverse();
    }

    setState(() {});

    if (value != isOpen) {
      _isOpen = value;
      widget.onFocusChanged?.call(isOpen);
    }
  }

  @override
  void initState() {
    super.initState();
    _input = TextController()
      ..addListener(() {
        queryNotifer.value = _input.text;

        _handler.post(
          // Do not add a delay when the query is empty.
          _input.text.isEmpty ? Duration.zero : widget.debounceDelay,
          () => widget.onQueryChanged?.call(_input.text),
        );
      });

    controller = AnimationController(vsync: this, duration: widget.transitionDuration)
      ..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        _setInsets();

        if (status == AnimationStatus.dismissed) {
          if (widget.clearQueryOnClose) clear();
        }
      });

    transitionAnimation = CurvedAnimation(
      parent: controller,
      curve: widget.transitionCurve,
    );

    scrollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() => setState(() {}));

    scrollAnimation = CurvedAnimation(
      parent: scrollController,
      curve: Curves.easeInOutCubic,
    );

    _setInsets();

    _assignController();
  }

  @override
  void didUpdateWidget(_FloatingSearchAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _assignController();

    controller.duration = widget.transitionDuration;
  }

  void open() => isOpen = true;
  void close() => isOpen = false;

  void clear() => _input.clear();

  void _assignController() {
    final controller = widget.controller;
    if (controller == null) return;

    controller._open = open;
    controller._close = close;
    controller._clear = clear;
  }

  EdgeInsets insets;
  void _setInsets() {
    bool hasActions(List<Widget> actions) {
      final active = List.from(actions)
        ..retainWhere((action) {
          if (action is FloatingSearchBarAction) {
            return isOpen ? action.showIfOpened : action.showIfClosed;
          } else {
            return true;
          }
        });

      return active.isNotEmpty;
    }

    final hasStartActions = hasActions(widget.startActions);
    final hasEndActions = hasActions(widget.actions);

    final isDefaultPadding = style.padding.horizontal == 24.0;
    final inset = isDefaultPadding ? 4.0 : 0.0;

    insets = EdgeInsets.lerp(
      style.insets.copyWith(
        left: !hasStartActions ? inset : null,
        right: !hasEndActions ? inset : null,
      ),
      style.insets,
      transitionAnimation.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isAppBar) {
      return _buildStandalone();
    } else {
      return _buildBar();
    }
  }

  Widget _buildStandalone() {
    final height = style.height + _statusBarHeight;

    final brightness = widget.brightness ?? backgroundColor.computeLuminance() > 0.7
        ? Brightness.light
        : Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        if (isOpen) {
          isOpen = false;
          return false;
        }

        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: brightness == Brightness.dark
            ? const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.light,
                statusBarIconBrightness: Brightness.light)
            : const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis != Axis.vertical) return false;

            final pixels = notification.metrics.pixels;
            final isAtTop = pixels < 1.0;
            if (isAtTop != _isAtTop) {
              _isAtTop = isAtTop;
              isAtTop ? scrollController.reverse() : scrollController.forward();
            }

            return false;
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height),
                child: widget.body,
              ),
              _buildBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar() {
    final statusBarHeight = isAppBar ? _statusBarHeight : 0.0;
    final t = scrollAnimation.value;
    final elevation = lerpDouble(style.elevation, style.liftOnScrollElevation, t);

    final bar = GestureDetector(
      onTap: () {
        if (isOpen) {
          isOpen = query.isNotEmpty;
          _input.moveCursorToEnd();
        } else if (!isAppBar) {
          isOpen = true;
        }
      },
      child: Material(
        color: backgroundColor,
        elevation: elevation,
        child: Container(
          height: style.height + statusBarHeight,
          padding: style.padding.add(EdgeInsets.only(top: statusBarHeight)),
          child: _buildContent(),
        ),
      ),
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        bar,
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildContent() {
    final iconTheme = Theme.of(context).iconTheme.copyWith(color: style.iconColor);

    return Row(
      children: [
        FloatingSearchActionBar(
          animation: transitionAnimation,
          actions: widget.startActions,
          iconTheme: iconTheme,
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              _buildInputField(),
              buildShader(isLeft: true),
              buildShader(isLeft: false),
            ],
          ),
        ),
        FloatingSearchActionBar(
          animation: transitionAnimation,
          actions: widget.actions,
          iconTheme: iconTheme,
        ),
      ],
    );
  }

  Widget buildShader({bool isLeft}) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Transform.rotate(
        angle: isLeft ? pi : 0.0,
        child: Container(
          width: isLeft ? insets.left : insets.right,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                backgroundColor.withOpacity(0.0),
                backgroundColor.withOpacity(1.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    final animation = transitionAnimation.drive(ValleyingTween());

    final hasQuery = !widget.clearQueryOnClose && query.isNotEmpty;
    final showTitle = widget.title != null || (!hasQuery && query.isNotEmpty);
    final opacity = showTitle ? animation.value : 1.0;

    final showTextInput = showTitle ? controller.value > 0.5 : controller.value > 0.0;

    Widget input;
    if (showTextInput) {
      input = IntrinsicWidth(
        child: TextField(
          controller: _input,
          scrollPadding: EdgeInsets.zero,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          focusNode: _input.node,
          maxLines: 1,
          autofocus: false,
          autocorrect: widget.autocorrect,
          toolbarOptions: widget.toolbarOptions,
          cursorColor: style.accentColor,
          style: style.queryStyle,
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: style.hintStyle,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      );
    } else {
      if (widget.title != null) {
        input = widget.title;

        if (isAppBar) {
          input = DefaultTextStyle(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).appBarTheme?.textTheme?.headline6 ??
                Theme.of(context).textTheme?.headline6,
            child: input,
          );
        }
      } else {
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;

        final textStyle = hasQuery
            ? style.queryStyle ?? textTheme.subtitle1
            : style.hintStyle ?? textTheme.subtitle1.copyWith(color: theme.hintColor);

        input = Text(
          hasQuery ? query : widget.hint,
          style: textStyle,
          maxLines: 1,
        );
      }
    }

    return SingleChildScrollView(
      padding: insets,
      scrollDirection: Axis.horizontal,
      child: Opacity(
        opacity: opacity,
        child: input,
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = widget.progress;
    const progressBarHeight = 3.0;

    final progressBarColor = style.accentColor ?? Theme.of(context).accentColor;
    final showProgresBar =
        progress != null && (progress is num || (progress is bool && progress == true));
    final progressValue = progress is num ? progress.toDouble().clamp(0.0, 1.0) : null;

    return AnimatedOpacity(
      opacity: showProgresBar ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 150),
      child: SizedBox(
        height: progressBarHeight,
        child: LinearProgressIndicator(
          value: progressValue,
          semanticsValue: progressValue?.toStringAsFixed(2),
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(progressBarColor),
        ),
      ),
    );
  }

  @override
  void dispose() {
    queryNotifer.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
