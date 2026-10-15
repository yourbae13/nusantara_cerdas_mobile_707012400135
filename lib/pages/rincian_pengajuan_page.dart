import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pengajuan_model.dart';

class RincianPengajuanPage extends StatelessWidget {
  const RincianPengajuanPage({super.key, required this.idPengajuan});
  final int idPengajuan;

  String _waktu(DateTime w) =>
      '${w.day}/${w.month}/${w.year} '
      '${w.hour.toString().padLeft(2, '0')}:${w.minute.toString().padLeft(2, '0')}';

  Widget _baris(IconData ikon, String label, String nilai) =>
      ListTile(leading: Icon(ikon), title: Text(label), subtitle: Text(nilai));

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PengajuanModel>().cari(idPengajuan);
    return Scaffold(
      appBar: AppBar(title: const Text('Rincian Pengajuan')),
      body: p == null
          ? const Center(child: Text('Pengajuan tidak ditemukan'))
          : ListView(
              children: [
                _baris(
                  Icons.description_outlined,
                  'Layanan',
                  '${p.layanan} (${p.bidang})',
                ),
                _baris(Icons.person_outline, 'Pemohon', p.nama),
                _baris(Icons.email_outlined, 'Email', p.email),
                _baris(Icons.event, 'Sesi kunjungan', p.sesi.label),
                _baris(Icons.schedule, 'Waktu pengajuan', _waktu(p.waktu)),
                _baris(
                  p.selesai ? Icons.check_circle : Icons.pending_outlined,
                  'Status',
                  p.selesai
                      ? 'Selesai ditindaklanjuti'
                      : 'Menunggu tindak lanjut',
                ),
              ],
            ),
    );
  }
}
