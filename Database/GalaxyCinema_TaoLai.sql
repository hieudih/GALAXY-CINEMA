USE master;
GO
IF DB_ID('GalaxyCinema') IS NOT NULL
BEGIN
    ALTER DATABASE GalaxyCinema SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GalaxyCinema;
END
GO
CREATE DATABASE GalaxyCinema;
GO
USE GalaxyCinema;
GO

CREATE TABLE tblKhachHang (
    MaKH         VARCHAR(10)   NOT NULL,
    HoTen        NVARCHAR(100) NOT NULL,
    Email        VARCHAR(100)  NOT NULL,
    SoDienThoai  VARCHAR(15)   NOT NULL,
    MatKhau      VARCHAR(255)  NOT NULL,
    NgayDangKy   DATE          NOT NULL CONSTRAINT DF_KhachHang_NgayDangKy DEFAULT (CAST(GETDATE() AS DATE)),
    CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH),
    CONSTRAINT UQ_KhachHang_Email UNIQUE (Email)
);
GO

CREATE TABLE tblPhim (
    MaPhim         VARCHAR(10)   NOT NULL,
    TenPhim        NVARCHAR(200) NOT NULL,
    TheLoaiChinh   NVARCHAR(50)  NOT NULL,
    ThoiLuong      INT           NOT NULL,
    DoTuoiChoPhep  NVARCHAR(10)  NOT NULL,
    NgayKhoiChieu  DATE          NOT NULL,
    CONSTRAINT PK_Phim PRIMARY KEY (MaPhim),
    CONSTRAINT CK_Phim_ThoiLuong CHECK (ThoiLuong > 0)
);
GO

CREATE TABLE tblPhongChieu (
    MaPhong    VARCHAR(10)  NOT NULL,
    TenPhong   NVARCHAR(50) NOT NULL,
    LoaiPhong  NVARCHAR(30) NOT NULL,
    CONSTRAINT PK_PhongChieu PRIMARY KEY (MaPhong)
);
GO

CREATE TABLE tblBangGia (
    MaGia       VARCHAR(10)   NOT NULL,
    LoaiGhe     NVARCHAR(20)  NOT NULL,
    LoaiNgay    NVARCHAR(20)  NOT NULL,
    GiaVe       DECIMAL(12,0) NOT NULL,
    NgayApDung  DATE          NOT NULL,
    CONSTRAINT PK_BangGia PRIMARY KEY (MaGia),
    CONSTRAINT UQ_BangGia UNIQUE (LoaiGhe, LoaiNgay, NgayApDung),
    CONSTRAINT CK_BangGia_GiaVe CHECK (GiaVe >= 0)
);
GO

CREATE TABLE tblKhuyenMai (
    MaKM            VARCHAR(10)   NOT NULL,
    TenKM           NVARCHAR(200) NOT NULL,
    MucGiam         DECIMAL(12,0) NOT NULL,
    NgayBatDau      DATE          NOT NULL,
    NgayKetThuc     DATE          NOT NULL,
    DieuKienApDung  NVARCHAR(255) NULL,
    CONSTRAINT PK_KhuyenMai PRIMARY KEY (MaKM),
    CONSTRAINT CK_KhuyenMai_MucGiam CHECK (MucGiam > 0),
    CONSTRAINT CK_KhuyenMai_Ngay CHECK (NgayKetThuc >= NgayBatDau)
);
GO

CREATE TABLE tblPhanHoi (
    MaPhanHoi    VARCHAR(10)    NOT NULL,
    MaKH         VARCHAR(10)    NOT NULL,
    NoiDung      NVARCHAR(1000) NOT NULL,
    ThoiDiemGui  DATETIME       NOT NULL CONSTRAINT DF_PhanHoi_ThoiDiemGui DEFAULT (GETDATE()),
    CONSTRAINT PK_PhanHoi PRIMARY KEY (MaPhanHoi),
    CONSTRAINT FK_PhanHoi_KhachHang FOREIGN KEY (MaKH) REFERENCES tblKhachHang(MaKH)
);
GO

CREATE TABLE tblGhe (
    MaGhe    VARCHAR(10)  NOT NULL,
    MaPhong  VARCHAR(10)  NOT NULL,
    HangGhe  VARCHAR(2)   NOT NULL,
    SoGhe    INT          NOT NULL,
    LoaiGhe  NVARCHAR(20) NOT NULL,
    CONSTRAINT PK_Ghe PRIMARY KEY (MaGhe),
    CONSTRAINT UQ_Ghe_ViTri UNIQUE (MaPhong, HangGhe, SoGhe),
    CONSTRAINT FK_Ghe_PhongChieu FOREIGN KEY (MaPhong) REFERENCES tblPhongChieu(MaPhong)
);
GO

