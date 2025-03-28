# 🎹 2024-DayoneAsia App  Sunny Days Piano 🎶

## 🚀 Hướng Dẫn Chạy Dự Án

### 🔥 1️⃣ Sau Khi Pull Code Về
Chạy các lệnh sau để cài đặt dependencies và khởi động ứng dụng:

```sh
flutter pub get
cd dependencies && flutter pub get
flutter run

📌 Lưu ý: Chọn đúng thiết bị (device) để chạy ứng dụng.

📱 Cập Nhật Ứng Dụng
🟢 Android
Mở dự án bằng Android Studio.
Vào file android/app/build.gradle, tăng giá trị versionCode lên 1 đơn vị.
Ví dụ: Nếu versionCode = 1, tăng lên versionCode = 2.
Build file .aab và upload lên Google Play Console.
🍏 iOS
Mở dự án bằng Xcode.
Vào Product → Archive để tạo bản build.
Sau khi hoàn tất, vào App Store Connect và upload ứng dụng lên TestFlight hoặc phát hành chính thức

## 🌎 Môi Trường Dự Án  

Dự án hỗ trợ **5 môi trường**, giúp dễ dàng quản lý và phát triển ứng dụng.  

| 🌍 **Môi trường** | 📝 **Mô tả** | 🔎 **Sử dụng cho** |
|------------------|------------|----------------|
| **Production** (`main.dart`) | Phiên bản chính thức của ứng dụng. | Người dùng cuối. |
| **Staging** (`main_staging.dart`) | Môi trường kiểm thử của BA Team. | Kiểm tra trước khi phát hành. |
| **Demo** (`main_demo.dart`) | Phiên bản demo tính năng mới. | Giới thiệu với đối tác, khách hàng. |
| **DEV** (`main_dev.dart`) | Môi trường cho Dev Mobile. | Phát triển và debug. |
| **Local** (`main_local.dart`) | Chạy thử nghiệm trên máy cá nhân. | Kiểm tra API cục bộ. |



🎯 Chi Tiết Các Môi Trường
🔹 1️⃣ Production (main.dart)
📌 Dành cho: Phiên bản chính thức, phát hành trên App Store & Google Play.
🔍 Ví dụ: Người dùng đặt lịch, theo dõi bài học, đồng bộ dữ liệu trên các thiết bị.

🔹 2️⃣ Staging (main_staging.dart)
📌 Dành cho: Đội BA kiểm thử tính năng mới.
🔍 Ví dụ: Kiểm tra các tính năng trước khi release lên Production.

🔹 3️⃣ Demo (main_demo.dart)
📌 Dành cho: Giới thiệu tính năng mới trước khi phát hành.
🔍 Ví dụ: Trình bày bản xem trước các tính năng tại hội nghị hoặc đối tác.

🔹 4️⃣ DEV (main_dev.dart)
📌 Dành cho: Dev Mobile kiểm tra & debug ứng dụng.
🔍 Ví dụ: Mô phỏng các kịch bản kiểm soát truy cập, phát hiện lỗi bảo mật.

🔹 5️⃣ Local (main_local.dart)
📌 Dành cho: Dev kiểm tra kết nối API cục bộ.
🔍 Ví dụ: Test các API trước khi tích hợp vào môi trường Dev/Staging.


---

📌 **Hướng Dẫn Copy & Sử Dụng**:  
1. **Mở VS Code / Terminal**.  
2. **Tạo hoặc mở file `README.md`** trong thư mục gốc của dự án.  
3. **Copy toàn bộ nội dung trên** và **paste vào `README.md`**.  
4. **Lưu file (`Ctrl + S` hoặc `Cmd + S` trên Mac)**.  
5. Nếu muốn đẩy lên Git, chạy:  

   ```sh
   git add README.md
   git commit -m "Cập nhật README cho dự án"
   git push origin main  # Hoặc branch bạn đang làm việc