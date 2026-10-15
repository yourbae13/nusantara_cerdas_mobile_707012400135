import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nusantara Cerdas Mobile v1.0'),
            const SizedBox(height: 16),
            OutlinedButton(
              // uji route yang tidak terdaftar
              onPressed: () => Navigator.pushNamed(context, '/rute-salah'),
              child: const Text('Uji Route Tidak Dikenal'),
            ),
          ],
        ),
      ),
    );
  }
}
