# Rancangan Fisik Database – Brand NyamHap
Tahap **Physical Design** merupakan transformasi dari model logis ke model fisik yang dapat dijalankan di DBMS PostgreSQL.  
Fokus utama: pemilihan tipe data, penerapan constraint (PK, FK, UNIQUE, CHECK, DEFAULT), serta pembuatan tabel sesuai kebutuhan sistem.

## Tabel Utama (Superclass)

# Staff
| Atribut        | Tipe Data     | PK/FK | Constraints                | Justifikasi |
|----------------|---------------|-------|----------------------------|-------------|
| StaffID        | VARCHAR(10)   | PK    | NOT NULL, UNIQUE           | ID string fleksibel, wajib unik |
| NamaS          | VARCHAR(100)  |       | NOT NULL                   | Nama teks panjang, tidak boleh kosong |
| NoHandphoneS   | VARCHAR(15)   |       | NOT NULL, UNIQUE           | Nomor telepon variatif, wajib unik |
| Email          | VARCHAR(100)  |       | NOT NULL, UNIQUE           | Email teks panjang, wajib unik |
| PasswordHash   | VARCHAR(255)  |       | NULL                       | Untuk autentikasi staff |
| RoleKode       | VARCHAR(10)   |       | NULL                       | Kode peran staff (Founder, SPem, SMar, dll) |

## Tabel Subclass Staff

# StaffKeuangan
| Atribut         | Tipe Data    | PK/FK | Constraints | Justifikasi |
|-----------------|--------------|-------|-------------|-------------|
| StaffID         | VARCHAR(10)  | PK/FK | NOT NULL    | Relasi ke Staff |
| JenisTransaksi  | VARCHAR(20)  |       | CHECK IN ('Penjualan','Pengeluaran') | Validasi jenis transaksi |
| TanggalTransaksi| DATE         |       | NOT NULL    | Tanggal transaksi wajib ada |

# StaffPenjualan
| Atribut         | Tipe Data    | PK/FK | Constraints | Justifikasi |
|-----------------|--------------|-------|-------------|-------------|
| StaffID         | VARCHAR(10)  | PK/FK | NOT NULL    | Relasi ke Staff |
| TargetPenjualan | INT          |       | CHECK >= 0  | Target harus positif |
| JumlahPenjualan | INT          |       | CHECK >= 0  | Jumlah harus positif |
| WilayahPenjualan| VARCHAR(50)  |       | NOT NULL    | Nama wilayah wajib ada |

# StaffProduksi
| Atribut        | Tipe Data    | PK/FK | Constraints | Justifikasi |
|----------------|--------------|-------|-------------|-------------|
| StaffID        | VARCHAR(10)  | PK/FK | NOT NULL    | Relasi ke Staff |
| JumlahProduksi | INT          |       | CHECK >= 0  | Produksi harus positif |

# StaffPemasok
| Atribut        | Tipe Data    | PK/FK | Constraints | Justifikasi |
|----------------|--------------|-------|-------------|-------------|
| StaffID        | VARCHAR(10)  | PK/FK | NOT NULL    | Relasi ke Staff |
| JenisBarang    | VARCHAR(50)  |       | NOT NULL    | Nama barang wajib ada |
| TanggalPasokan | DATE         |       | NOT NULL    | Tanggal pasokan wajib ada |
| MetodePembayaran| VARCHAR(20) |       | CHECK IN ('Cash','Transfer') | Validasi metode pembayaran |

# StaffMarketing
| Atribut        | Tipe Data    | PK/FK | Constraints | Justifikasi |
|----------------|--------------|-------|-------------|-------------|
| StaffID        | VARCHAR(10)  | PK/FK | NOT NULL    | Relasi ke Staff |
| JenisKampanye  | VARCHAR(100) |       | NOT NULL    | Nama kampanye wajib ada |
| Budget         | INT          |       | CHECK >= 0  | Budget tidak boleh negatif |

## Tabel Independen
# Pelanggan
| Atribut       | Tipe Data    | PK/FK | Constraints | Justifikasi |
|---------------|--------------|-------|-------------|-------------|
| PelangganID   | VARCHAR(10)  | PK    | NOT NULL, UNIQUE | ID pelanggan wajib unik |
| NamaP         | VARCHAR(100) |       | NOT NULL    | Nama pelanggan wajib ada |
| NoHandphoneP  | VARCHAR(15)  |       | NOT NULL, UNIQUE | Nomor telepon wajib unik |

