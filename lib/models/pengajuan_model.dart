import 'package:flutter/foundation.dart';

enum SesiKunjungan {
  pagi('Pagi'),
  siang('Siang'),
  sore('Sore');

  const SesiKunjungan(this.label);
  final String label;
}

class Pengajuan {
  Pengajuan({
    required this.id,
    required this.layanan,
    required this.bidang,
    required this.nama,
    required this.email,
    required this.sesi,
    required this.waktu,
    this.selesai = false,
  });

  final int id;
  final String layanan;
  final String bidang;
  final String nama;
  final String email;
  final SesiKunjungan sesi;
  final DateTime waktu;
  bool selesai;
}

class PengajuanModel extends ChangeNotifier {
  static const daftarBidang = ['Perizinan', 'Kesehatan', 'Transportasi'];

  final List<Pengajuan> _daftar = [];
  int _idTerakhir = 0;

  // Terbaru di atas
  List<Pengajuan> get daftar => List.unmodifiable(_daftar.reversed);

  int get totalPengajuan => _daftar.length;

  Map<String, int> get jumlahPerBidang => {
    for (final b in daftarBidang) b: _daftar.where((p) => p.bidang == b).length,
  };

  Pengajuan? cari(int id) {
    for (final p in _daftar) {
      if (p.id == id) return p;
    }
    return null;
  }

  void tambah({
    required String layanan,
    required String bidang,
    required String nama,
    required String email,
    required SesiKunjungan sesi,
  }) {
    _daftar.add(
      Pengajuan(
        id: ++_idTerakhir,
        layanan: layanan,
        bidang: bidang,
        nama: nama,
        email: email,
        sesi: sesi,
        waktu: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void tandaiSelesai(int id) {
    final p = cari(id);
    if (p == null || p.selesai) return;
    p.selesai = true;
    notifyListeners();
  }
}
