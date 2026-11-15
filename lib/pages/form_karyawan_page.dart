import 'package:flutter/material.dart';

import '../models/karyawan.dart';
import '../helpers/database_helper.dart';

class FormKaryawanPage extends StatefulWidget {
  final Karyawan? karyawan;

  const FormKaryawanPage({super.key, this.karyawan});

  @override
  State<FormKaryawanPage> createState() => _FormKaryawanPageState();
}

class _FormKaryawanPageState extends State<FormKaryawanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _pinController = TextEditingController();

  String _peran = 'Kasir';
  bool _isPinHidden = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.karyawan != null) {
      _namaController.text = widget.karyawan!.namaKaryawan;
      _pinController.text = widget.karyawan!.pin;
      _peran = widget.karyawan!.peran;
    }
  }

  Future<void> _simpanKaryawan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final karyawan = Karyawan(
      id: widget.karyawan?.id,
      namaKaryawan: _namaController.text.trim(),
      pin: _pinController.text.trim(),
      peran: _peran,
      createdAt: widget.karyawan?.createdAt ?? DateTime.now().toIso8601String(),
    );

    try {
      if (widget.karyawan == null) {
        await DatabaseHelper.instance.insertKaryawan(karyawan);
      } else {
        await DatabaseHelper.instance.updateKaryawan(karyawan);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.karyawan == null
                ? 'Karyawan berhasil ditambahkan!'
                : 'Data karyawan berhasil diperbarui!',
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.karyawan != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Karyawan' : 'Tambah Karyawan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 45),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Karyawan',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Nama wajib diisi minimal 3 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _pinController,
                obscureText: _isPinHidden,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'PIN Kasir (4 Digit)',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPinHidden ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPinHidden = !_isPinHidden;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || !RegExp(r'^[0-9]{4}$').hasMatch(value)) {
                    return 'PIN wajib terdiri dari tepat 4 angka!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _peran,
                decoration: const InputDecoration(
                  labelText: 'Peran Karyawan',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                ),
                items: ['Kasir', 'Admin', 'Manajer']
                    .map(
                      (peran) =>
                          DropdownMenuItem(value: peran, child: Text(peran)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _peran = value);
                  }
                },
              ),

              const SizedBox(height: 28),

              ElevatedButton.icon(
                onPressed: _isSaving ? null : _simpanKaryawan,
                icon: const Icon(Icons.check),
                label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Karyawan'),
                style: ElevatedButton.styleFrom(
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
