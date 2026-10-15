import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorit_model.dart';
import '../models/pengajuan_model.dart';
import '../navigation/app_routes.dart';

class WargaPage extends StatelessWidget {
  const WargaPage({super.key});

  void _info(BuildContext context, String pesan) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(pesan)));
  }

  Future<void> _ajukanBaru(BuildContext context) async {
    final hasil = await Navigator.pushNamed<String>(
      context,
      AppRoutes.pengajuanBaru,
    ); // named route, bukan push kelas
    if (hasil != null && context.mounted) _info(context, hasil);
  }

  @override
  Widget build(BuildContext context) {
    final daftar = context.watch<PengajuanModel>().daftar;

    return Scaffold(
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Bayu Firmansyah'),
              subtitle: Text('NIK: 3577xxxxxxxxxxxx'),
            ),
          ),
          Consumer<FavoritModel>(
            builder: (context, favorit, _) {
              if (favorit.jumlahFavorit == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Layanan Favorit (${favorit.jumlahFavorit})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        for (final nama in favorit.daftarFavorit)
                          InputChip(
                            avatar: const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            ),
                            label: Text(nama),
                            onDeleted: () => favorit.batalTandai(nama),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Riwayat Pengajuan (${daftar.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Expanded(
            child: daftar.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada pengajuan.\nTekan tombol + untuk membuat pengajuan baru.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                    itemCount: daftar.length,
                    itemBuilder: (context, i) {
                      final p = daftar[i];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.rincianPengajuan,
                          arguments: p.id,
                        ),
                        onLongPress: () {
                          if (p.selesai) return;
                          context.read<PengajuanModel>().tandaiSelesai(p.id);
                          _info(
                            context,
                            'Pengajuan ${p.layanan} ditandai selesai ditindaklanjuti',
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: Icon(
                              p.selesai
                                  ? Icons.check_circle
                                  : Icons.pending_outlined,
                              color: p.selesai ? Colors.green : null,
                            ),
                            title: Text(p.layanan),
                            subtitle: Text(
                              '${p.nama} - ${p.bidang}\n'
                              '${p.selesai ? 'Selesai ditindaklanjuti' : 'Menunggu tindak lanjut'}',
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ajukanBaru(context),
        tooltip: 'Pengajuan baru',
        child: const Icon(Icons.add),
      ),
    );
  }
}