CREATE TABLE tblSuatChieu (
    MaSuat      VARCHAR(10) NOT NULL,
    MaPhim      VARCHAR(10) NOT NULL,
    MaPhong     VARCHAR(10) NOT NULL,
    NgayChieu   DATE        NOT NULL,
    GioBatDau   TIME(0)     NOT NULL,
    CONSTRAINT PK_SuatChieu PRIMARY KEY (MaSuat),
    CONSTRAINT UQ_SuatChieu UNIQUE (MaPhong, NgayChieu, GioBatDau),
    CONSTRAINT FK_SuatChieu_Phim FOREIGN KEY (MaPhim) REFERENCES tblPhim(MaPhim),
    CONSTRAINT FK_SuatChieu_PhongChieu FOREIGN KEY (MaPhong) REFERENCES tblPhongChieu(MaPhong)
);
GO

CREATE TABLE tblDonDatVe (
    MaDon         VARCHAR(10)  NOT NULL,
    MaKH          VARCHAR(10)  NOT NULL,
    MaKM          VARCHAR(10)  NULL,
    NgayDat       DATETIME     NOT NULL CONSTRAINT DF_DonDatVe_NgayDat DEFAULT (GETDATE()),
    TrangThaiDon  NVARCHAR(20) NOT NULL CONSTRAINT DF_DonDatVe_TrangThai DEFAULT (N'Chờ thanh toán'),
    CONSTRAINT PK_DonDatVe PRIMARY KEY (MaDon),
    CONSTRAINT CK_DonDatVe_TrangThai CHECK (TrangThaiDon IN (N'Chờ thanh toán', N'Đã thanh toán', N'Đã hủy')),
    CONSTRAINT FK_DonDatVe_KhachHang FOREIGN KEY (MaKH) REFERENCES tblKhachHang(MaKH),
    CONSTRAINT FK_DonDatVe_KhuyenMai FOREIGN KEY (MaKM) REFERENCES tblKhuyenMai(MaKM)
);
GO

CREATE TABLE tblVe (
    MaVe          VARCHAR(10)  NOT NULL,
    MaDon         VARCHAR(10)  NOT NULL,
    MaSuat        VARCHAR(10)  NOT NULL,
    MaGhe         VARCHAR(10)  NOT NULL,
    MaGia         VARCHAR(10)  NOT NULL,
    TrangThaiVe   NVARCHAR(20) NOT NULL CONSTRAINT DF_Ve_TrangThai DEFAULT (N'Chưa soát'),
    ThoiDiemSoat  DATETIME     NULL,
    CONSTRAINT PK_Ve PRIMARY KEY (MaVe),
    CONSTRAINT CK_Ve_TrangThai CHECK (TrangThaiVe IN (N'Chưa soát', N'Đã soát', N'Đã hủy')),
    CONSTRAINT FK_Ve_DonDatVe FOREIGN KEY (MaDon) REFERENCES tblDonDatVe(MaDon),
    CONSTRAINT FK_Ve_SuatChieu FOREIGN KEY (MaSuat) REFERENCES tblSuatChieu(MaSuat),
    CONSTRAINT FK_Ve_Ghe FOREIGN KEY (MaGhe) REFERENCES tblGhe(MaGhe),
    CONSTRAINT FK_Ve_BangGia FOREIGN KEY (MaGia) REFERENCES tblBangGia(MaGia)
);
GO

CREATE UNIQUE INDEX UX_Ve_Suat_Ghe ON tblVe(MaSuat, MaGhe) WHERE TrangThaiVe <> N'Đã hủy';
GO

CREATE TABLE tblThanhToan (
    MaTT            VARCHAR(10)   NOT NULL,
    MaDon           VARCHAR(10)   NOT NULL,
    PhuongThuc      NVARCHAR(30)  NOT NULL,
    LoaiGiaoDich    NVARCHAR(20)  NOT NULL,
    SoTien          DECIMAL(12,0) NOT NULL,
    MaGiaoDichCong  VARCHAR(50)   NULL,
    TrangThai       NVARCHAR(20)  NOT NULL,
    ThoiDiem        DATETIME      NOT NULL CONSTRAINT DF_ThanhToan_ThoiDiem DEFAULT (GETDATE()),
    CONSTRAINT PK_ThanhToan PRIMARY KEY (MaTT),
    CONSTRAINT CK_ThanhToan_Loai CHECK (LoaiGiaoDich IN (N'Thanh toán', N'Hoàn tiền')),
    CONSTRAINT CK_ThanhToan_SoTien CHECK (SoTien > 0),
    CONSTRAINT CK_ThanhToan_TrangThai CHECK (TrangThai IN (N'Đang xử lý', N'Thành công', N'Thất bại')),
    CONSTRAINT FK_ThanhToan_DonDatVe FOREIGN KEY (MaDon) REFERENCES tblDonDatVe(MaDon)
);
GO

INSERT INTO tblKhachHang (MaKH, HoTen, Email, SoDienThoai, MatKhau, NgayDangKy) VALUES
('KH001', N'Nguyễn Văn An',   'an.nguyen@gmail.com',  '0912345678', '224906', '2026-09-05'),
('KH002', N'Trần Thị Bình',   'binh.tran@gmail.com',  '0987654321', '435003', '2026-09-20'),
('KH003', N'Lê Minh Châu',    'chau.le@gmail.com',    '0905123456', '626925', '2026-10-10');
GO

