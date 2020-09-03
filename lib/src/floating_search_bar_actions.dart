import 'package:flutter/material.dart';

import 'floating_search_bar.dart';
import 'util/util.dart';
import 'widgets/widgets.dart';

// ignore_for_file: public_member_api_docs

/// A widget to be displayed in a row before or after the
/// input text of a [FloatingSearchBar].
///
/// Typically this widget wraps a [CircularButton].
class FloatingSearchBarAction extends StatefulWidget {
  /// The action.
  ///
  /// Typically a [CircularButton].
  final Widget child;

  /// A builder that can be used when the action needs
  /// to react to changes in its [FloatingSearchBar].
  ///
  /// View [FloatingSearchBarAction.searchToClear] for an example.
  final Widget Function(BuildContext context, Animation animation) builder;

  /// Whether this action should be shown when the [FloatingSearchBar]
  /// is opened.
  ///
  /// If false, this action will be animated out when the
  /// bar [FloatingSearchBar] closed.
  final bool showIfOpened;

  /// Whether this action should be shown when the [FloatingSearchBar]
  /// is closed.
  ///
  /// If false, this action will be animated out when the
  /// bar [FloatingSearchBar] closed.
  final bool showIfClosed;

  /// Creates a widget to be displayed in a row before or after the
  /// input text of a [FloatingSearchBar].
  ///
  /// Typically this widget wraps a [CircularButton].
  const FloatingSearchBarAction({
    Key key,
    this.child,
    this.builder,
    this.showIfOpened = false,
    this.showIfClosed = true,
  })  : assert(builder != null || child != null),
        super(key: key);

  /// Whether this [FloatingSearchBarAction] is shown when opened
  /// and when closed.
  bool get isAlwaysShown => showIfOpened && showIfClosed;

  /// A hamburger menu that when tapped opens the [Drawer]
  /// of the nearest [Scaffold].
  ///
  /// When the [FloatingSearchBar] opens, the hamburger
  /// transitions into a back button.
  factory FloatingSearchBarAction.hamburgerToBack({
    double size = 24,
    Color color,
    bool showIfOpened,
    bool showIfClosed,
  }) {
    return FloatingSearchBarAction(
      showIfOpened: showIfOpened ?? true,
      showIfClosed: showIfClosed ?? true,
      builder: (context, animation) {
        return CircularButton(
          size: size,
          onPressed: () {
            final searchBar = FloatingSearchBar.of(context);
            if (searchBar?.isOpen == true) {
              searchBar?.close();
            } else {
              Scaffold.of(context)?.openDrawer();
            }
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: animation,
            color: color,
            size: size,
          ),
        );
      },
    );
  }

  /// A search icon that transitions into a clear icon
  /// when the query of the [FloatingSearchBar] is not empty.
  factory FloatingSearchBarAction.searchToClear({
    double size = 24,
    Color color,
    bool showIfOpened,
    bool showIfClosed,
    Duration duration = const Duration(milliseconds: 900),
  }) {
    return FloatingSearchBarAction(
      showIfOpened: showIfOpened ?? true,
      showIfClosed: showIfClosed ?? true,
      builder: (context, animation) {
        final bar = FloatingSearchAppBar.of(context);

        return ValueListenableBuilder<String>(
          valueListenable: bar.queryNotifer,
          builder: (context, value, _) {
            final isEmpty = value.isEmpty;

            return SearchToClear(
              isEmpty: isEmpty,
              size: size,
              color: color ?? bar?.style?.iconColor,
              duration: (duration ?? bar.transitionDuration) * 0.5,
              onTap: () {
                if (!isEmpty) {
                  bar.clear();
                } else {
                  bar.isOpen = !bar.isOpen;
                }
              },
            );
          },
        );
      },
    );
  }

  /// A convenience factory to wrap an [Icon] or an [IconData]
  /// into an action.
  factory FloatingSearchBarAction.icon({
    @required dynamic icon,
    @required VoidCallback onTap,
    double size = 24.0,
    bool showIfOpened = false,
    bool showIfClosed = true,
  }) {
    assert(size != null);
    assert(icon != null);
    assert(onTap != null);

    return FloatingSearchBarAction(
      child: CircularButton(
        size: size,
        icon: icon is IconData ? Icon(icon) : icon,
        onPressed: onTap,
      ),
      showIfClosed: showIfClosed,
      showIfOpened: showIfOpened,
    );
  }

  @override
  _FloatingSearchBarActionState createState() => _FloatingSearchBarActionState();
}

class _FloatingSearchBarActionState extends State<FloatingSearchBarAction> {
  @override
  Widget build(BuildContext context) {
    if (widget.child != null) {
      return widget.child;
    }

    final searchBar = FloatingSearchBar.of(context);
    assert(searchBar != null);

    return widget.builder(context, searchBar.animation);
  }
}

/// Creates a row for [FloatingSearchBarActions].
class FloatingSearchBarActionBar extends StatefulWidget {
  final Animation animation;
  final List<Widget> actions;
  final IconThemeData iconTheme;
  const FloatingSearchBarActionBar({
    Key key,
    @required this.animation,
    @required this.actions,
    this.iconTheme,
  }) : super(key: key);

  @override
  _FloatingSearchBarActionBarState createState() => _FloatingSearchBarActionBarState();
}

class _FloatingSearchBarActionBarState extends State<FloatingSearchBarActionBar> {
  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: widget.iconTheme,
      child: Row(
        children: _mapActions(),
      ),
    );
  }

  List<Widget> _mapActions() {
    final actions = widget.actions ?? const <Widget>[];

    final animation = ValleyingTween().animate(widget.animation);
    final isOpen = animation.value >= 0.5;

    var openCount = 0;
    var closedCount = 0;
    for (final action in actions) {
      if (action is FloatingSearchBarAction) {
        if (action.showIfOpened) openCount++;
        if (action.showIfClosed) closedCount++;
      }
    }

    final currentActions = List<Widget>.from(actions)
      ..removeWhere((action) {
        if (action is FloatingSearchBarAction) {
          return (isOpen && !action.showIfOpened) || (!isOpen && !action.showIfClosed);
        } else {
          return false;
        }
      });

    return currentActions.map((action) {
      if (action is FloatingSearchBarAction) {
        if (action.isAlwaysShown) return action;

        final index = currentActions.reversed.toList().indexOf(action);
        final shouldScale = index <= ((isOpen ? closedCount : openCount) - 1);
        if (shouldScale) {
          return ScaleTransition(
            scale: animation,
            child: action,
          );
        } else {
          return SizeFadeTransition(
            animation: animation,
            axis: Axis.horizontal,
            axisAlignment: 1.0,
            sizeFraction: 0.25,
            child: Center(child: action),
          );
        }
      }

      return action;
    }).toList();
  }
}
