-- Dummy Data – Brand NyamHap Database

-- 1. Staff
INSERT INTO Staff (StaffID, NamaS, NoHandphoneS, Email, PasswordHash, RoleKode) VALUES
('S001', 'Budi Santoso', '081234567801', 'budi@staff.com', '123', 'Founder'),
('S002', 'Siti Aminah', '081234567802', 'siti@staff.com', '123', 'SPem'),
('S003', 'Rudi Hartono', '081234567803', 'rudi@staff.com', '123', 'SMar'),
('S004', 'Andi Saputra', '081234567804', 'andi@staff.com', '123', 'SKeu'),
('S005', 'Nina Kartika', '081234567805', 'nina@staff.com', '123', 'SProd'),
('S006', 'Agus Pratama', '081234567806', 'agus@staff.com', '123', 'SPen');

-- 2. Pelanggan
INSERT INTO Pelanggan VALUES
('P001', 'Rafi', '081234888001'),
('P002', 'Keira', '081234888002'),
('P003', 'Arif', '081234888003'),
('P004', 'Putri', '081234888004'),
('P005', 'Amar', '081234888005');

-- 3. Menu
INSERT INTO Menu VALUES
('M001', 'Nasi Kepal Ayam Suwir', 5000, 'Nasi kepal isi ayam suwir pedas manis'),
('M002', 'Nasi Kepal Ayam Balado', 5000, 'Nasi kepal isi tempe orek gurih'),
('M003', 'Nasi Kepal Ayam Geprek', 7000, 'Nasi kepal isi ayam geprek level'),
('M004', 'Nasi Kepal Ayam Ramah Lingkungan', 7000, 'Nasi kepal isi ayam karage crispy'),
('M005', 'Sandwich Telur Ceplok', 7000, 'Roti lapis telur ceplok'),
('M006', 'Nasi Burger Katsu', 7000, 'Nasi burger isi ayam katsu'),
('M007', 'Nasi Kepal Mie Goreng', 5000, 'Nasi kepal isi mie goreng pedas manis');

-- 4. Bahan Baku
INSERT INTO BahanBaku (BahanID, NamaBahan, Satuan, Stok, HargaPerUnit) VALUES
('B001','Nasi','Kg',50,9000),
('B002','Ayam Suwir','Kg',25,35000),
('B003','Bumbu Balado','Pack',40,5000),
('B004','Ayam Geprek','Kg',20,35000),
('B005','Ayam Organik','Kg',20,45000),
('B006','Telur','Butir',200,2300),
('B007','Katsu Ayam','Pack',60,6000),
('B008','Mie Goreng','Pack',150,2000),
('B009','Bumbu Dasar','Pack',80,1500),
('B010','Roti Sandwich','Pack',50,4000),
('B011','Nori / Pembungkus Nasi','Pack',100,400);

-- 5. Staff Subclass
INSERT INTO StaffKeuangan VALUES ('S004','Penjualan','2025-02-04');
INSERT INTO StaffPenjualan VALUES ('S006',90,75,'Tangerang');
INSERT INTO StaffProduksi VALUES ('S005',320);
INSERT INTO StaffPemasok VALUES ('S002','Ayam Suwir / Ayam Segar','2025-01-07','Cash');
INSERT INTO StaffMarketing VALUES ('S003','Stand Event',1800000);

-- 6. Pesanan
INSERT INTO Pesanan VALUES
('O001','P001','2025-02-01',12000), -- M001 (5000) + M005 (7000)
('O002','P002','2025-02-02',12000), -- M002 (5000) + M003 (7000)
('O003','P003','2025-02-03',12000), -- M006 (7000) + M001 (5000)
('O004','P004','2025-02-04',7000),  -- M005 (7000)
('O005','P005','2025-02-05',5000);  -- M007 (5000)

-- 7. DetailPesanan
INSERT INTO DetailPesanan VALUES
('O001','M001','Ayam Suwir',1),
('O001','M005','Sandwich Telur',1),
('O002','M002','Ayam Balado',1),
('O002','M003','Ayam Geprek',1),
('O003','M006','Burger Katsu',1),
('O003','M001','Ayam Suwir',1),
('O004','M005','Sandwich Telur',1),
('O005','M007','Mie Goreng',1);

-- 8. Pembayaran
INSERT INTO Pembayaran VALUES
('BYR01','O001','2025-02-01','QRIS','Lunas'),
('BYR02','O002','2025-02-02','Transfer','Lunas'),
('BYR03','O003','2025-02-03','Cash','Lunas'),
('BYR04','O004','2025-02-04','E-Wallet','Pending'),
('BYR05','O005','2025-02-05','Cash','Lunas');

-- 9. Resep
INSERT INTO Resep VALUES
-- M001
('M001','B001',0.06),('M001','B002',0.025),('M001','B009',0.02),('M001','B011',1),
-- M002
('M002','B001',0.06),('M002','B002',0.025),('M002','B003',0.01),('M002','B011',1),
-- M003
('M003','B001',0.07),('M003','B004',0.03),('M003','B009',0.02),('M003','B011',1),
-- M004
('M004','B001',0.07),('M004','B005',0.025),('M004','B009',0.02),('M004','B011',1),
-- M005
('M005','B010',2),('M005','B006',1),('M005','B009',0.02),
-- M006
('M006','B001',0.06),('M006','B007',0.50),('M006','B009',0.02),('M006','B011',1),
-- M007
('M007','B001',0.05),('M007','B008',0.50),('M007','B009',0.02),('M007','B011',1);

-- 10. Periklanan
INSERT INTO Periklanan VALUES
('AD001','S001','Group WA Kelas','2025-01-05','2025-01-10',50000),
('AD002','S002','Instagram','2025-01-07','2025-01-31',75000),
('AD003','S003','Instagram Staff','2025-01-10','2025-01-25',90000),
('AD004','S004','Brosur','2025-01-12','2025-02-12',60000),
('AD005','S005','Group WA Fakultas','2025-01-15','2025-02-15',45000);
