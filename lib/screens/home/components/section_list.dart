import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:loja_virtual/screens/home/components/add_tile_widget.dart';
import 'package:loja_virtual/screens/home/components/item_tile.dart';
import 'package:loja_virtual/screens/home/components/section_header.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {
  final Section section;
  const SectionList({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(),
            SizedBox(
              height: 150,
              child: Consumer<Section>(
                builder: (_, section, __) => ListView.separated(
                  itemCount: homeManager.editing
                      ? section.items.length + 1
                      : section.items.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 4),
                  itemBuilder: (_, index) => index < section.items.length
                      ? ItemTile(item: section.items[index])
                      : const AddTileWidget(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
