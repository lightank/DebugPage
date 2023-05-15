// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:debug_page/debug_page.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';

class DebugSectionItemModel {
  DebugSectionItemModel({
    this.title,
    this.subTitle,
    this.url,
  });

  String? title;
  String? subTitle;
  String? url;
}

void onItemWidgetBlock(
    BuildContext context, DebugSectionItemModel? sectionItemModel) {
  final url = sectionItemModel?.url ?? "";
  if (url.isNotEmpty) {
    context.push(url, extra: "${sectionItemModel?.title} Detail");
  }
}

Widget _sectionItemWidgetWith(DebugSectionItemModel sectionItemModel) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(
      top: 6,
      left: 20,
      right: 20,
      bottom: 6,
    ),
    padding: const EdgeInsets.only(top: 6, left: 20, right: 20, bottom: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(width: 1),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sectionItemModel.title ?? "",
              ),
              if (sectionItemModel.subTitle?.isNotEmpty ?? false)
                Text(
                  sectionItemModel.subTitle ?? "",
                ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    ),
  );
}

Widget _headerWidgetWith(String title) {
  return Container(
    padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}

class DebugSectionModule {
  static sectionOneModule() {
    return DebugBaseSectionModule<DebugSectionItemModel>(
      title: "Section 1",
      items: [
        DebugBaseSectionItem(
          value: DebugSectionItemModel(
            title: "Page 1",
            subTitle: "Description of Page 1，点击跳转页面",
            url: "/details",
          ),
        ),
        DebugBaseSectionItem(
          value: DebugSectionItemModel(
            title: "Page 2",
            subTitle: "Description of Page 2",
            url: "/details",
          ),
          onWidgetBlock: (context, value) {
            showToast("我是 Page 2 自定义点击事件");
          },
        ),
      ],
      headerWidgetBuilder: (context, section) {
        return _headerWidgetWith(section.title);
      },
      itemWidgetBuilder: (context, item) {
        return item != null ? _sectionItemWidgetWith(item) : const SizedBox();
      },
      onItemWidgetBlock: onItemWidgetBlock,
    );
  }

  static sectionTwoModule() {
    return DebugBaseSectionModule<DebugSectionItemModel>(
      title: "Section 2",
      items: [
        DebugBaseSectionItem(
          value: DebugSectionItemModel(
            title: "Page 3",
            subTitle: "Description of Page 3",
            url: "/details",
          ),
        ),
        DebugBaseSectionItem(
          value: DebugSectionItemModel(
            title: "Page 4",
            subTitle: "Description of Page 4",
            url: "/details",
          ),
          onWidgetBlock: (context, value) {
            showToast("我是 Page 4 自定义点击事件");
          },
        ),
      ],
      headerWidgetBuilder: (context, section) {
        return _headerWidgetWith(section.title);
      },
      itemWidgetBuilder: (context, item) {
        return item != null ? _sectionItemWidgetWith(item) : const SizedBox();
      },
      onItemWidgetBlock: onItemWidgetBlock,
    );
  }

  static sectionThreeModule() {
    return DebugBaseSectionModule<DebugSectionItemModel>(
      title: "Section 3",
      items: [
        DebugBaseSectionItem(
          value: DebugSectionItemModel(
            title: "Page 5",
            subTitle: "Description of Page 5",
            url: "/details",
          ),
        ),
        DebugBaseSectionItem(
          value: DebugSectionItemModel(
            title: "Page 6",
            subTitle: "Description of Page 6",
            url: "/details",
          ),
          onWidgetBlock: (context, value) {
            showToast("我是 Page 6 自定义点击事件");
          },
        ),
      ],
      headerWidgetBuilder: (context, section) {
        return _headerWidgetWith(section.title);
      },
      itemWidgetBuilder: (context, item) {
        return item != null ? _sectionItemWidgetWith(item) : const SizedBox();
      },
      onItemWidgetBlock: onItemWidgetBlock,
    );
  }
}

List<DebugBaseSectionModule> debugPageSectionsBuilder() => [
      DebugSectionModule.sectionOneModule(),
      DebugSectionModule.sectionTwoModule(),
      DebugSectionModule.sectionThreeModule(),
    ];
