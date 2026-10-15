import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LokasiKantorPage extends StatelessWidget {
  const LokasiKantorPage({super.key});

  // Koordinat contoh, ganti sesuai kota yang dipakai
  static const _pusat = LatLng(-6.1780, 106.8350);

  static final Set<Marker> _penanda = {
    const Marker(
      markerId: MarkerId('kominfo'),
      position: LatLng(-6.1754, 106.8272),
      infoWindow: InfoWindow(
        title: 'Kantor Dinas Kominfo',
        snippet: 'Layanan Perizinan',
      ),
    ),
    const Marker(
      markerId: MarkerId('kesehatan'),
      position: LatLng(-6.1890, 106.8350),
      infoWindow: InfoWindow(
        title: 'Kantor Dinas Kesehatan',
        snippet: 'Layanan Kesehatan',
      ),
    ),
    const Marker(
      markerId: MarkerId('perhubungan'),
      position: LatLng(-6.1650, 106.8450),
      infoWindow: InfoWindow(
        title: 'Kantor Dinas Perhubungan',
        snippet: 'Layanan Transportasi',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(target: _pusat, zoom: 13),
      markers: _penanda,
      zoomControlsEnabled: true,
    );
  }
}
