import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/store.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCard extends StatelessWidget {
  final Store store;

  const StoreCard({
    Key? key,
    required this.store,
  }) : super(key: key);

  Color colorForStatus(StoreStatus status) {
    switch (status) {
      case StoreStatus.open:
        return Colors.green;
      case StoreStatus.closing:
        return Colors.yellow;
      case StoreStatus.closed:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Future<void> openPhone(BuildContext context) async {
    try {
      launchUrl(
        Uri(
          scheme: 'tel',
          path: store.cleanPhone,
        ),
      );
    } catch (error) {
      showErrorSnackbar(
        context,
        'Esta função não está disponível neste dispositivo.',
      );
    }
  }

  Future<void> openMap(BuildContext context) async {
    final navigator = Navigator.of(context);
    try {
      final availableMaps = await MapLauncher.installedMaps;
      if (context.mounted)
        showModalBottomSheet(
          context: context,
          builder: (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final map in availableMaps)
                  ListTile(
                    title: Text(
                      map.mapName,
                    ),
                    leading: SvgPicture.asset(
                      map.icon,
                      width: 30,
                      height: 30,
                    ),
                    onTap: () {
                      map.showMarker(
                        coords: Coords(
                            store.address.latitude, store.address.longitude),
                        title: store.name,
                      );
                      navigator.pop();
                    },
                  )
              ],
            ),
          ),
        );
    } catch (error) {
      showErrorSnackbar(context, 'Aplicativo de mapa não encontrado');
    }
  }

  void showErrorSnackbar(BuildContext context, String txt) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(txt),
          backgroundColor: Colors.red,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  store.image,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      store.statusText,
                      style: TextStyle(
                        color: colorForStatus(store.status),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        store.addressText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        store.openingText,
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomIconButton(
                      icon: Icons.map,
                      color: Theme.of(context).primaryColor,
                      onTap: () async => openMap(context),
                    ),
                    CustomIconButton(
                      icon: Icons.phone,
                      color: Theme.of(context).primaryColor,
                      onTap: () async => openPhone(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
