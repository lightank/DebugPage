// Dart imports:
import 'dart:ui' as ui show window;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:scroll_to_index/scroll_to_index.dart';

// Project imports:
import 'package:debug_page/src/debug_page_popup.dart';
import 'package:debug_page/src/widget/debug_page_menu_tab_bar.dart';
import 'package:debug_page/src/widget/debug_section_header_widget.dart';

class DebugPageDataSource {
  const DebugPageDataSource({
    this.title = "Debug page",
    required this.sectionsBuilder,
    this.bgColor = const Color(0xe6ffffff),
    this.appBarBuilder,
    this.tabBarProperty = const TabBarProperty(),
    this.popupProperty = const PopupProperty(),
  });

  /// 测试界面标题
  final String title;
  final List<DebugBaseSectionModule> Function() sectionsBuilder;
  final PreferredSizeWidget? Function(BuildContext context)? appBarBuilder;

  final Color bgColor;
  final TabBarProperty tabBarProperty;
  final PopupProperty popupProperty;
}

class PopupProperty {
  const PopupProperty({
    this.bgColor = Colors.white,
    this.selectedLabelTextStyle =
        const TextStyle(color: Colors.lightBlueAccent),
    this.unSelectedLabelTextStyle = const TextStyle(color: Colors.black45),
  });

  final Color bgColor;
  final TextStyle selectedLabelTextStyle;
  final TextStyle unSelectedLabelTextStyle;
}

class TabBarProperty {
  const TabBarProperty({
    this.selectedLabelColor = Colors.lightBlueAccent,
    this.unselectedLabelColor = Colors.black45,
    this.indicator = const UnderlineTabIndicator(
      borderSide: BorderSide(
        width: 6.0,
        color: Colors.lightBlueAccent,
      ),
    ),
  });

  final Color selectedLabelColor;
  final Color unselectedLabelColor;
  final Decoration? indicator;
}

class DebugBaseSectionModule<T> {
  DebugBaseSectionModule({
    required this.title,
    required this.items,
    this.headerWidgetBuilder,
    this.itemWidgetBuilder,
    this.onItemWidgetBlock,
  }) : assert(items.isNotEmpty, "DebugSectionModule：$title section 中元素数量不能为0");

  /// 标题
  final String title;

  /// 标题构造器，默认
  final Widget Function(
          BuildContext context, DebugBaseSectionModule<T> section)?
      headerWidgetBuilder;

  /// 子项数组
  final List<DebugBaseSectionItem<T>> items;
  final Widget Function(BuildContext context, T? itemValue)? itemWidgetBuilder;
  final void Function(BuildContext context, T? itemValue)? onItemWidgetBlock;

  Widget buildContentsWidget(BuildContext context) {
    final List<Widget> widgets = [];
    widgets.add(headerWidgetBuilder?.call(context, this) ??
        DebugSectionHeaderWidget(title: title));

    widgets.addAll(items.map((item) {
      assert(item.widgetBuilder != null || itemWidgetBuilder != null,
          "DebugSectionModule：$title section 中元素的 widgetBuilder 和 section 默认的 itemWidgetBuilder 不能同时为空");
      Widget? widget;
      if (item.widgetBuilder != null) {
        widget = item.widgetBuilder?.call(context, item.value);
      } else if (itemWidgetBuilder != null) {
        widget = itemWidgetBuilder?.call(context, item.value);
      }
      return Container(
        color: Colors.white,
        width: double.infinity,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (item.onWidgetBlock != null) {
              item.onWidgetBlock?.call(context, item.value);
            } else if (onItemWidgetBlock != null) {
              onItemWidgetBlock?.call(context, item.value);
            }
          },
          child: widget,
        ),
      );
    }).toList());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

class DebugBaseSectionItem<T> {
  DebugBaseSectionItem({
    this.value,
    this.widgetBuilder,
    this.onWidgetBlock,
  });

  T? value;
  Widget Function(BuildContext context, T? value)? widgetBuilder;
  void Function(BuildContext context, T? value)? onWidgetBlock;
}

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key, required this.dataSource}) : super(key: key);

  /// 测试界面标题
  final DebugPageDataSource dataSource;

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  late List<DebugBaseSectionModule> _sections;

  DebugPageDataSource get dataSource => widget.dataSource;

  int _currentTabIndex = 0;
  late final _tabBarKey = GlobalKey<DebugPageMenuTabBarState>();
  bool _isAutoScrolling = false;
  late List<String> _tabTitles;
  late final _scrollController = AutoScrollController();

  double _menuTabBarYOffset = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // 手动滚动时，找出并选中当前的二级导航标签
      if (_isAutoScrolling) return;

      final RenderObject? tabBarRenderObj =
          _tabBarKey.currentState?.context.findRenderObject();
      Offset tabBarOffset = const Offset(0, 0);
      if (tabBarRenderObj is RenderBox) {
        tabBarOffset = tabBarRenderObj.localToGlobal(tabBarOffset);
      }

      final list = _scrollController.tagMap.entries.toList();
      for (int i = list.length - 1; i >= 0; i--) {
        final MapEntry<int, AutoScrollTagState> entry = list[i];
        final RenderObject? renderObj = entry.value.context.findRenderObject();
        if (renderObj is RenderBox) {
          final offset = renderObj.localToGlobal(Offset(tabBarOffset.dx,
              -(tabBarOffset.dy + DebugPageMenuTabBar.tabBarHeight)));
          if (offset.dy < 10) {
            if (_currentTabIndex != entry.key) {
              _tabBarKey.currentState?.animateTo(_currentTabIndex = entry.key);
            }
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 支持小 r 刷新
    _sections = dataSource.sectionsBuilder();
    _tabTitles = _sections.map((e) => e.title).toList();
    _currentTabIndex = 0;

    if (_menuTabBarYOffset == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderObject? tabBarRenderObj =
            _tabBarKey.currentState?.context.findRenderObject();
        if (tabBarRenderObj is RenderBox) {
          _menuTabBarYOffset = tabBarRenderObj.localToGlobal(Offset.zero).dy -
              MediaQueryData.fromWindow(ui.window).viewPadding.top;
        }
      });
    }

    return Scaffold(
      backgroundColor: dataSource.bgColor,
      appBar: dataSource.appBarBuilder?.call(context) ??
          AppBar(
            title: Text(dataSource.title),
          ),
      body: Column(
        children: [
          DebugPageMenuTabBar(
            key: _tabBarKey,
            sectionNames: _tabTitles,
            onSelected: (index) {
              _jumpToTab(index);
            },
            onExpand: () {
              _onExpand();
            },
            tabBarProperty: dataSource.tabBarProperty,
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              children: _sections.map((module) {
                final index = _sections.indexOf(module);
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _scrollController,
                  index: index,
                  child: module.buildContentsWidget(context),
                );
              }).toList(), //_buildModuleHeaderAndContents(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _jumpToTab(int index, {bool ignoreCurrentIndex = false}) async {
    if (!ignoreCurrentIndex) {
      if (_currentTabIndex == index) return;
    }

    _isAutoScrolling = true;
    _currentTabIndex = index;

    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );

    _isAutoScrolling = false;
  }

  void _onExpand() {
    Navigator.push(
      context,
      DebugPagePopupRoute(
        sectionNames: _tabTitles,
        selectedIndex: _currentTabIndex,
        topOffset: _menuTabBarYOffset,
        popupProperty: dataSource.popupProperty,
      ),
    ).then((index) async {
      if (index is int) {
        if (_currentTabIndex == index) return;
        _tabBarKey.currentState?.animateTo(index);
        await _jumpToTab(index);
      }
    });
  }
}
