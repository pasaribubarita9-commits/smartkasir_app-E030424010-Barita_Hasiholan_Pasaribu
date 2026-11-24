// Model data Produk untuk SmartKasir (versi SQLite)
class Produk {
  final int? id;
  final String? kodeProduk;
  final String nama;
  final String kategori;
  final double hargaBeli;
  final double hargaJual;
  final int stok;
  final String gambarUrl; // disimpan di kolom gambar_path
  final int diskonPersen;
  final String? createdAt;

  const Produk({
    this.id,
    this.kodeProduk,
    required this.nama,
    required this.kategori,
    this.hargaBeli = 0,
    required this.hargaJual,
    required this.stok,
    required this.gambarUrl,
    this.diskonPersen = 0,
    this.createdAt,
  });

  // Objek -> Map untuk disimpan ke SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kode_produk': kodeProduk,
      'nama_produk': nama,
      'kategori': kategori,
      'harga_beli': hargaBeli,
      'harga_jual': hargaJual,
      'stok': stok,
      'gambar_path': gambarUrl,
      'diskon_persen': diskonPersen,
      'created_at': createdAt,
    };
  }

  // Map dari SQLite -> objek Produk
  factory Produk.fromMap(Map<String, dynamic> map) {
    return Produk(
      id: map['id'] as int?,
      kodeProduk: map['kode_produk'] as String?,
      nama: map['nama_produk'] as String? ?? '',
      kategori: map['kategori'] as String? ?? '',
      hargaBeli: (map['harga_beli'] as num?)?.toDouble() ?? 0,
      hargaJual: (map['harga_jual'] as num?)?.toDouble() ?? 0,
      stok: (map['stok'] as num?)?.toInt() ?? 0,
      gambarUrl: map['gambar_path'] as String? ?? '',
      diskonPersen: (map['diskon_persen'] as num?)?.toInt() ?? 0,
      createdAt: map['created_at'] as String?,
    );
  }
}

// Daftar 6 produk awal yang dimasukkan ke SQLite (seeder)
final List<Produk> produkAwalSQLite = [
  const Produk(
    kodeProduk: 'PRD-001',
    nama: 'Kopi Susu Gula Aren 250ml',
    kategori: 'Minuman',
    hargaBeli: 12000,
    hargaJual: 18000,
    stok: 24,
    gambarUrl:
        'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=300',
    diskonPersen: 20,
  ),
  const Produk(
    kodeProduk: 'PRD-002',
    nama: 'Roti Bakar Cokelat Keju',
    kategori: 'Makanan',
    hargaBeli: 9000,
    hargaJual: 15000,
    stok: 5,
    gambarUrl:
        'https://images.unsplash.com/photo-1584776296944-ab6fb57b0bdd?w=300',
  ),
  const Produk(
    kodeProduk: 'PRD-003',
    nama: 'Matcha Latte Ice',
    kategori: 'Minuman',
    hargaBeli: 14000,
    hargaJual: 22000,
    stok: 0,
    gambarUrl:
        'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?w=300',
  ),
  const Produk(
    kodeProduk: 'PRD-004',
    nama: 'Nasi Goreng Banjar Spesial',
    kategori: 'Makanan',
    hargaBeli: 16000,
    hargaJual: 25000,
    stok: 12,
    gambarUrl:
        'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=300',
    diskonPersen: 10,
  ),
  const Produk(
    kodeProduk: 'PRD-005',
    nama: 'Kentang Goreng Crispy',
    kategori: 'Snack',
    hargaBeli: 7000,
    hargaJual: 12000,
    stok: 18,
    gambarUrl:
        'https://images.unsplash.com/photo-1576107232684-1279f3908594?w=300',
  ),
  const Produk(
    kodeProduk: 'PRD-006',
    nama: 'Air Mineral Botol 600ml',
    kategori: 'Minuman',
    hargaBeli: 3000,
    hargaJual: 5000,
    stok: 40,
    gambarUrl:
        'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=300',
  ),
];
