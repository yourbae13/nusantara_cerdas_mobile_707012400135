import 'package:flutter/material.dart';
import '../pages/layanan_data.dart';
import '../pages/layanan_page.dart';
import '../pages/lokasi_kantor_page.dart';
import '../pages/rincian_layanan_page.dart';
import '../pages/rincian_pengajuan_page.dart';
import '../pages/route_tidak_dikenal_page.dart';
import '../pages/statistik_page.dart';
import '../pages/tanya_petugas_page.dart';
import '../pages/tentang_page.dart';
import '../pages/warga_page.dart';
import '../pages/kerangka_navigasi.dart';

class Tujuan {
  const Tujuan({
    required this.route,
    required this.label,
    required this.judul,
    required this.icon,
    required this.selectedIcon,
    required this.halaman,
  });

  final String route;
  final String label;
  final String judul;
  final IconData icon;
  final IconData selectedIcon;
  final Widget halaman;
}

class AppRoutes {
  // Tujuan utama (di dalam kerangka navigasi)
  static const beranda = '/';
  static const layanan = '/layanan';
  static const warga = '/warga';
  static const petugas = '/petugas';
  static const lokasi = '/lokasi';
  static const statistik = '/statistik';

  // Halaman yang dibuka di atas kerangka (menambah tumpukan route)
  static const rincian = '/layanan/rincian';
  static const pengajuanBaru = '/pengajuan/baru';
  static const rincianPengajuan = '/pengajuan/rincian';
  static const tentang = '/tentang';

  static const tujuanUtama = <Tujuan>[
    Tujuan(
      route: layanan,
      label: 'Layanan',
      judul: 'Layanan',
      icon: Icons.miscellaneous_services_outlined,
      selectedIcon: Icons.miscellaneous_services,
      halaman: LayananPage(),
    ),
    Tujuan(
      route: warga,
      label: 'Warga',
      judul: 'Warga',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      halaman: WargaPage(),
    ),
    Tujuan(
      route: petugas,
      label: 'Petugas',
      judul: 'Tanya Petugas',
      icon: Icons.chat_bubble_outline,
      selectedIcon: Icons.chat_bubble,
      halaman: TanyaPetugasPage(),
    ),
    Tujuan(
      route: lokasi,
      label: 'Lokasi',
      judul: 'Lokasi Kantor',
      icon: Icons.location_on_outlined,
      selectedIcon: Icons.location_on,
      halaman: LokasiKantorPage(),
    ),
    Tujuan(
      route: statistik,
      label: 'Statistik',
      judul: 'Statistik Layanan',
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
      halaman: StatistikPage(),
    ),
  ];

  static Map<String, WidgetBuilder> daftarRoute() => {
    beranda: (_) => const KerangkaNavigasi(),
    // Setiap tujuan utama juga route bernama: membuka kerangka
    // pada tujuan tersebut.
    for (var i = 0; i < tujuanUtama.length; i++)
      tujuanUtama[i].route: (_) => KerangkaNavigasi(indeksAwal: i),
    tentang: (_) => const TentangPage(),
  };

  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    switch (settings.name) {
      case rincian:
        final args = settings.arguments;
        if (args is Layanan) {
          return MaterialPageRoute<String>(
            settings: settings,
            builder: (_) => RincianLayananPage(layanan: args),
          );
        }
        return null;
      case pengajuanBaru:
        return MaterialPageRoute<String>(
          settings: settings,
          builder: (_) => const RincianLayananPage(),
        );
      case rincianPengajuan:
        final args = settings.arguments;
        if (args is int) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => RincianPengajuanPage(idPengajuan: args),
          );
        }
        return null;
    }
    return null;
  }

  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => RouteTidakDikenalPage(nama: settings.name),
    );
  }
}