# Menu
| Atribut       | Tipe Data    | PK/FK | Constraints | Justifikasi |
|---------------|--------------|-------|-------------|-------------|
| MenuID        | VARCHAR(10)  | PK    | NOT NULL, UNIQUE | ID menu wajib unik |
| NamaMenu      | VARCHAR(100) |       | NOT NULL    | Nama menu wajib ada |
| Harga         | INT          |       | CHECK > 0   | Harga tidak boleh nol/negatif |
| Deskripsi     | TEXT         |       | NOT NULL    | Deskripsi menu wajib ada |

# BahanBaku
| Atribut       | Tipe Data    | PK/FK | Constraints | Justifikasi |
|---------------|--------------|-------|-------------|-------------|
| BahanID       | VARCHAR(10)  | PK    | NOT NULL, UNIQUE | ID bahan wajib unik |
| NamaBahan     | VARCHAR(50)  |       | NOT NULL, UNIQUE | Nama bahan wajib unik |
| Satuan        | VARCHAR(20)  |       | NOT NULL    | Satuan wajib ada |
| Stok          | FLOAT        |       | CHECK >= 0  | Stok tidak boleh negatif |
| HargaPerUnit  | INT          |       | CHECK >= 0  | Harga per unit tidak boleh negatif |

## Tabel Transaksi & Relasi
# Pesanan
| Atribut       | Tipe Data    | PK/FK | Constraints | Justifikasi |
|---------------|--------------|-------|-------------|-------------|
| PesananID     | VARCHAR(10)  | PK    | NOT NULL, UNIQUE | ID pesanan wajib unik |
| PelangganID   | VARCHAR(10)  | FK    | ON DELETE CASCADE | Relasi ke Pelanggan |
| Tanggal       | DATE         |       | DEFAULT CURRENT_DATE | Tanggal otomatis sesuai input |
| TotalHarga    | INT          |       | CHECK >= 0  | Total harga tidak boleh negatif |

# DetailPesanan
| Atribut       | Tipe Data    | PK/FK | Constraints | Justifikasi |
|---------------|--------------|-------|-------------|-------------|
| PesananID     | VARCHAR(10)  | PK/FK | ON DELETE CASCADE | Relasi ke Pesanan |
| MenuID        | VARCHAR(10)  | PK/FK | ON DELETE CASCADE | Relasi ke Menu |
| PilihanMenu   | VARCHAR(100) |       | NOT NULL    | Nama menu tambahan wajib ada |
| JumlahMenu    | INT          |       | CHECK > 0   | Minimal 1 menu per detail |

# Pembayaran
| Atribut          | Tipe Data    | PK/FK | Constraints | Justifikasi |
|------------------|--------------|-------|-------------|-------------|
| PembayaranID     | VARCHAR(10)  | PK    | NOT NULL, UNIQUE | ID pembayaran wajib unik |
| PesananID        | VARCHAR(10)  | FK    | ON DELETE CASCADE | Relasi ke Pesanan |
| TanggalPembayaran| DATE         |       | DEFAULT CURRENT_DATE | Tanggal otomatis |
| MetodePembayaran | VARCHAR(20)  |       | CHECK IN ('Cash','Transfer','QRIS','E-Wallet') | Validasi metode |
| StatusPembayaran | VARCHAR(20)  |       | CHECK IN ('Lunas','Pending','Gagal') | Validasi status |

# Resep
| Atribut       | Tipe Data    | PK/FK | Constraints | Justifikasi |
|---------------|--------------|-------|-------------|-------------|
| MenuID        | VARCHAR(10)  | PK/FK | ON DELETE CASCADE | Relasi ke Menu |
| BahanID       | VARCHAR(10)  | PK/FK | ON DELETE CASCADE | Relasi ke BahanBaku |
| JumlahBahan   | FLOAT        |       | CHECK > 0   | Jumlah bahan harus positif |

# Periklanan
| Atribut       | Tipe Data    | PK/FK | Constraints | Justifikasi |
|---------------|--------------|-------|-------------|-------------|
| PeriklananID  | VARCHAR(10)  | PK    | NOT NULL, UNIQUE | ID iklan wajib unik |
| StaffID       | VARCHAR(10)  | FK    | NOT NULL    | Relasi ke Staff |
| MediaPeriklanan| VARCHAR(50) |       | NOT NULL    | Media iklan wajib ada |
| TanggalMulai  | DATE         |       | NOT NULL    | Tanggal mulai wajib ada |
| TanggalSelesai| DATE         |       | CHECK >= TanggalMulai | Validasi temporal |
| Biaya         | INT          |       | CHECK >= 0  | Biaya iklan tidak boleh negatif |