INSERT INTO tblPhim (MaPhim, TenPhim, TheLoaiChinh, ThoiLuong, DoTuoiChoPhep, NgayKhoiChieu) VALUES
('P001', N'Hành Trình Mùa Thu',     N'Tình cảm',   110, 'T13', '2026-10-09'),
('P002', N'Bóng Đêm Thành Phố',     N'Hành động',  125, 'T16', '2026-10-16'),
('P003', N'Chú Mèo Phiêu Lưu',      N'Hoạt hình',   95, 'P',   '2026-10-02'),
('P004', N'Ngôi Nhà Trên Đồi',      N'Kinh dị',    100, 'T18', '2026-10-30');
GO

INSERT INTO tblPhongChieu (MaPhong, TenPhong, LoaiPhong) VALUES
('PC01', N'Phòng 1', N'2D'),
('PC02', N'Phòng 2', N'3D');
GO

INSERT INTO tblGhe (MaGhe, MaPhong, HangGhe, SoGhe, LoaiGhe) VALUES
('PC01A1','PC01','A',1,N'Thường'), ('PC01A2','PC01','A',2,N'Thường'), ('PC01A3','PC01','A',3,N'Thường'),
('PC01A4','PC01','A',4,N'Thường'), ('PC01A5','PC01','A',5,N'Thường'),
('PC01B1','PC01','B',1,N'VIP'),    ('PC01B2','PC01','B',2,N'VIP'),    ('PC01B3','PC01','B',3,N'VIP'),
('PC01B4','PC01','B',4,N'VIP'),    ('PC01B5','PC01','B',5,N'VIP'),
('PC02A1','PC02','A',1,N'Thường'), ('PC02A2','PC02','A',2,N'Thường'), ('PC02A3','PC02','A',3,N'Thường'),
('PC02A4','PC02','A',4,N'Thường'), ('PC02A5','PC02','A',5,N'Thường'),
('PC02B1','PC02','B',1,N'VIP'),    ('PC02B2','PC02','B',2,N'VIP'),    ('PC02B3','PC02','B',3,N'VIP'),
('PC02B4','PC02','B',4,N'VIP'),    ('PC02B5','PC02','B',5,N'VIP');
GO

INSERT INTO tblBangGia (MaGia, LoaiGhe, LoaiNgay, GiaVe, NgayApDung) VALUES
('BG01', N'Thường', N'Ngày thường',  75000, '2026-01-01'),
('BG02', N'VIP',    N'Ngày thường',  90000, '2026-01-01'),
('BG03', N'Thường', N'Cuối tuần',    90000, '2026-01-01'),
('BG04', N'VIP',    N'Cuối tuần',   105000, '2026-01-01');
GO

INSERT INTO tblKhuyenMai (MaKM, TenKM, MucGiam, NgayBatDau, NgayKetThuc, DieuKienApDung) VALUES
('KM01', N'Ưu đãi tháng 10',       20000, '2026-10-01', '2026-10-31', N'Đơn từ 2 vé trở lên'),
('KM02', N'Thứ Ba vui vẻ',         10000, '2026-01-01', '2026-12-31', N'Suất chiếu vào thứ Ba'),
('KM03', N'Chào hè 2026',          15000, '2026-06-01', '2026-08-31', NULL);
GO

INSERT INTO tblSuatChieu (MaSuat, MaPhim, MaPhong, NgayChieu, GioBatDau) VALUES
('SC001','P001','PC01','2026-10-20','18:00'),
('SC002','P001','PC02','2026-10-20','20:30'),
('SC003','P002','PC01','2026-10-20','20:30'),
('SC004','P003','PC02','2026-10-24','19:00'),
('SC005','P002','PC01','2026-10-24','21:00'),
('SC006','P001','PC01','2026-10-17','19:00');
GO

INSERT INTO tblPhanHoi (MaPhanHoi, MaKH, NoiDung, ThoiDiemGui) VALUES
('PH001','KH001',N'Đặt vé nhanh, giao diện dễ dùng.',                 '2026-10-18T10:30:00'),
('PH002','KH002',N'Mong rạp có thêm suất chiếu sau 22 giờ.',           '2026-10-18T21:00:00'),
('PH003','KH001',N'Hủy vé và nhận lại tiền thuận tiện.',                 '2026-10-18T16:10:00');
GO

INSERT INTO tblDonDatVe (MaDon, MaKH, MaKM, NgayDat, TrangThaiDon) VALUES
('DV001','KH001','KM01','2026-10-18T10:15:00',N'Đã thanh toán'),
('DV002','KH002',NULL,  '2026-10-18T14:20:00',N'Đã thanh toán'),
('DV003','KH001',NULL,  '2026-10-18T15:00:00',N'Đã hủy'),
('DV004','KH003','KM02','2026-10-19T09:00:00',N'Đã thanh toán'),
('DV005','KH002',NULL,  '2026-10-16T20:00:00',N'Đã thanh toán'),
('DV006','KH003',NULL,  '2026-10-19T09:30:00',N'Chờ thanh toán');
GO

