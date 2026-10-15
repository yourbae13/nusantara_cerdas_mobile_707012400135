import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';
import '../models/ikon_warga_badge.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key, this.indeksAwal = 0});
  final int indeksAwal;

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  static const _tujuan = AppRoutes.tujuanUtama;

  late int _indeks;
  // Halaman baru dibuat saat pertama dikunjungi (peta tidak dimuat
  // sebelum dibuka), lalu keadaannya dipertahankan oleh IndexedStack.
  final Set<int> _sudahDibuka = {};

  @override
  void initState() {
    super.initState();
    _indeks = widget.indeksAwal;
    _sudahDibuka.add(_indeks);
  }

  void _pilih(int i) => setState(() {
    _indeks = i;
    _sudahDibuka.add(i);
  });

  Widget _isi() => IndexedStack(
    index: _indeks,
    children: [
      for (var i = 0; i < _tujuan.length; i++)
        _sudahDibuka.contains(i) ? _tujuan[i].halaman : const SizedBox.shrink(),
    ],
  );

  Widget _ikon(Tujuan t, {bool terpilih = false}) {
    final data = terpilih ? t.selectedIcon : t.icon;
    return t.route == AppRoutes.warga ? IkonWargaBadge(ikon: data) : Icon(data);
  }

  Widget _drawer() {
    return NavigationDrawer(
      selectedIndex: _indeks,
      onDestinationSelected: (i) {
        Navigator.pop(context); // tutup drawer dulu
        if (i < _tujuan.length) {
          _pilih(i);
        } else {
          Navigator.pushNamed(context, AppRoutes.tentang);
        }
      },
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 24, 16, 12),
          child: Text(
            'Nusantara Cerdas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        for (final t in _tujuan)
          NavigationDrawerDestination(
            icon: _ikon(t),
            selectedIcon: _ikon(t, terpilih: true),
            label: Text(t.judul),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 8, 28, 8),
          child: Divider(),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.info_outline),
          label: Text('Tentang Aplikasi'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _indeks == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _pilih(0); // kembali ke tujuan pertama, bukan tutup app
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final lebar = constraints.maxWidth >= 600;
          return Scaffold(
            appBar: AppBar(title: Text(_tujuan[_indeks].judul)),
            drawer: _drawer(),
            body: lebar
                ? Row(
                    children: [
                      NavigationRail(
                        selectedIndex: _indeks,
                        onDestinationSelected: _pilih,
                        labelType: NavigationRailLabelType.all,
                        destinations: [
                          for (final t in _tujuan)
                            NavigationRailDestination(
                              icon: _ikon(t),
                              selectedIcon: _ikon(t, terpilih: true),
                              label: Text(t.label),
                            ),
                        ],
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(child: _isi()),
                    ],
                  )
                : _isi(),
            bottomNavigationBar: lebar
                ? null
                : NavigationBar(
                    selectedIndex: _indeks,
                    onDestinationSelected: _pilih,
                    destinations: [
                      for (final t in _tujuan)
                        NavigationDestination(
                          icon: _ikon(t),
                          selectedIcon: _ikon(t, terpilih: true),
                          label: t.label,
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
