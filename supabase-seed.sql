-- ============================================================
--  PHUC TEA - SEED DATA
--  Chay file nay SAU KHI da chay supabase-schema.sql
-- ============================================================

-- 1. Store mau: Vinh Cuu
INSERT INTO stores (store_code, store_name, address, city, partner_name, status)
VALUES ('VINHCUU', 'Phúc Tea Vĩnh Cửu', 'Vĩnh Cửu - Đồng Nai', 'Đồng Nai', '', 'Chuan bi')
ON CONFLICT (store_code) DO NOTHING;

-- 2. PROJECT TEMPLATE (57 tasks, 7 phases)
INSERT INTO project_template (task_no, phase, category, task_name, description, owner, duration_days, sort_order) VALUES
-- PHASE 1: PHAP LY & HOP DONG
(1, 'Phase 1', 'Pháp lý & Hợp đồng', 'Ký hợp đồng nhượng quyền', 'Ký kết HĐ NQ với HT, nhận bộ tài liệu brand', 'CEO + ĐT', 3, 1),
(2, 'Phase 1', 'Pháp lý & Hợp đồng', 'Đăng ký giấy phép kinh doanh', 'Hộ kinh doanh cá thể hoặc DNTN', 'ĐT', 7, 2),
(3, 'Phase 1', 'Pháp lý & Hợp đồng', 'Đăng ký VSATTP', 'Giấy chứng nhận vệ sinh an toàn thực phẩm', 'ĐT', 14, 3),
(4, 'Phase 1', 'Pháp lý & Hợp đồng', 'Đăng ký PCCC', 'Phương án PCCC cho mặt bằng', 'ĐT', 7, 4),
(5, 'Phase 1', 'Pháp lý & Hợp đồng', 'Đăng ký thuế / MST', 'Mã số thuế hộ kinh doanh', 'ĐT', 5, 5),
(6, 'Phase 1', 'Pháp lý & Hợp đồng', 'Mở tài khoản ngân hàng DN', 'TK ngân hàng cho hoạt động kinh doanh', 'ĐT', 3, 6),
(7, 'Phase 1', 'Pháp lý & Hợp đồng', 'Đăng ký BHXH cho NV', 'Bảo hiểm xã hội cho nhân viên', 'ĐT', 5, 7),
(8, 'Phase 1', 'Pháp lý & Hợp đồng', 'Hoàn tất hồ sơ pháp lý', 'Tổng hợp & nộp đầy đủ hồ sơ', 'ĐT', 2, 8),
-- PHASE 2: MAT BANG & THI CONG
(9, 'Phase 2', 'Mặt bằng & Thi công', 'Khảo sát & chốt mặt bằng', 'Khảo sát vị trí, traffic, đối thủ, giá thuê', 'CEO + ĐT', 7, 9),
(10, 'Phase 2', 'Mặt bằng & Thi công', 'Ký hợp đồng thuê mặt bằng', 'Đàm phán giá, ký HĐ thuê dài hạn', 'ĐT', 3, 10),
(11, 'Phase 2', 'Mặt bằng & Thi công', 'Thiết kế layout cửa hàng', 'Bản vẽ 2D/3D theo tiêu chuẩn HT', 'HT', 5, 11),
(12, 'Phase 2', 'Mặt bằng & Thi công', 'Duyệt bản vẽ thi công', 'CEO duyệt layout + ĐT confirm', 'CEO', 2, 12),
(13, 'Phase 2', 'Mặt bằng & Thi công', 'Thi công nội thất', 'Thi công theo bản vẽ đã duyệt', 'ĐT + NTC', 21, 13),
(14, 'Phase 2', 'Mặt bằng & Thi công', 'Lắp đặt hệ thống điện nước', 'Điện 3 pha, nước sạch, thoát nước', 'NTC', 7, 14),
(15, 'Phase 2', 'Mặt bằng & Thi công', 'Lắp đặt bảng hiệu', 'Bảng hiệu ngoài trời + trong quán', 'HT + ĐT', 5, 15),
(16, 'Phase 2', 'Mặt bằng & Thi công', 'Lắp đặt camera an ninh', 'Camera IP, đầu ghi, xem từ xa', 'ĐT', 2, 16),
(17, 'Phase 2', 'Mặt bằng & Thi công', 'Lắp đặt hệ thống âm thanh', 'Loa, playlist nhạc chuẩn HT', 'ĐT', 1, 17),
(18, 'Phase 2', 'Mặt bằng & Thi công', 'Nghiệm thu mặt bằng', 'Kiểm tra tổng thể, fix lỗi', 'CEO + HT', 2, 18),
-- PHASE 3: THIET BI & NGUYEN LIEU
(19, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Đặt mua máy pha chế', 'Máy pha espresso theo spec HT', 'ĐT', 14, 19),
(20, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Đặt mua tủ lạnh/tủ đông', 'Tủ mát, tủ đông theo size quán', 'ĐT', 7, 20),
(21, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Đặt mua blender/máy xay', 'Blender công nghiệp, máy xay đá', 'ĐT', 5, 21),
(22, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Mua dụng cụ pha chế', 'Shaker, jigger, muỗng, bình đựng', 'ĐT', 3, 22),
(23, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Mua ly/cốc/ống hút', 'Ly nhựa, nắp, ống hút theo size', 'ĐT', 3, 23),
(24, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Đặt nguyên liệu lô đầu', 'NL pha chế lô 1 từ HT', 'ĐT', 5, 24),
(25, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Setup menu trên POS', 'Nhập menu, giá, topping vào IPOS', 'HT + ĐT', 2, 25),
(26, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Kiểm kê thiết bị', 'Đối chiếu list thiết bị đã mua', 'ĐT', 1, 26),
(27, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Test vận hành thiết bị', 'Chạy thử tất cả thiết bị', 'ĐT + HT', 1, 27),
(28, 'Phase 3', 'Thiết bị & Nguyên liệu', 'Setup kho & inventory', 'Sắp xếp kho, hệ thống kiểm kê', 'ĐT', 2, 28),
-- PHASE 4: NHAN SU
(29, 'Phase 4', 'Nhân sự', 'Đăng tin tuyển dụng', 'Đăng tuyển NV pha chế, phục vụ', 'ĐT', 7, 29),
(30, 'Phase 4', 'Nhân sự', 'Phỏng vấn & chọn NV', 'Phỏng vấn, chọn 2-4 NV', 'ĐT', 5, 30),
(31, 'Phase 4', 'Nhân sự', 'Ký hợp đồng lao động', 'HĐLĐ thử việc/chính thức', 'ĐT', 2, 31),
(32, 'Phase 4', 'Nhân sự', 'Training pha chế (5 ngày)', 'Đào tạo pha chế theo recipe HT', 'HT', 5, 32),
(33, 'Phase 4', 'Nhân sự', 'Training vệ sinh ATTP', 'Đào tạo quy trình vệ sinh', 'HT', 1, 33),
(34, 'Phase 4', 'Nhân sự', 'Training phục vụ KH', 'Kỹ năng phục vụ, xử lý tình huống', 'HT', 1, 34),
(35, 'Phase 4', 'Nhân sự', 'Training POS/thanh toán', 'Sử dụng IPOS, thanh toán, in bill', 'HT', 1, 35),
(36, 'Phase 4', 'Nhân sự', 'Thi kiểm tra NV', 'Test kiến thức + thực hành', 'HT', 1, 36),
-- PHASE 5: VAN HANH & SOP
(37, 'Phase 5', 'Vận hành & SOP', 'Setup SOP mở/đóng cửa', 'Checklist mở cửa sáng, đóng cửa tối', 'HT', 2, 37),
(38, 'Phase 5', 'Vận hành & SOP', 'Setup SOP pha chế', 'Quy trình pha chế chuẩn từng món', 'HT', 2, 38),
(39, 'Phase 5', 'Vận hành & SOP', 'Setup SOP vệ sinh', 'Lịch vệ sinh, checklist VS hàng ngày', 'HT', 1, 39),
(40, 'Phase 5', 'Vận hành & SOP', 'Setup SOP inventory', 'Quy trình nhập/xuất kho, kiểm kê', 'HT', 1, 40),
(41, 'Phase 5', 'Vận hành & SOP', 'Setup SOP xử lý khiếu nại', 'Quy trình xử lý complaint KH', 'HT', 1, 41),
(42, 'Phase 5', 'Vận hành & SOP', 'Setup SOP delivery', 'Quy trình nhận/giao đơn delivery', 'HT', 1, 42),
(43, 'Phase 5', 'Vận hành & SOP', 'In tài liệu SOP tại quán', 'In & dán SOP tại khu pha chế, kho', 'ĐT', 1, 43),
(44, 'Phase 5', 'Vận hành & SOP', 'Brief NV toàn bộ SOP', 'Họp brief NV, giải đáp thắc mắc', 'HT + ĐT', 1, 44),
-- PHASE 6: MARKETING & KHAI TRUONG
(45, 'Phase 6', 'Marketing & Khai trương', 'Tạo Fanpage Facebook', 'Fanpage chi nhánh, cover, avatar', 'MKT', 1, 45),
(46, 'Phase 6', 'Marketing & Khai trương', 'Tạo Google Maps listing', 'Listing GMB, địa chỉ, ảnh, giờ', 'MKT', 1, 46),
(47, 'Phase 6', 'Marketing & Khai trương', 'Tạo Zalo OA', 'Zalo Official Account chi nhánh', 'MKT', 1, 47),
(48, 'Phase 6', 'Marketing & Khai trương', 'Setup CTKM trên IPOS', 'Tạo mã KM cho tất cả CTKM', 'MKT', 2, 48),
(49, 'Phase 6', 'Marketing & Khai trương', 'In ấn banner/standee', 'Banner, standee, poster CTKM', 'MKT', 3, 49),
(50, 'Phase 6', 'Marketing & Khai trương', 'Chạy Ads pre-opening', 'FB + Zalo Ads teaser D-7', 'MKT', 7, 50),
(51, 'Phase 6', 'Marketing & Khai trương', 'Training NV CTKM', 'Brief NV cơ chế tất cả CTKM', 'MKT', 1, 51),
(52, 'Phase 6', 'Marketing & Khai trương', 'Phát tờ rơi khu vực', 'Phát 1000 tờ rơi 1-2km', 'ĐT', 2, 52),
-- PHASE 7: KIEM TRA & NGHIEM THU
(53, 'Phase 7', 'Kiểm tra & Nghiệm thu', 'Checklist nghiệm thu tổng', 'Kiểm tra toàn bộ: MB, TB, NL, NV, SOP', 'CEO + HT', 1, 53),
(54, 'Phase 7', 'Kiểm tra & Nghiệm thu', 'Chạy thử Soft Opening nội bộ', 'Mở bán thử 1 ngày cho NV + người thân', 'ĐT + HT', 1, 54),
(55, 'Phase 7', 'Kiểm tra & Nghiệm thu', 'Fix issue từ chạy thử', 'Sửa lỗi phát hiện từ soft test', 'ĐT + HT', 1, 55),
(56, 'Phase 7', 'Kiểm tra & Nghiệm thu', 'Duyệt final từ HT', 'CEO/HT duyệt lần cuối', 'CEO', 1, 56),
(57, 'Phase 7', 'Kiểm tra & Nghiệm thu', 'SOFT OPENING chính thức', 'Khai trương mềm, bắt đầu bán', 'ĐT', 1, 57);


-- 3. MARKETING TEMPLATE (40 tasks)
INSERT INTO marketing_template (task_no, phase, task_name, ctkm_related, owner, channel, guideline, deadline_relative, kpi, cost_bearer, sort_order) VALUES
(1, 'P0', 'Tạo Fanpage Facebook chi nhánh', 'Tất cả CT', 'Content', 'Online', 'Tên: Phúc Tea [Tên CN], ảnh bìa chuẩn, avatar logo', 'D-14', 'Fanpage sẵn sàng', 'HT', 1),
(2, 'P0', 'Tạo Google Maps listing', 'CT3', 'MKT', 'Online', 'Tên business, địa chỉ, SĐT, giờ mở cửa, ảnh mặt tiền', 'D-14', 'Listing hiển thị', 'HT', 2),
(3, 'P0', 'Tạo Zalo OA chi nhánh', 'Tích điểm, Win-back', 'Quỳnh (CRM)', 'Online', 'Đăng ký Zalo OA, setup auto reply, tạo nhóm Zalo KH', 'D-14', 'OA sẵn sàng', 'HT', 3),
(4, 'P0', 'Chạy Ads teaser khai trương', 'Tất cả', 'MKT', 'Online', 'Content countdown D-7, D-3, D-1. Target 3-5km quanh CH', 'D-7', 'Reach 10K+', 'HT 100%', 4),
(5, 'P0', 'Thiết kế & in ấn banner, standee, poster CTKM', 'Tất cả CT', 'Content', 'Offline', 'File thiết kế từ HT. Standee: đồng giá 20K, Follow, Review', 'D-5', 'In đủ số lượng', 'HT', 5),
(6, 'P0', 'In Booklet', 'Booklet', 'MKT', 'Offline', 'Số lượng: [X] cuốn. 4 voucher/cuốn. In màu 2 mặt', 'D-5', 'In xong, giao CH', 'HT', 6),
(7, 'P0', 'Setup CTKM trên IPOS', 'Tất cả CT', 'Quỳnh (CRM)', 'System', 'Tạo mã KM cho: Đồng giá, Follow -5K, Review -5K, Check-in, Booklet', 'D-3', 'Test bill OK', 'HT', 7),
(8, 'P0', 'Đăng ký Foodapps (GrabFood, ShopeeFood)', 'Delivery', 'Quỳnh (CRM)', 'App', 'Submit hồ sơ, upload menu, setup giá (+30%)', 'D-14', 'Duyệt trước GO', 'HT', 8),
(9, 'P0', 'Training NV: SOP tất cả CTKM', 'Tất cả', 'MKT + ĐT', 'Tại quán', 'Brief NV: cơ chế, cách verify, FAQ KH. Phát bảng SOP A4', 'D-1', 'NV nắm 100%', 'HT + ĐT', 9),
(10, 'P0', 'Content calendar 7 ngày pre-opening', 'Tất cả', 'Content', 'Online', '7 bài post: countdown, sneak peek, teaser CTKM', 'D-7', '7 bài đăng', 'HT', 10),
(11, 'P0', 'Phát tờ rơi khu vực 1-2km', 'Awareness', 'ĐT + NV', 'Offline', '1000 tờ rơi, phát 2 ngày trước soft opening', 'D-2', '1000 tờ phát', 'HT', 11),
(12, 'P0', 'Setup hệ thống tích điểm', 'Tích điểm', 'Quỳnh (CRM)', 'System', 'IPOS/Zalo OA tích điểm. Quy đổi: [X]đ = 1 điểm', 'D-3', 'Test tích OK', 'HT', 12),
-- P1
(13, 'P1', 'Triển khai Đồng giá 20K', 'CT1: Đồng giá', 'MKT + ĐT', 'Tại quán', 'Áp dụng theo SOP. NV verify, bill trên IPOS', 'Ngày Soft', 'Số ly bán/ngày', 'HT + ĐT', 13),
(14, 'P1', 'Triển khai Follow + Share → -5K', 'CT2: Follow', 'MKT + NV', 'Tại quán + Online', 'NV verify follow + share. Bill giảm 5K trên IPOS', 'Ngày Soft', 'Số follow mới', 'HT 100%', 14),
(15, 'P1', 'Triển khai Review Google Maps → -5K/Topping', 'CT3: Review', 'MKT + NV', 'Tại quán + Online', 'NV hướng dẫn KH review. Verify trực tiếp', 'Ngày Soft', 'Số review mới', 'HT 100%', 15),
(16, 'P1', 'Triển khai Check-in FB → -50% max 20K', 'CT4: Check-in', 'MKT + NV', 'Tại quán + Online', 'NV verify check-in công khai', 'Ngày Soft', 'Số check-in', 'HT 50% + ĐT 50%', 16),
(17, 'P1', 'Chạy Ads boost post khai trương', 'Awareness', 'MKT', 'Online', 'Boost bài khai trương, target 5km', 'Ngày Soft', 'Reach 20K+', 'HT 100%', 17),
(18, 'P1', 'Monitoring & báo cáo daily KPI Phase 1', 'Tất cả', 'MKT', 'Report', 'Cuối mỗi ngày: Số ly, follow, review, check-in, doanh thu', 'Daily', 'Báo cáo mỗi tối', 'N/A', 18),
(19, 'P1', 'Target fanpage 2000 likes', 'CT2 + Ads', 'MKT', 'Online', 'Ads like page + organic từ CTKM follow', 'Cuối Phase 1', '2000 likes', 'HT', 19),
-- P2
(20, 'P2', 'Phát Booklet cho KH mua hàng', 'Booklet', 'NV + ĐT', 'Tại quán', 'Mua hàng → nhận 1 booklet. NV giải thích cách dùng', 'Ngày GO', 'Số booklet phát', 'HT', 20),
(21, 'P2', 'Setup IPOS cho 4 voucher Booklet', 'Booklet V1-V4', 'Quỳnh', 'System', '4 mã KM riêng: V1-BOGO, V2-Upsize, V3-HTTC9K, V4-Topping', 'Trước GO', 'Bill chạy đúng', 'HT', 21),
(22, 'P2', 'Tiếp tục chạy CT1-CT4', 'CT1-4', 'MKT + NV', 'Tại quán', 'Theo SOP Phase 1', 'Ngày GO', 'Theo KPI P1', 'Theo P1', 22),
(23, 'P2', 'Content live/story ngày Grand Opening', 'Awareness', 'Content', 'Online', 'Live FB, story IG/Zalo. Chụp ảnh KH, không khí khai trương', 'Ngày GO', 'Reach + engagement', 'HT', 23),
(24, 'P2', 'Thu thập data KH (SĐT qua tích điểm)', 'Data', 'NV', 'Tại quán', 'NV mời KH tích điểm. Ghi SĐT vào IPOS/Zalo OA', 'Ngày GO', '50% KH tích điểm', 'N/A', 24),
-- P3-W1
(25, 'P3-W1', 'Push tích điểm: NV mời 100% KH', 'Tích điểm', 'NV + ĐT', 'Tại quán', 'Script NV mời tích điểm', 'Sau GO', '50% DT tích điểm', 'N/A', 25),
(26, 'P3-W1', 'Setup SMS/Zalo OA welcome message', 'CSKH', 'Quỳnh', 'System', 'KH mới tích điểm → auto nhận welcome message', 'Sau GO', '100% KH mới nhận', 'HT', 26),
(27, 'P3-W1', 'Triển khai CT5: Follow + Suggest → -5K', 'CT5: Suggest', 'MKT + NV', 'Tại quán + Online', 'NV hướng dẫn KH Suggest fanpage', 'Sau GO', 'Số suggest mới', 'HT 100%', 27),
(28, 'P3-W1', 'Báo cáo tuần 1: Tổng hợp KPI', 'Report', 'MKT', 'Report', 'Tổng ly, DT, follow, review, tích điểm %, booklet redemption', 'Cuối W1', 'Báo cáo đầy đủ', 'N/A', 28),
-- P3-W2/W3
(29, 'P3-W2', 'Launch Self-delivery: Quảng bá', 'Delivery', 'MKT + Quỳnh', 'Online + Tại quán', 'Post FB, Zalo: Free ship 3km (>50K), 5km (>65K)', 'Tuần 2', 'Reach + đơn delivery', 'HT', 29),
(30, 'P3-W2', 'CTKM đơn ≥ 5 ly: Tặng 1 ly', 'Delivery 5 ly', 'MKT', 'Self-delivery', 'Đơn delivery ≥ 5 ly → tặng 1 ly', 'Tuần 2', 'Số đơn ≥5 ly/tuần', 'ĐT', 30),
(31, 'P3-W2', 'Standee/banner quảng bá delivery', 'Delivery', 'Content', 'Tại quán', 'Standee: Giao tận nơi — Free ship 3km!', 'Tuần 2', 'Standee treo', 'HT', 31),
(32, 'P3-W3', 'Monitoring đơn delivery hàng ngày', 'Delivery', 'Quỳnh + ĐT', 'Report', 'Tracking: Số đơn/ngày, AOV, km, thời gian giao', 'Daily', 'Tracking daily', 'N/A', 32),
(33, 'P3-W3', 'Đánh giá hiệu quả delivery', 'Delivery', 'MKT', 'Report', 'Nếu ít đơn: Tăng quảng bá. Nếu nhiều: Thêm NV ship', 'Cuối W3', 'Review report', 'N/A', 33),
-- P3-W4
(34, 'P3-W4', 'Lọc data KH 21 ngày chưa quay lại', 'Win-back', 'Quỳnh', 'System', 'Từ IPOS/Zalo OA: KH mua lần cuối ≥ 21 ngày', 'Tuần 4', 'List KH win-back', 'HT', 34),
(35, 'P3-W4', 'Gửi SMS/Zalo OA tin nhắn win-back', 'Win-back', 'Quỳnh', 'SMS/Zalo', 'Template: Phúc Tea nhớ bạn! Quay lại nhận [ưu đãi]...', 'Tuần 4', 'Tỷ lệ gửi OK', 'HT', 35),
(36, 'P3-W4', 'Tracking KH quay lại sau tin nhắn', 'Win-back', 'Quỳnh', 'System', 'Đối chiếu: KH nhận tin → có mua lại trong 7 ngày?', 'Tuần 5', 'Win-back rate %', 'HT', 36),
-- P3-W5
(37, 'P3-W5', 'Triển khai CTKM tròn 1 tháng', '1 tháng', 'MKT', 'Tại quán', 'Chạy 2-3 ngày. Tròn 1 tháng — Cảm ơn KH!', 'Tuần 5', 'Số ly bán/ngày', 'HT/ĐT chia', 37),
(38, 'P3-W5', 'Tổng kết 30 ngày: Báo cáo toàn bộ', 'Report', 'MKT', 'Report', 'Tổng DT, ly, follow, review, tích điểm, delivery, win-back, cost', 'Cuối W5', 'Báo cáo đầy đủ', 'N/A', 38),
(39, 'P3-W5', 'Post-mortem meeting: Đánh giá & rút kinh nghiệm', 'Improvement', 'MKT + PM', 'Meeting', 'Họp: Làm tốt / Cần cải thiện / Data cho CN tiếp', 'Cuối W5', 'Meeting minutes', 'N/A', 39),
(40, 'P3-W5', 'Lập kế hoạch tháng 2', 'Planning', 'MKT', 'Report', 'Dựa trên data 30 ngày đầu, plan CTKM tháng 2', 'Cuối W5', 'Plan tháng 2', 'N/A', 40);


-- 4. HANDBOOK (13 chapters, 4 stages)
INSERT INTO handbook (stage, chapter_no, title, content, sort_order) VALUES
('Tuần 1-2', 1, 'Giới thiệu hệ thống Phúc Tea', 'Nội dung sẽ được cập nhật sau.', 1),
('Tuần 1-2', 2, 'SOP mở/đóng cửa hàng ngày', 'Nội dung sẽ được cập nhật sau.', 2),
('Tuần 1-2', 3, 'SOP pha chế cơ bản', 'Nội dung sẽ được cập nhật sau.', 3),
('Tuần 1-2', 4, 'SOP vệ sinh an toàn thực phẩm', 'Nội dung sẽ được cập nhật sau.', 4),
('Tuần 3-4', 5, 'Quản lý nguyên liệu & inventory', 'Nội dung sẽ được cập nhật sau.', 5),
('Tuần 3-4', 6, 'Quản lý nhân sự cửa hàng', 'Nội dung sẽ được cập nhật sau.', 6),
('Tuần 3-4', 7, 'Pha chế nâng cao & QC', 'Nội dung sẽ được cập nhật sau.', 7),
('Tháng 2', 8, 'Marketing cơ bản & CTKM', 'Nội dung sẽ được cập nhật sau.', 8),
('Tháng 2', 9, 'Quản lý delivery', 'Nội dung sẽ được cập nhật sau.', 9),
('Tháng 2', 10, 'Xử lý khiếu nại khách hàng', 'Nội dung sẽ được cập nhật sau.', 10),
('Tháng 3', 11, 'Phân tích kinh doanh cơ bản', 'Nội dung sẽ được cập nhật sau.', 11),
('Tháng 3', 12, 'Tối ưu chi phí vận hành', 'Nội dung sẽ được cập nhật sau.', 12),
('Tháng 3', 13, 'Tự vận hành độc lập', 'Nội dung sẽ được cập nhật sau.', 13);


-- 5. QUIZ BANK (3 sample questions for chapter 1)
INSERT INTO quiz_bank (chapter_id, question, option_a, option_b, option_c, option_d, correct_answer, explanation) VALUES
(1, 'Phúc Tea thành lập năm nào?', '2020', '2022', '2023', '2024', 'C', 'Phúc Tea được thành lập vào năm 2023.'),
(1, 'Phí royalty Phúc Tea là bao nhiêu %?', '3%', '5%', '6%', '8%', 'C', 'Phí royalty chuẩn của Phúc Tea là 6% doanh thu.'),
(1, 'Hệ thống POS nào được sử dụng tại Phúc Tea?', 'KiotViet', 'IPOS', 'Sapo', 'Haravan', 'B', 'Phúc Tea sử dụng hệ thống IPOS cho tất cả chi nhánh.');