INSERT INTO tblVe (MaVe, MaDon, MaSuat, MaGhe, MaGia, TrangThaiVe, ThoiDiemSoat) VALUES
('V001','DV001','SC001','PC01A1','BG01',N'Chưa soát',NULL),
('V002','DV001','SC001','PC01A2','BG01',N'Chưa soát',NULL),
('V003','DV002','SC001','PC01B3','BG02',N'Chưa soát',NULL),
('V004','DV003','SC003','PC01B1','BG02',N'Đã hủy',   NULL),
('V005','DV004','SC002','PC02A1','BG01',N'Chưa soát',NULL),
('V006','DV004','SC002','PC02A2','BG01',N'Chưa soát',NULL),
('V007','DV005','SC006','PC01A3','BG03',N'Đã soát',  '2026-10-17T18:50:00'),
('V008','DV005','SC006','PC01A4','BG03',N'Đã soát',  '2026-10-17T18:51:00'),
('V009','DV006','SC004','PC02B2','BG04',N'Chưa soát',NULL);
GO

INSERT INTO tblThanhToan (MaTT, MaDon, PhuongThuc, LoaiGiaoDich, SoTien, MaGiaoDichCong, TrangThai, ThoiDiem) VALUES
('TT001','DV001',N'Ví điện tử',    N'Thanh toán', 130000,'GD20261018001',N'Thành công','2026-10-18T10:17:00'),
('TT002','DV002',N'Thẻ ngân hàng', N'Thanh toán',  90000,'GD20261018002',N'Thành công','2026-10-18T14:22:00'),
('TT003','DV003',N'Ví điện tử',    N'Thanh toán',  90000,'GD20261018003',N'Thành công','2026-10-18T15:02:00'),
('TT004','DV003',N'Ví điện tử',    N'Hoàn tiền',   90000,'GD20261018004',N'Thành công','2026-10-18T16:05:00'),
('TT005','DV004',N'Thẻ ngân hàng', N'Thanh toán', 140000,'GD20261019001',N'Thành công','2026-10-19T09:02:00'),
('TT006','DV005',N'Ví điện tử',    N'Thanh toán', 180000,'GD20261016001',N'Thành công','2026-10-16T20:03:00'),
('TT007','DV006',N'Ví điện tử',    N'Thanh toán', 105000,NULL,           N'Đang xử lý','2026-10-19T09:31:00');
GO

INSERT INTO tblKhachHang (MaKH, HoTen, Email, SoDienThoai, MatKhau, NgayDangKy) VALUES
('KH004', N'Phạm Quốc Dũng', 'dung.pham@gmail.com', '0998259791', '636685', '2026-07-31'),
('KH005', N'Hoàng Thu Hà', 'ha.hoang@gmail.com', '0907483378', '778636', '2026-09-16'),
('KH006', N'Vũ Đức Huy', 'huy.vu@gmail.com', '0976232860', '207622', '2026-09-09'),
('KH007', N'Đặng Thị Lan', 'lan.dang@gmail.com', '0912904047', '334130', '2026-09-24'),
('KH008', N'Bùi Văn Khánh', 'khanh.bui@gmail.com', '0966697251', '730226', '2026-09-15'),
('KH009', N'Đỗ Ngọc Mai', 'mai.do@gmail.com', '0927346468', '751673', '2026-07-05'),
('KH010', N'Ngô Thanh Nam', 'nam.ngo@gmail.com', '0995896935', '683594', '2026-08-19'),
('KH011', N'Dương Thị Oanh', 'oanh.duong@gmail.com', '0904925899', '541046', '2026-09-26'),
('KH012', N'Lý Hoàng Phúc', 'phuc.ly@gmail.com', '0939441177', '921426', '2026-07-14'),
('KH013', N'Trịnh Minh Quân', 'quan.trinh@gmail.com', '0951620466', '700381', '2026-07-12'),
('KH014', N'Phan Thị Hồng', 'hong.phan@gmail.com', '0909906958', '674421', '2026-07-16'),
('KH015', N'Mai Anh Tuấn', 'tuan.mai@gmail.com', '0983040119', '983322', '2026-08-05');
GO

INSERT INTO tblPhim (MaPhim, TenPhim, TheLoaiChinh, ThoiLuong, DoTuoiChoPhep, NgayKhoiChieu) VALUES
('P005', N'Đường Đua Tốc Độ', N'Hành động', 118, 'T13', '2026-10-02'),
('P006', N'Bí Mật Căn Phòng Số 7', N'Kinh dị', 102, 'T18', '2026-10-09'),
('P007', N'Gia Đình Là Số Một', N'Hài', 105, 'K', '2026-09-25'),
('P008', N'Vũ Trụ Song Song', N'Khoa học viễn tưởng', 135, 'T13', '2026-10-16'),
('P009', N'Mùa Hè Của Nội', N'Gia đình', 98, 'P', '2026-10-23'),
('P010', N'Thám Tử Ngõ Hẻm', N'Trinh thám', 112, 'T16', '2026-10-23'),
('P011', N'Rồng Xanh Huyền Thoại', N'Hoạt hình', 92, 'P', '2026-11-06'),
('P012', N'Kẻ Săn Bóng Tối', N'Hành động', 128, 'T16', '2026-11-13');
GO

