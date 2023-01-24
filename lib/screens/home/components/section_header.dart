import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();

    return homeManager.editing
        ? Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: section.name,
                  decoration: const InputDecoration(
                    hintText: 'Título',
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                  onChanged: (text) => section.name = text,
                ),
              ),
              CustomIconButton(
                icon: Icons.remove,
                color: Colors.white,
                onTap: () {
                  homeManager.removeSection(section);
                },
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              section.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
  }
}
