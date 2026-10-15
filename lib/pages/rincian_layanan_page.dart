import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pengajuan_model.dart';
import 'layanan_data.dart';

class RincianLayananPage extends StatefulWidget {
  // layanan null = dibuka dari tombol + di tujuan Warga (pilih layanan sendiri)
  const RincianLayananPage({super.key, this.layanan});
  final Layanan? layanan;

  @override
  State<RincianLayananPage> createState() => _RincianLayananPageState();
}

class _RincianLayananPageState extends State<RincianLayananPage> {
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  Layanan? _layanan;
  bool _setuju = false;
  SesiKunjungan _sesi = SesiKunjungan.pagi; // state lokal untuk groupValue
  bool _mengirim = false;

  @override
  void initState() {
    super.initState();
    _layanan = widget.layanan;
    _namaCtrl.addListener(_segarkan);
    _emailCtrl.addListener(_segarkan);
  }

  void _segarkan() => setState(() {});

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  bool get _emailValid => _emailCtrl.text.contains('@');

  bool get _lengkap =>
      _layanan != null &&
      _namaCtrl.text.trim().isNotEmpty &&
      _emailCtrl.text.trim().isNotEmpty &&
      _emailValid &&
      _setuju;

  Future<void> _kirim() async {
    setState(() => _mengirim = true);
    await Future.delayed(const Duration(seconds: 2)); // simulasi pengiriman
    if (!mounted) return;
    final l = _layanan!;
    context.read<PengajuanModel>().tambah(
      layanan: l.nama,
      bidang: l.bidang,
      nama: _namaCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      sesi: _sesi,
    );
    Navigator.pop(context, 'Permohonan ${l.nama.toLowerCase()} telah diajukan');
  }

  Widget _infoLayanan(Layanan l) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.nama),
            subtitle: Text(l.bidang),
          ),
          ListTile(
            leading: const Icon(Icons.apartment),
            title: const Text('Dinas penanggung jawab'),
            subtitle: Text(l.dinas),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Jam operasional'),
            subtitle: Text(l.jam),
          ),
          ListTile(
            leading: const Icon(Icons.notes),
            title: const Text('Keterangan'),
            subtitle: Text(l.keterangan),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.layanan == null ? 'Pengajuan Baru' : 'Rincian Layanan',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (widget.layanan != null)
            _infoLayanan(widget.layanan!)
          else
            DropdownButtonFormField<Layanan>(
              initialValue: _layanan,
              decoration: const InputDecoration(
                labelText: 'Layanan',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final l in semuaLayanan)
                  DropdownMenuItem(
                    value: l,
                    child: Text('${l.bidang} - ${l.nama}'),
                  ),
              ],
              onChanged: (v) => setState(() => _layanan = v),
            ),
          const SizedBox(height: 20),
          Text(
            'Formulir Pengajuan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _namaCtrl,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nama lengkap',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              border: const OutlineInputBorder(),
              errorText: _emailCtrl.text.isNotEmpty && !_emailValid
                  ? 'Email harus mengandung "@"'
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Text('Sesi kunjungan', style: Theme.of(context).textTheme.titleSmall),
          for (final s in SesiKunjungan.values)
            RadioListTile<SesiKunjungan>(
              title: Text(s.label),
              value: s,
              groupValue: _sesi,
              onChanged: (v) => setState(() => _sesi = v!),
            ),
          CheckboxListTile(
            value: _setuju,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Saya menyetujui penggunaan data pribadi'),
            onChanged: (v) => setState(() => _setuju = v ?? false),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _lengkap && !_mengirim ? _kirim : null,
            child: _mengirim
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Mengirim...'),
                    ],
                  )
                : const Text('Kirim Pengajuan'),
          ),
        ],
      ),
    );
  }
}