INSERT INTO tblPhongChieu (MaPhong, TenPhong, LoaiPhong) VALUES
('PC03', N'Phòng 3', '2D'),
('PC04', N'Phòng 4', 'IMAX');
GO

INSERT INTO tblGhe (MaGhe, MaPhong, HangGhe, SoGhe, LoaiGhe) VALUES
('PC03A1', 'PC03', 'A', 1, N'Thường'),
('PC03A2', 'PC03', 'A', 2, N'Thường'),
('PC03A3', 'PC03', 'A', 3, N'Thường'),
('PC03A4', 'PC03', 'A', 4, N'Thường'),
('PC03A5', 'PC03', 'A', 5, N'Thường'),
('PC03A6', 'PC03', 'A', 6, N'Thường'),
('PC03B1', 'PC03', 'B', 1, N'Thường'),
('PC03B2', 'PC03', 'B', 2, N'Thường'),
('PC03B3', 'PC03', 'B', 3, N'Thường'),
('PC03B4', 'PC03', 'B', 4, N'Thường'),
('PC03B5', 'PC03', 'B', 5, N'Thường'),
('PC03B6', 'PC03', 'B', 6, N'Thường'),
('PC03C1', 'PC03', 'C', 1, 'VIP'),
('PC03C2', 'PC03', 'C', 2, 'VIP'),
('PC03C3', 'PC03', 'C', 3, 'VIP'),
('PC03C4', 'PC03', 'C', 4, 'VIP'),
('PC03C5', 'PC03', 'C', 5, 'VIP'),
('PC03C6', 'PC03', 'C', 6, 'VIP'),
('PC04A1', 'PC04', 'A', 1, N'Thường'),
('PC04A2', 'PC04', 'A', 2, N'Thường'),
('PC04A3', 'PC04', 'A', 3, N'Thường'),
('PC04A4', 'PC04', 'A', 4, N'Thường'),
('PC04A5', 'PC04', 'A', 5, N'Thường'),
('PC04A6', 'PC04', 'A', 6, N'Thường'),
('PC04B1', 'PC04', 'B', 1, N'Thường'),
('PC04B2', 'PC04', 'B', 2, N'Thường'),
('PC04B3', 'PC04', 'B', 3, N'Thường'),
('PC04B4', 'PC04', 'B', 4, N'Thường'),
('PC04B5', 'PC04', 'B', 5, N'Thường'),
('PC04B6', 'PC04', 'B', 6, N'Thường'),
('PC04C1', 'PC04', 'C', 1, 'VIP'),
('PC04C2', 'PC04', 'C', 2, 'VIP'),
('PC04C3', 'PC04', 'C', 3, 'VIP'),
('PC04C4', 'PC04', 'C', 4, 'VIP'),
('PC04C5', 'PC04', 'C', 5, 'VIP'),
('PC04C6', 'PC04', 'C', 6, 'VIP');
GO

INSERT INTO tblBangGia (MaGia, LoaiGhe, LoaiNgay, GiaVe, NgayApDung) VALUES
('BG05', N'Thường', N'Ngày thường', 80000, '2027-01-01'),
('BG06', 'VIP', N'Ngày thường', 95000, '2027-01-01'),
('BG07', N'Thường', N'Cuối tuần', 95000, '2027-01-01'),
('BG08', 'VIP', N'Cuối tuần', 110000, '2027-01-01');
GO

INSERT INTO tblKhuyenMai (MaKM, TenKM, MucGiam, NgayBatDau, NgayKetThuc, DieuKienApDung) VALUES
('KM04', N'Ưu đãi học sinh, sinh viên', 15000, '2026-09-01', '2026-12-31', N'Xuất trình thẻ học sinh, sinh viên'),
('KM05', N'Cuối tuần sôi động', 25000, '2026-10-10', '2026-10-25', N'Đơn từ 3 vé, suất chiếu thứ Bảy hoặc Chủ nhật'),
('KM06', N'Chào tháng 11', 20000, '2026-11-01', '2026-11-30', NULL);
GO

