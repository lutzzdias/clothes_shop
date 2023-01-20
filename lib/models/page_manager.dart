import 'package:flutter/material.dart';

class PageManager {
  final PageController pageController;
  int _page = 0;

  PageManager({required this.pageController});

  int get page => _page;

  set page(int targetPage) {
    if (targetPage == _page) return;
    _page = targetPage;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) => pageController.jumpToPage(targetPage),
    );
  }
}
