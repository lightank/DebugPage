// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:debug_page/debug_page.dart';

class DebugPagePopupRoute extends PopupRoute {
  DebugPagePopupRoute({
    required this.sectionNames,
    required this.selectedIndex,
    required this.topOffset,
    required this.popupProperty,
  });

  final List<String> sectionNames;
  final int selectedIndex;
  final double topOffset;
  final PopupProperty popupProperty;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Size screen = MediaQuery.of(context).size;
    final screenWidth = screen.width;
    final screenHeight = screen.height;

    Widget buildSection(BuildContext context, int index) {
      final content = sectionNames[index];
      return GestureDetector(
        onTap: () {
          Navigator.pop(context, index);
        },
        child: Container(
          alignment: Alignment.center,
          color: popupProperty.bgColor,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Text(
            content,
            style: index == selectedIndex
                ? popupProperty.selectedLabelTextStyle
                : popupProperty.unSelectedLabelTextStyle,
          ),
        ),
      );
    }

    Widget buildSectionList() => GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.white,
            width: screenWidth,
            constraints: BoxConstraints.loose(Size(
              double.infinity,
              screenHeight * 0.8 - 44,
            )),
            child: Scrollbar(
              thickness: 4,
              radius: const Radius.circular(6),
              child: ListView.builder(
                cacheExtent: 2000,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                itemCount: sectionNames.length,
                itemBuilder: buildSection,
              ),
            ),
          ),
        );

    return SafeArea(
      bottom: false,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // 灰色蒙层，点击关闭
            Builder(
              builder: (context) => GestureDetector(
                onTap: () => () {
                  Navigator.pop(context);
                },
                onPanEnd: (details) => () {
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Container(
                      height: topOffset,
                      color: Colors.transparent,
                    ),
                    Expanded(
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(top: topOffset, child: buildSectionList()),
          ],
        ),
      ),
    );
  }
}
