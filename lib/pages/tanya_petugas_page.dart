import 'package:flutter/material.dart';

class Pesan {
  const Pesan(this.teks, this.dariWarga);
  final String teks;
  final bool dariWarga;
}

class TanyaPetugasPage extends StatefulWidget {
  const TanyaPetugasPage({super.key});

  @override
  State<TanyaPetugasPage> createState() => _TanyaPetugasPageState();
}

class _TanyaPetugasPageState extends State<TanyaPetugasPage> {
  final List<Pesan> _pesan = [
    const Pesan(
      'Selamat datang di Tanya Petugas. Ada yang bisa kami bantu?',
      false,
    ),
  ];
  final _input = TextEditingController();
  final _gulir = ScrollController();
  bool _petugasMengetik = false;

  @override
  void dispose() {
    _input.dispose();
    _gulir.dispose();
    super.dispose();
  }

  void _kirim() {
    final teks = _input.text.trim();
    if (teks.isEmpty) return;
    setState(() {
      _pesan.add(Pesan(teks, true));
      _petugasMengetik = true;
    });
    _input.clear();
    _keBawah();

    // Simulasi balasan petugas
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _pesan.add(Pesan(_balas(teks), false));
        _petugasMengetik = false;
      });
      _keBawah();
    });
  }

  String _balas(String teks) {
    final k = teks.toLowerCase();
    if (k.contains('jam')) {
      return 'Layanan buka Senin sampai Jumat, pukul 08.00 - 15.00.';
    }
    if (k.contains('izin')) {
      return 'Untuk perizinan, silakan ajukan melalui menu Layanan pada tab Perizinan.';
    }
    if (k.contains('terima kasih')) return 'Sama-sama. Semoga membantu!';
    return 'Terima kasih, pesan Anda sudah kami terima. Petugas akan segera membalas.';
  }

  void _keBawah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_gulir.hasClients) {
        _gulir.animateTo(
          _gulir.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _gelembung(Pesan p) {
    final cs = Theme.of(context).colorScheme;
    const r = Radius.circular(16);
    const kecil = Radius.circular(4);
    return Align(
      alignment: p.dariWarga ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: p.dariWarga ? cs.primaryContainer : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: r,
            topRight: r,
            bottomLeft: p.dariWarga ? r : kecil,
            bottomRight: p.dariWarga ? kecil : r,
          ),
        ),
        child: Text(p.teks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _gulir,
            padding: const EdgeInsets.all(16),
            itemCount: _pesan.length + (_petugasMengetik ? 1 : 0),
            itemBuilder: (context, i) {
              if (i == _pesan.length) {
                return _gelembung(
                  const Pesan('Petugas sedang mengetik...', false),
                );
              }
              return _gelembung(_pesan[i]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _kirim(),
                  decoration: const InputDecoration(
                    hintText: 'Tulis pesan...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _kirim,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