INSERT INTO tblSuatChieu (MaSuat, MaPhim, MaPhong, NgayChieu, GioBatDau) VALUES
('SC008', 'P006', 'PC02', '2026-10-15', '13:00'),
('SC009', 'P007', 'PC03', '2026-10-15', '16:30'),
('SC010', 'P003', 'PC04', '2026-10-15', '16:30'),
('SC007', 'P001', 'PC01', '2026-10-15', '22:00'),
('SC011', 'P008', 'PC01', '2026-10-16', '09:30'),
('SC012', 'P003', 'PC02', '2026-10-16', '16:30'),
('SC013', 'P002', 'PC03', '2026-10-16', '16:30'),
('SC014', 'P005', 'PC04', '2026-10-16', '19:30'),
('SC015', 'P005', 'PC02', '2026-10-17', '22:00'),
('SC016', 'P007', 'PC03', '2026-10-17', '22:00'),
('SC017', 'P001', 'PC04', '2026-10-17', '22:00'),
('SC021', 'P003', 'PC04', '2026-10-18', '13:00'),
('SC020', 'P007', 'PC03', '2026-10-18', '19:30'),
('SC018', 'P008', 'PC01', '2026-10-18', '22:00'),
('SC019', 'P003', 'PC02', '2026-10-18', '22:00'),
('SC025', 'P008', 'PC04', '2026-10-19', '09:30'),
('SC022', 'P003', 'PC01', '2026-10-19', '19:30'),
('SC023', 'P003', 'PC02', '2026-10-19', '22:00'),
('SC024', 'P003', 'PC03', '2026-10-19', '22:00'),
('SC026', 'P001', 'PC02', '2026-10-20', '16:30'),
('SC027', 'P006', 'PC03', '2026-10-20', '19:30'),
('SC028', 'P007', 'PC04', '2026-10-20', '22:00'),
('SC029', 'P001', 'PC01', '2026-10-21', '13:00'),
('SC030', 'P005', 'PC02', '2026-10-21', '16:30'),
('SC031', 'P007', 'PC03', '2026-10-21', '16:30'),
('SC032', 'P006', 'PC04', '2026-10-21', '16:30'),
('SC036', 'P003', 'PC04', '2026-10-22', '09:30'),
('SC033', 'P007', 'PC01', '2026-10-22', '16:30'),
('SC034', 'P001', 'PC02', '2026-10-22', '19:30'),
('SC035', 'P001', 'PC03', '2026-10-22', '22:00'),
('SC039', 'P007', 'PC03', '2026-10-23', '13:00'),
('SC040', 'P007', 'PC04', '2026-10-23', '13:00'),
('SC037', 'P009', 'PC01', '2026-10-23', '16:30'),
('SC038', 'P007', 'PC02', '2026-10-23', '16:30'),
('SC042', 'P001', 'PC03', '2026-10-24', '09:30'),
('SC041', 'P006', 'PC01', '2026-10-24', '16:30'),
('SC043', 'P003', 'PC04', '2026-10-24', '22:00');
GO

INSERT INTO tblDonDatVe (MaDon, MaKH, MaKM, NgayDat, TrangThaiDon) VALUES
('DV007', 'KH009', 'KM04', '2026-10-11T19:23:00', N'Đã thanh toán'),
('DV008', 'KH013', NULL, '2026-10-15T13:18:00', N'Đã thanh toán'),
('DV009', 'KH013', NULL, '2026-10-15T10:40:00', N'Đã thanh toán'),
('DV010', 'KH006', 'KM04', '2026-10-14T12:35:00', N'Đã thanh toán'),
('DV011', 'KH008', NULL, '2026-10-16T10:44:00', N'Đã thanh toán'),
('DV012', 'KH015', NULL, '2026-10-12T22:35:00', N'Đã thanh toán'),
('DV013', 'KH002', NULL, '2026-10-14T20:36:00', N'Đã thanh toán'),
('DV014', 'KH015', NULL, '2026-10-18T03:03:00', N'Đã thanh toán'),
('DV015', 'KH006', NULL, '2026-10-18T08:01:00', N'Đã hủy'),
('DV016', 'KH002', 'KM04', '2026-10-17T07:52:00', N'Đã thanh toán'),
('DV017', 'KH005', 'KM01', '2026-10-15T21:35:00', N'Đã thanh toán'),
('DV018', 'KH003', 'KM01', '2026-10-15T03:51:00', N'Đã thanh toán'),
('DV019', 'KH011', NULL, '2026-10-17T17:44:00', N'Đã thanh toán'),
('DV020', 'KH010', NULL, '2026-10-16T02:16:00', N'Đã thanh toán'),
('DV021', 'KH002', NULL, '2026-10-18T10:52:00', N'Đã thanh toán'),
('DV022', 'KH009', 'KM04', '2026-10-16T12:04:00', N'Đã hủy'),
('DV023', 'KH015', NULL, '2026-10-17T14:39:00', N'Đã thanh toán'),
('DV024', 'KH014', NULL, '2026-10-18T16:02:00', N'Đã hủy'),
('DV025', 'KH004', 'KM04', '2026-10-16T23:47:00', N'Đã thanh toán');
GO

