-- Schema SQL – Brand NyamHap Database

-- 1. TABEL UTAMA (SUPERCLASS)
CREATE TABLE Staff (
    StaffID VARCHAR(10) PRIMARY KEY,
    NamaS VARCHAR(100) NOT NULL,
    NoHandphoneS VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255),
    RoleKode VARCHAR(10)
);

-- 2. TABEL INDEPENDEN
CREATE TABLE Pelanggan (
    PelangganID VARCHAR(10) PRIMARY KEY,
    NamaP VARCHAR(100) NOT NULL,
    NoHandphoneP VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE Menu (
    MenuID VARCHAR(10) PRIMARY KEY,
    NamaMenu VARCHAR(100) NOT NULL,
    Harga INT NOT NULL CHECK(Harga > 0),
    Deskripsi TEXT NOT NULL
);

CREATE TABLE BahanBaku (
    BahanID VARCHAR(10) PRIMARY KEY,
    NamaBahan VARCHAR(50) NOT NULL UNIQUE,
    Satuan VARCHAR(20) NOT NULL,
    Stok FLOAT CHECK(Stok >= 0),
    HargaPerUnit INT CHECK(HargaPerUnit >= 0)
);

-- 3. TABEL SUBCLASS STAFF
CREATE TABLE StaffKeuangan (
    StaffID VARCHAR(10) PRIMARY KEY REFERENCES Staff(StaffID),
    JenisTransaksi VARCHAR(20) CHECK(JenisTransaksi IN ('Penjualan', 'Pengeluaran')),
    TanggalTransaksi DATE NOT NULL
);

CREATE TABLE StaffPenjualan (
    StaffID VARCHAR(10) PRIMARY KEY REFERENCES Staff(StaffID),
    TargetPenjualan INT CHECK(TargetPenjualan >= 0),
    JumlahPenjualan INT CHECK(JumlahPenjualan >= 0),
    WilayahPenjualan VARCHAR(50) NOT NULL
);

CREATE TABLE StaffProduksi (
    StaffID VARCHAR(10) PRIMARY KEY REFERENCES Staff(StaffID),
    JumlahProduksi INT CHECK(JumlahProduksi >= 0)
);

CREATE TABLE StaffPemasok (
    StaffID VARCHAR(10) PRIMARY KEY REFERENCES Staff(StaffID),
    JenisBarang VARCHAR(50) NOT NULL,
    TanggalPasokan DATE NOT NULL,
    MetodePembayaran VARCHAR(20) CHECK(MetodePembayaran IN ('Cash', 'Transfer'))
);

CREATE TABLE StaffMarketing (
    StaffID VARCHAR(10) PRIMARY KEY REFERENCES Staff(StaffID),
    JenisKampanye VARCHAR(100) NOT NULL,
    Budget INT CHECK(Budget >= 0)
);

-- 4. TABEL TRANSAKSI & RELASI
CREATE TABLE Pesanan (
    PesananID VARCHAR(10) PRIMARY KEY,
    PelangganID VARCHAR(10) NOT NULL REFERENCES Pelanggan(PelangganID) ON DELETE CASCADE,
    Tanggal DATE DEFAULT CURRENT_DATE,
    TotalHarga INT CHECK(TotalHarga >= 0)
);

CREATE TABLE Periklanan (
    PeriklananID VARCHAR(10) PRIMARY KEY,
    StaffID VARCHAR(10) NOT NULL REFERENCES Staff(StaffID),
    MediaPeriklanan VARCHAR(50) NOT NULL,
    TanggalMulai DATE NOT NULL,
    TanggalSelesai DATE CHECK(TanggalSelesai >= TanggalMulai),
    Biaya INT CHECK(Biaya >= 0)
);

CREATE TABLE Pembayaran (
    PembayaranID VARCHAR(10) PRIMARY KEY,
    PesananID VARCHAR(10) NOT NULL REFERENCES Pesanan(PesananID) ON DELETE CASCADE,
    TanggalPembayaran DATE DEFAULT CURRENT_DATE,
    MetodePembayaran VARCHAR(20) CHECK (MetodePembayaran IN ('Cash','Transfer','QRIS','E-Wallet')),
    StatusPembayaran VARCHAR(20) CHECK (StatusPembayaran IN ('Lunas','Pending','Gagal'))
);

-- 5. TABEL M:M (COMPOSITE KEY)
CREATE TABLE DetailPesanan (
    PesananID VARCHAR(10) NOT NULL,
    MenuID VARCHAR(10) NOT NULL,
    PilihanMenu VARCHAR(100) NOT NULL,
    JumlahMenu INT CHECK(JumlahMenu > 0),
    PRIMARY KEY (PesananID, MenuID),
    FOREIGN KEY (PesananID) REFERENCES Pesanan(PesananID) ON DELETE CASCADE,
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID) ON DELETE CASCADE
);

CREATE TABLE Resep (
    MenuID VARCHAR(10) NOT NULL,
    BahanID VARCHAR(10) NOT NULL,
    JumlahBahan FLOAT CHECK(JumlahBahan > 0),
    PRIMARY KEY (MenuID, BahanID),
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID) ON DELETE CASCADE,
    FOREIGN KEY (BahanID) REFERENCES BahanBaku(BahanID) ON DELETE CASCADE
);
