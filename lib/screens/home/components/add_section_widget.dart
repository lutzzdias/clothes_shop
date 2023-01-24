import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/section.dart';
import 'package:provider/provider.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return Row(
      children: [
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              homeManager.addSection(Section(type: 'List'));
            },
            child: const Text('Adicionar lista'),
          ),
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              homeManager.addSection(Section(type: 'Staggered'));
            },
            child: const Text('Adicionar grade'),
          ),
        ),
      ],
    );
  }
}
