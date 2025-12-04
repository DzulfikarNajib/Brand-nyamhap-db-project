/* ============================================================
   MISSION OBJECTIVES – BRAND NYAMHAP DATABASE
   File ini berisi kumpulan query SQL untuk pencarian, pelacakan,
   dan pelaporan data sesuai kebutuhan sistem.
   ============================================================ */

/* =========================
   A. PENCARIAN DATA
   ========================= */

-- 1. Daftar menu beserta harga
SELECT MenuID, NamaMenu, Harga
FROM Menu
ORDER BY NamaMenu;

-- 2. Total pesanan pelanggan dalam periode tertentu
-- Ganti :start_date dan :end_date sesuai kebutuhan
SELECT p.PelangganID, pl.NamaP, COUNT(*) AS JumlahPesanan, SUM(p.TotalHarga) AS TotalBelanja
FROM Pesanan p
JOIN Pelanggan pl ON pl.PelangganID = p.PelangganID
WHERE p.Tanggal BETWEEN DATE :start_date AND DATE :end_date
GROUP BY p.PelangganID, pl.NamaP;

-- 3. Total pemasukan per hari
SELECT Tanggal, SUM(TotalHarga) AS TotalPemasukanHarian
FROM Pesanan
GROUP BY Tanggal
ORDER BY Tanggal;

-- 4. Total pemasukan per bulan
SELECT DATE_TRUNC('month', Tanggal) AS Bulan, SUM(TotalHarga) AS TotalPemasukanBulanan
FROM Pesanan
GROUP BY DATE_TRUNC('month', Tanggal)
ORDER BY Bulan;

-- 5. Stok bahan baku saat ini
SELECT BahanID, NamaBahan, Satuan, Stok, HargaPerUnit
FROM BahanBaku
ORDER BY NamaBahan;

-- 6. Total bahan baku digunakan dalam periode tertentu
SELECT bb.BahanID, bb.NamaBahan, SUM(r.JumlahBahan * dp.JumlahMenu) AS TotalDigunakan
FROM DetailPesanan dp
JOIN Pesanan ps ON ps.PesananID = dp.PesananID
JOIN Resep r ON r.MenuID = dp.MenuID
JOIN BahanBaku bb ON bb.BahanID = r.BahanID
WHERE ps.Tanggal BETWEEN DATE :start_date AND DATE :end_date
GROUP BY bb.BahanID, bb.NamaBahan;

-- 7. Data staff dan posisi masing-masing
SELECT s.StaffID, s.NamaS, s.RoleKode,
  CASE
    WHEN sk.StaffID IS NOT NULL THEN 'Keuangan'
    WHEN spj.StaffID IS NOT NULL THEN 'Penjualan'
    WHEN spr.StaffID IS NOT NULL THEN 'Produksi'
    WHEN spm.StaffID IS NOT NULL THEN 'Pemasok'
    WHEN sm.StaffID IS NOT NULL THEN 'Marketing'
    ELSE 'General'
  END AS Posisi
FROM Staff s
LEFT JOIN StaffKeuangan sk ON sk.StaffID = s.StaffID
LEFT JOIN StaffPenjualan spj ON spj.StaffID = s.StaffID
LEFT JOIN StaffProduksi spr ON spr.StaffID = s.StaffID
LEFT JOIN StaffPemasok spm ON spm.StaffID = s.StaffID
LEFT JOIN StaffMarketing sm ON sm.StaffID = s.StaffID;

-- 8. Pengeluaran bahan baku vs pemasukan
WITH penggunaan AS (
  SELECT r.BahanID, SUM(r.JumlahBahan * dp.JumlahMenu) AS total_qty
  FROM DetailPesanan dp
  JOIN Pesanan ps ON ps.PesananID = dp.PesananID
  JOIN Resep r ON r.MenuID = dp.MenuID
  WHERE ps.Tanggal BETWEEN DATE :start_date AND DATE :end_date
  GROUP BY r.BahanID
),
pengeluaran AS (
  SELECT SUM(p.total_qty * bb.HargaPerUnit) AS total_pengeluaran
  FROM penggunaan p JOIN BahanBaku bb ON bb.BahanID = p.BahanID
),
pemasukan AS (
  SELECT SUM(TotalHarga) AS total_pemasukan
  FROM Pesanan
  WHERE Tanggal BETWEEN DATE :start_date AND DATE :end_date
)
SELECT pe.total_pengeluaran, pm.total_pemasukan, (pm.total_pemasukan - pe.total_pengeluaran) AS LabaKotor
FROM pengeluaran pe, pemasukan pm;

