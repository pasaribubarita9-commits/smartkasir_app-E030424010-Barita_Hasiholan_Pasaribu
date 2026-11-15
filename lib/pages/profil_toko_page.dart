import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'kelola_karyawan_page.dart';

class ProfilTokoPage extends StatefulWidget {
  const ProfilTokoPage({super.key});

  @override
  State<ProfilTokoPage> createState() => _ProfilTokoPageState();
}

class _ProfilTokoPageState extends State<ProfilTokoPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaTokoCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  final _waCtrl = TextEditingController();
  final _footerCtrl = TextEditingController();

  String? _namaKasirAktif;

  @override
  void initState() {
    super.initState();
    _muatProfilToko();
  }

  Future<void> _muatProfilToko() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _namaTokoCtrl.text = prefs.getString('nama_toko') ?? 'SmartKasir UMKM';
      _alamatCtrl.text = prefs.getString('alamat_toko') ?? '';
      _waCtrl.text = prefs.getString('kontak_wa') ?? '';
      _footerCtrl.text =
          prefs.getString('footer_struk') ?? 'Terima Kasih Atas Kunjungan Anda';
      _namaKasirAktif = prefs.getString('active_karyawan_nama');
    });
  }

  Future<void> _simpanProfilToko() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('nama_toko', _namaTokoCtrl.text.trim());
    await prefs.setString('alamat_toko', _alamatCtrl.text.trim());
    await prefs.setString('kontak_wa', _waCtrl.text.trim());
    await prefs.setString('footer_struk', _footerCtrl.text.trim());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil toko berhasil disimpan!'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Future<void> _bukaKelolaKaryawan() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const KelolaKaryawanPage()),
    );

    await _muatProfilToko();
  }

  @override
  void dispose() {
    _namaTokoCtrl.dispose();
    _alamatCtrl.dispose();
    _waCtrl.dispose();
    _footerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Toko')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.store, size: 65, color: Colors.teal),
              const SizedBox(height: 20),

              TextFormField(
                controller: _namaTokoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko',
                  prefixIcon: Icon(Icons.store),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama toko wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _alamatCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alamat Toko',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alamat toko wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _waCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor WhatsApp',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _footerCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Footer Struk',
                  prefixIcon: Icon(Icons.receipt_long),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.teal),
                  title: const Text('Kasir Aktif'),
                  subtitle: Text(_namaKasirAktif ?? 'Belum ada kasir aktif'),
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _bukaKelolaKaryawan,
                icon: const Icon(Icons.people),
                label: const Text('Kelola Karyawan'),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _simpanProfilToko,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Profil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
