import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/produk.dart';
import '../helpers/database_helper.dart';

class FormProdukPage extends StatefulWidget {
  final Produk? produk;
  const FormProdukPage({super.key, this.produk});

  @override
  State<FormProdukPage> createState() => _FormProdukPageState();
}

class _FormProdukPageState extends State<FormProdukPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _kategoriList = ['Makanan', 'Minuman', 'Snack'];

  late TextEditingController _namaController;
  late TextEditingController _hargaBeliController;
  late TextEditingController _hargaJualController;
  late TextEditingController _stokController;
  late TextEditingController _diskonController;
  late TextEditingController _gambarController;
  late String _kategori;

  bool get _isEdit => widget.produk != null;

  @override
  void initState() {
    super.initState();
    final p = widget.produk;
    _namaController = TextEditingController(text: p?.nama ?? '');
    _hargaBeliController = TextEditingController(
      text: p != null ? p.hargaBeli.toStringAsFixed(0) : '',
    );
    _hargaJualController = TextEditingController(
      text: p != null ? p.hargaJual.toStringAsFixed(0) : '',
    );
    _stokController = TextEditingController(text: p != null ? '${p.stok}' : '');
    _diskonController = TextEditingController(
      text: p != null ? '${p.diskonPersen}' : '0',
    );
    _gambarController = TextEditingController(text: p?.gambarUrl ?? '');
    _kategori = (p != null && _kategoriList.contains(p.kategori))
        ? p.kategori
        : _kategoriList.first;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();
    _stokController.dispose();
    _diskonController.dispose();
    _gambarController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final kode =
        widget.produk?.kodeProduk ??
        'PRD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';

    final produk = Produk(
      id: widget.produk?.id,
      kodeProduk: kode,
      nama: _namaController.text.trim(),
      kategori: _kategori,
      hargaBeli: double.tryParse(_hargaBeliController.text.trim()) ?? 0,
      hargaJual: double.tryParse(_hargaJualController.text.trim()) ?? 0,
      stok: int.tryParse(_stokController.text.trim()) ?? 0,
      gambarUrl: _gambarController.text.trim(),
      diskonPersen: int.tryParse(_diskonController.text.trim()) ?? 0,
      createdAt: widget.produk?.createdAt ?? now,
    );

    try {
      if (_isEdit) {
        await DatabaseHelper.instance.updateProduk(produk);
      } else {
        await DatabaseHelper.instance.insertProduk(produk);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdit
                ? 'Produk berhasil diperbarui!'
                : 'Produk baru berhasil ditambahkan!',
          ),
          backgroundColor: const Color(0xFF1E3A8A),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String? _wajib(String? v, String pesan) =>
      (v == null || v.trim().isEmpty) ? pesan : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk Baru'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk *',
                  prefixIcon: Icon(Icons.fastfood_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => _wajib(v, 'Nama produk wajib diisi'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori *',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _kategoriList
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) => setState(() => _kategori = v ?? _kategori),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hargaBeliController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Beli *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => _wajib(v, 'Wajib diisi'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _hargaJualController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga Jual *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => _wajib(v, 'Wajib diisi'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stokController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => _wajib(v, 'Wajib diisi'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _diskonController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Diskon (%)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _gambarController,
                decoration: const InputDecoration(
                  labelText: 'URL Gambar (opsional)',
                  prefixIcon: Icon(Icons.image_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isEdit ? 'Perbarui Produk' : 'Simpan Produk Baru',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