INSERT INTO tblVe (MaVe, MaDon, MaSuat, MaGhe, MaGia, TrangThaiVe, ThoiDiemSoat) VALUES
('V010', 'DV007', 'SC008', 'PC02A4', 'BG01', N'Đã soát', '2026-10-15T12:47:00'),
('V011', 'DV007', 'SC008', 'PC02B1', 'BG02', N'Đã soát', '2026-10-15T12:50:00'),
('V012', 'DV008', 'SC009', 'PC03A3', 'BG01', N'Đã soát', '2026-10-15T16:24:00'),
('V013', 'DV008', 'SC009', 'PC03B5', 'BG01', N'Đã soát', '2026-10-15T16:21:00'),
('V014', 'DV009', 'SC010', 'PC04B3', 'BG01', N'Đã soát', '2026-10-15T16:14:00'),
('V015', 'DV009', 'SC010', 'PC04B5', 'BG01', N'Đã soát', '2026-10-15T16:19:00'),
('V016', 'DV010', 'SC007', 'PC01A5', 'BG01', N'Chưa soát', NULL),
('V017', 'DV010', 'SC007', 'PC01B2', 'BG02', N'Đã soát', '2026-10-15T21:41:00'),
('V018', 'DV010', 'SC007', 'PC01B4', 'BG02', N'Đã soát', '2026-10-15T21:35:00'),
('V019', 'DV011', 'SC013', 'PC03C6', 'BG02', N'Đã soát', '2026-10-16T16:20:00'),
('V020', 'DV011', 'SC013', 'PC03B5', 'BG01', N'Đã soát', '2026-10-16T16:05:00'),
('V021', 'DV012', 'SC014', 'PC04A2', 'BG01', N'Đã soát', '2026-10-16T19:11:00'),
('V022', 'DV012', 'SC014', 'PC04A1', 'BG01', N'Đã soát', '2026-10-16T19:26:00'),
('V023', 'DV012', 'SC014', 'PC04C4', 'BG02', N'Chưa soát', NULL),
('V024', 'DV013', 'SC015', 'PC02A5', 'BG03', N'Đã soát', '2026-10-17T21:40:00'),
('V025', 'DV013', 'SC015', 'PC02B4', 'BG04', N'Đã soát', '2026-10-17T21:54:00'),
('V026', 'DV014', 'SC021', 'PC04A1', 'BG03', N'Đã soát', '2026-10-18T12:38:00'),
('V027', 'DV014', 'SC021', 'PC04C4', 'BG04', N'Đã soát', '2026-10-18T12:44:00'),
('V028', 'DV015', 'SC018', 'PC01A1', 'BG03', N'Đã hủy', NULL),
('V029', 'DV016', 'SC025', 'PC04B5', 'BG01', N'Chưa soát', NULL),
('V030', 'DV016', 'SC025', 'PC04A6', 'BG01', N'Chưa soát', NULL),
('V031', 'DV016', 'SC025', 'PC04C6', 'BG02', N'Chưa soát', NULL),
('V032', 'DV017', 'SC022', 'PC01B2', 'BG02', N'Chưa soát', NULL),
('V033', 'DV017', 'SC022', 'PC01A2', 'BG01', N'Chưa soát', NULL),
('V034', 'DV018', 'SC023', 'PC02B3', 'BG02', N'Chưa soát', NULL),
('V035', 'DV018', 'SC023', 'PC02B4', 'BG02', N'Chưa soát', NULL),
('V036', 'DV019', 'SC024', 'PC03C2', 'BG02', N'Chưa soát', NULL),
('V037', 'DV019', 'SC024', 'PC03C6', 'BG02', N'Chưa soát', NULL),
('V038', 'DV020', 'SC026', 'PC02A4', 'BG01', N'Chưa soát', NULL),
('V039', 'DV020', 'SC026', 'PC02B2', 'BG02', N'Chưa soát', NULL),
('V040', 'DV020', 'SC026', 'PC02A3', 'BG01', N'Chưa soát', NULL),
('V041', 'DV021', 'SC027', 'PC03C5', 'BG02', N'Chưa soát', NULL),
('V042', 'DV022', 'SC028', 'PC04C4', 'BG02', N'Đã hủy', NULL),
('V043', 'DV023', 'SC029', 'PC01A1', 'BG01', N'Chưa soát', NULL),
('V044', 'DV023', 'SC029', 'PC01B1', 'BG02', N'Chưa soát', NULL),
('V045', 'DV024', 'SC030', 'PC02B5', 'BG02', N'Đã hủy', NULL),
('V046', 'DV024', 'SC030', 'PC02A5', 'BG01', N'Đã hủy', NULL),
('V047', 'DV025', 'SC031', 'PC03C6', 'BG02', N'Chưa soát', NULL);
GO

