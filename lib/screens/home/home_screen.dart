import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/home/components/add_section_widget.dart';
import 'package:loja_virtual/screens/home/components/section_list.dart';
import 'package:loja_virtual/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 211, 118, 130),
                  Color.fromARGB(255, 253, 181, 168),
                ],
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                floating: true,
                snap: true,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja do Lütz'),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                    icon: const Icon(
                      Icons.shopping_cart,
                    ),
                    color: Colors.white,
                  ),
                  Consumer2<UserManager, HomeManager>(
                      builder: (_, userManager, homeManager, __) {
                    if (userManager.isAdmin && !homeManager.loading) {
                      if (homeManager.editing) {
                        return PopupMenuButton(
                          onSelected: (selected) {
                            if (selected == 'Salvar') {
                              homeManager.saveEditing();
                            } else {
                              homeManager.discardEditing();
                            }
                          },
                          itemBuilder: (_) => ['Salvar', 'Descartar']
                              .map(
                                (text) => PopupMenuItem(
                                  value: text,
                                  child: Text(text),
                                ),
                              )
                              .toList(),
                        );
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => homeManager.enterEditing(),
                        );
                      }
                    } else
                      return const SizedBox();
                  }),
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  if (homeManager.loading)
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );

                  final List<Widget> children =
                      homeManager.sections.map<Widget>(
                    (section) {
                      switch (section.type) {
                        case 'List':
                          return SectionList(
                            section: section,
                          );
                        case 'Staggered':
                          return SectionStaggered(
                            section: section,
                          );
                        default:
                          return Container();
                      }
                    },
                  ).toList();

                  if (homeManager.editing)
                    children.add(
                      const AddSectionWidget(),
                    );
                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