-- 9. Iklan aktif pada tanggal tertentu
SELECT PeriklananID, MediaPeriklanan, TanggalMulai, TanggalSelesai, Biaya
FROM Periklanan
WHERE DATE :target_date BETWEEN TanggalMulai AND TanggalSelesai;

-- 10. Pelanggan paling sering memesan
SELECT pl.PelangganID, pl.NamaP, COUNT(ps.PesananID) AS FrekuensiPesanan
FROM Pelanggan pl
JOIN Pesanan ps ON ps.PelangganID = pl.PelangganID
GROUP BY pl.PelangganID, pl.NamaP
ORDER BY FrekuensiPesanan DESC
LIMIT 10;


/* =========================
   B. PELACAKAN DATA
   ========================= */

-- 1. Status pelanggan yang sedang memesan (belum lunas)
SELECT pl.NamaP, ps.PesananID, pb.StatusPembayaran
FROM Pesanan ps
JOIN Pelanggan pl ON pl.PelangganID = ps.PelangganID
LEFT JOIN Pembayaran pb ON pb.PesananID = ps.PesananID
WHERE COALESCE(pb.StatusPembayaran, 'Pending') <> 'Lunas';

-- 2. Menu yang dipesan pada suatu pesanan
SELECT dp.PesananID, m.NamaMenu, dp.JumlahMenu
FROM DetailPesanan dp
JOIN Menu m ON m.MenuID = dp.MenuID
WHERE dp.PesananID = :pesanan_id;

-- 3. Status pembayaran
SELECT ps.PesananID, pl.NamaP, pb.MetodePembayaran, pb.StatusPembayaran
FROM Pesanan ps
JOIN Pelanggan pl ON pl.PelangganID = ps.PelangganID
LEFT JOIN Pembayaran pb ON pb.PesananID = ps.PesananID;

-- 4. Status stok bahan baku
WITH penggunaan AS (
  SELECT r.BahanID, SUM(r.JumlahBahan * dp.JumlahMenu) AS total_pakai
  FROM DetailPesanan dp
  JOIN Pesanan ps ON ps.PesananID = dp.PesananID
  JOIN Resep r ON r.MenuID = dp.MenuID
  WHERE ps.Tanggal BETWEEN DATE :start_date AND DATE :end_date
  GROUP BY r.BahanID
)
SELECT bb.NamaBahan, bb.Stok, COALESCE(p.total_pakai,0) AS Terpakai, (bb.Stok - COALESCE(p.total_pakai,0)) AS Sisa
FROM BahanBaku bb
LEFT JOIN penggunaan p ON p.BahanID = bb.BahanID;

-- 5. Status periklanan
SELECT PeriklananID, MediaPeriklanan,
  CASE
    WHEN CURRENT_DATE BETWEEN TanggalMulai AND TanggalSelesai THEN 'Aktif'
    WHEN CURRENT_DATE < TanggalMulai THEN 'Scheduled'
    ELSE 'Selesai'
  END AS Status
FROM Periklanan;


/* =========================
   C. PELAPORAN DATA
   ========================= */

-- 1. Laporan data staff
SELECT * FROM Staff;

-- 2. Laporan data pelanggan
SELECT pl.PelangganID, pl.NamaP, COUNT(ps.PesananID) AS TotalPesanan
FROM Pelanggan pl
LEFT JOIN Pesanan ps ON ps.PelangganID = pl.PelangganID
GROUP BY pl.PelangganID, pl.NamaP;

-- 3. Laporan data pembayaran
SELECT * FROM Pembayaran;

-- 4. Laporan data pesanan
SELECT * FROM Pesanan;

-- 5. Laporan data menu
SELECT * FROM Menu;

-- 6. Laporan data bahan baku
SELECT * FROM BahanBaku;

-- 7. Laporan data periklanan
SELECT * FROM Periklanan;