INSERT INTO tblThanhToan (MaTT, MaDon, PhuongThuc, LoaiGiaoDich, SoTien, MaGiaoDichCong, TrangThai, ThoiDiem) VALUES
('TT010', 'DV007', N'Ví điện tử', N'Thanh toán', 150000, 'GD20261011010', N'Thành công', '2026-10-11T19:24:00'),
('TT011', 'DV012', N'Ví điện tử', N'Thanh toán', 240000, 'GD20261012011', N'Thành công', '2026-10-12T22:37:00'),
('TT012', 'DV010', N'Ví điện tử', N'Thanh toán', 240000, 'GD20261014012', N'Thành công', '2026-10-14T12:39:00'),
('TT013', 'DV013', N'Ví điện tử', N'Thanh toán', 195000, 'GD20261014013', N'Thành công', '2026-10-14T20:38:00'),
('TT014', 'DV018', N'Ví điện tử', N'Thanh toán', 160000, 'GD20261015014', N'Thành công', '2026-10-15T03:52:00'),
('TT015', 'DV009', N'Thẻ ngân hàng', N'Thanh toán', 150000, 'GD20261015015', N'Thành công', '2026-10-15T10:43:00'),
('TT016', 'DV008', N'Thẻ ngân hàng', N'Thanh toán', 150000, 'GD20261015016', N'Thành công', '2026-10-15T13:22:00'),
('TT017', 'DV017', N'Ví điện tử', N'Thanh toán', 145000, 'GD20261015017', N'Thành công', '2026-10-15T21:36:00'),
('TT018', 'DV020', N'Ví điện tử', N'Thanh toán', 240000, 'GD20261016018', N'Thành công', '2026-10-16T02:21:00'),
('TT019', 'DV011', N'Thẻ ngân hàng', N'Thanh toán', 165000, 'GD20261016019', N'Thành công', '2026-10-16T10:47:00'),
('TT020', 'DV022', N'Ví điện tử', N'Thanh toán', 75000, 'GD20261016020', N'Thành công', '2026-10-16T12:09:00'),
('TT021', 'DV022', N'Ví điện tử', N'Hoàn tiền', 75000, 'GD20261016021', N'Thành công', '2026-10-16T19:05:00'),
('TT022', 'DV025', N'Ví điện tử', N'Thanh toán', 75000, 'GD20261016022', N'Thành công', '2026-10-16T23:48:00'),
('TT023', 'DV016', N'Thẻ ngân hàng', N'Thanh toán', 225000, NULL, N'Thất bại', '2026-10-17T07:52:00'),
('TT024', 'DV016', N'Thẻ ngân hàng', N'Thanh toán', 225000, 'GD20261017024', N'Thành công', '2026-10-17T07:55:00'),
('TT025', 'DV023', N'Ví điện tử', N'Thanh toán', 165000, 'GD20261017025', N'Thành công', '2026-10-17T14:45:00'),
('TT026', 'DV019', N'Thẻ ngân hàng', N'Thanh toán', 180000, NULL, N'Thất bại', '2026-10-17T17:44:00'),
('TT027', 'DV019', N'Thẻ ngân hàng', N'Thanh toán', 180000, 'GD20261017027', N'Thành công', '2026-10-17T17:47:00'),
('TT028', 'DV014', N'Ví điện tử', N'Thanh toán', 195000, 'GD20261018028', N'Thành công', '2026-10-18T03:06:00'),
('TT029', 'DV015', N'Ví điện tử', N'Thanh toán', 90000, 'GD20261018029', N'Thành công', '2026-10-18T08:02:00'),
('TT030', 'DV021', N'Thẻ ngân hàng', N'Thanh toán', 90000, 'GD20261018030', N'Thành công', '2026-10-18T10:55:00'),
('TT031', 'DV024', N'Thẻ ngân hàng', N'Thanh toán', 165000, 'GD20261018031', N'Thành công', '2026-10-18T16:07:00'),
('TT032', 'DV015', N'Ví điện tử', N'Hoàn tiền', 90000, 'GD20261018032', N'Thành công', '2026-10-18T16:26:00'),
('TT033', 'DV024', N'Thẻ ngân hàng', N'Hoàn tiền', 165000, 'GD20261019033', N'Thành công', '2026-10-19T01:18:00');
GO

INSERT INTO tblPhanHoi (MaPhanHoi, MaKH, NoiDung, ThoiDiemGui) VALUES
('PH004', 'KH008', N'Rạp sạch sẽ, âm thanh tốt.', '2026-10-03T06:28:00'),
('PH005', 'KH004', N'Thông báo nhắc giờ chiếu rất hữu ích.', '2026-10-03T13:21:00'),
('PH006', 'KH008', N'Muốn chọn ghế đôi cho các cặp đôi.', '2026-10-04T18:33:00'),
('PH007', 'KH015', N'Mong có thêm suất chiếu buổi sáng cuối tuần.', '2026-10-05T00:43:00'),
('PH008', 'KH005', N'Ứng dụng đặt vé đôi khi tải chậm vào buổi tối.', '2026-10-10T18:27:00'),
('PH009', 'KH009', N'Điều hòa phòng 2 hơi lạnh.', '2026-10-12T09:03:00'),
('PH010', 'KH012', N'Phòng IMAX hình ảnh rất đẹp.', '2026-10-12T09:10:00'),
('PH011', 'KH008', N'Ghế VIP ngồi rất thoải mái.', '2026-10-12T18:14:00'),
('PH012', 'KH012', N'Nên có thêm khuyến mãi cho sinh viên vào ngày thường.', '2026-10-13T03:24:00'),
('PH013', 'KH011', N'Giá vé cuối tuần hơi cao.', '2026-10-14T13:39:00'),
('PH014', 'KH004', N'Thanh toán bị lỗi lần đầu, lần sau mới thành công.', '2026-10-16T00:08:00'),
('PH015', 'KH008', N'Nhân viên soát vé nhanh, thân thiện.', '2026-10-17T02:17:00');
GO
