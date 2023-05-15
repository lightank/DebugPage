// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:debug_page/debug_page.dart';

class DebugPageMenuTabBar extends StatefulWidget {
  const DebugPageMenuTabBar({
    Key? key,
    required this.sectionNames,
    required this.onSelected,
    required this.onExpand,
    required this.tabBarProperty,
  }) : super(key: key);

  final List<String> sectionNames;
  final ValueChanged<int> onSelected;
  final VoidCallback onExpand;
  final TabBarProperty tabBarProperty;

  static const double tabBarHeight = 44;

  @override
  DebugPageMenuTabBarState createState() => DebugPageMenuTabBarState();
}

class DebugPageMenuTabBarState extends State<DebugPageMenuTabBar>
    with TickerProviderStateMixin {
  TabBarProperty get tabBarProperty => widget.tabBarProperty;
  TabController? _controller;
  int _index = 0;

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final length = widget.sectionNames.length;

    _controller = TabController(
      initialIndex: _index,
      length: length,
      vsync: this,
    );
    final tabBar = TabBar(
      tabs: widget.sectionNames.map(
        (name) {
          return Listener(
            onPointerUp: (_) {},
            child: Text(name),
          );
        },
      ).toList(),
      labelPadding: const EdgeInsets.only(left: 16, right: 8),
      indicatorPadding: const EdgeInsets.only(left: 16, right: 8),
      isScrollable: true,
      controller: _controller,
      labelColor: tabBarProperty.selectedLabelColor,
      unselectedLabelColor: tabBarProperty.unselectedLabelColor,
      indicator: tabBarProperty.indicator,
      onTap: (index) {
        if (_index != index) widget.onSelected(_index = index);
      },
    );

    const double iconWidth = 44;

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(right: iconWidth),
            height: DebugPageMenuTabBar.tabBarHeight,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            clipBehavior: Clip.hardEdge,
            child: Theme(
              // 取消 TabBar 的水波纹
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: tabBar,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 2,
            child: GestureDetector(
              onTap: () {
                widget.onExpand();
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: _buildRightLine(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightLine() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: DebugPageMenuTabBar.tabBarHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withAlpha(0),
                Colors.white.withAlpha(255),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
          height: DebugPageMenuTabBar.tabBarHeight,
          child: Icon(Icons.arrow_drop_down, size: 24),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  void animateTo(int index) => _controller?.animateTo(_index = index);
}
