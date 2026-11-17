import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/karyawan.dart';
import '../helpers/database_helper.dart';
import 'form_karyawan_page.dart';

class KelolaKaryawanPage extends StatefulWidget {
  const KelolaKaryawanPage({super.key});

  @override
  State<KelolaKaryawanPage> createState() => _KelolaKaryawanPageState();
}

class _KelolaKaryawanPageState extends State<KelolaKaryawanPage> {
  // FUNGSI BARU UNTUK WARNA BADGE PERAN
  Widget _buildRoleBadge(String peran) {
    Color warnaLatar;
    Color warnaTeks;

    switch (peran) {
      case 'Supervisor':
        warnaLatar = Colors.purple.shade100;
        warnaTeks = Colors.purple.shade900;
        break;
      case 'Admin':
        warnaLatar = Colors.blue.shade100;
        warnaTeks = Colors.blue.shade900;
        break;
      case 'Manajer':
        warnaLatar = Colors.orange.shade100;
        warnaTeks = Colors.orange.shade900;
        break;
      default:
        warnaLatar = Colors.green.shade100;
        warnaTeks = Colors.green.shade900;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: warnaLatar,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        peran,
        style: TextStyle(color: warnaTeks, fontWeight: FontWeight.bold),
      ),
    );
  }

  // KODE LAMA TETAP DIPERTAHANKAN
  List<Karyawan> _daftarKaryawan = [];
  int? _activeKasirId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = await DatabaseHelper.instance.getAllKaryawan();

    if (!mounted) return;

    setState(() {
      _activeKasirId = prefs.getInt('active_karyawan_id');
      _daftarKaryawan = data;
      _loading = false;
    });
  }

  Future<void> _setKasirAktif(Karyawan karyawan) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('active_karyawan_id', karyawan.id!);
    await prefs.setString('active_karyawan_nama', karyawan.namaKaryawan);

    await _muatData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Kasir aktif berhasil diubah menjadi: ${karyawan.namaKaryawan}',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _hapusKaryawan(Karyawan karyawan) async {
    if (karyawan.id == _activeKasirId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Staf sedang aktif bertugas, ganti kasir aktif terlebih dahulu!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Karyawan?'),
        content: Text('Yakin ingin menghapus ${karyawan.namaKaryawan}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    await DatabaseHelper.instance.deleteKaryawan(karyawan.id!);
    await _muatData();
  }

  Future<void> _bukaForm({Karyawan? karyawan}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormKaryawanPage(karyawan: karyawan)),
    );

    await _muatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Karyawan')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _daftarKaryawan.isEmpty
          ? const Center(child: Text('Belum ada data karyawan'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _daftarKaryawan.length,
              itemBuilder: (context, index) {
                final karyawan = _daftarKaryawan[index];
                final isAktif = karyawan.id == _activeKasirId;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(karyawan.namaKaryawan[0].toUpperCase()),
                    ),
                    title: Text(karyawan.namaKaryawan),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRoleBadge(karyawan.peran),
                        if (isAktif)
                          const Text(
                            'Sedang Bertugas',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'aktif') {
                          _setKasirAktif(karyawan);
                        } else if (value == 'edit') {
                          _bukaForm(karyawan: karyawan);
                        } else if (value == 'hapus') {
                          _hapusKaryawan(karyawan);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'aktif',
                          child: Text('Jadikan Kasir Aktif'),
                        ),
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                          value: 'hapus',
                          child: Text('Hapus'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
