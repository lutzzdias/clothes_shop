import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:loja_virtual/screens/home/components/item_tile.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';

class SectionStaggered extends StatelessWidget {
  final Section section;
  late final List<Widget> items = [];
  SectionStaggered({Key? key, required this.section}) : super(key: key);

  List<Widget> _buildStaggeredList() {
    for (SectionItem item in section.items) {
      items.add(
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: items.length.isEven ? 2 : 1,
          child: ItemTile(
            item: item,
          ),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section: section),
          StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: _buildStaggeredList(),
          ),
        ],
      ),
    );
  }
}
