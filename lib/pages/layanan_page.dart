import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorit_model.dart';
import '../navigation/app_routes.dart';
import 'layanan_data.dart';

class LayananPage extends StatelessWidget {
  const LayananPage({super.key});

  Future<void> _buka(BuildContext context, Layanan l) async {
    final hasil = await Navigator.pushNamed<String>(
      context,
      AppRoutes.rincian,
      arguments: l,
    );
    if (hasil != null && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(hasil)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final kelompok = dataLayanan.keys.toList();
    return DefaultTabController(
      length: kelompok.length,
      child: Column(
        children: [
          TabBar(tabs: [for (final k in kelompok) Tab(text: k)]),
          Expanded(
            child: TabBarView(
              children: [
                for (final k in kelompok)
                  ListView(
                    children: [
                      for (final l in dataLayanan[k]!)
                        ListTile(
                          leading: const Icon(Icons.description_outlined),
                          title: Text(l.nama),
                          subtitle: Text(l.dinas),
                          trailing: Consumer<FavoritModel>(
                            builder: (context, favorit, _) {
                              final fav = favorit.apakahFavorit(l.nama);
                              return IconButton(
                                tooltip: fav
                                    ? 'Hapus dari favorit'
                                    : 'Tandai favorit',
                                icon: Icon(
                                  fav ? Icons.star : Icons.star_border,
                                ),
                                color: fav ? Colors.amber : null,
                                onPressed: () => fav
                                    ? favorit.batalTandai(l.nama)
                                    : favorit.tandai(l.nama),
                              );
                            },
                          ),
                          onTap: () => _buka(context, l),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
