---
title: "Event 2"
date: 2024-01-01
weight: 1
chapter: false
pre: " <b> 4.2. </b> "
---

# Bài thu hoạch "First Cloud AI Journey Community Day"

- Thời gian: 9:00 - 12:00, ngày 21 tháng 3 năm 2026.
- Tầng 26, tòa nhà Bitexco Financial Tower, Số 2, đường Hải Triều, Phường Bến Nghé, Quận 1, Thành phố Hồ Chí Minh, Việt Nam.

### Mục Đích Của Sự Kiện

Sự kiện **FCAJ Community Day** được tổ chức không chỉ với mục đích chia sẻ kiến thức chuyên sâu về công nghệ, **Cloud (AWS)** và **AI**, mà còn tạo ra một không gian để cộng đồng công nghệ kết nối, giao lưu và truyền cảm hứng học hỏi lẫn nhau.

### Vai trò tham gia

Trong sự kiện lần này, tôi tham gia với vai trò là một người tham dự, lắng nghe và tiếp thu các kiến thức thực chiến từ những chuyên gia hàng đầu trong ngành, từ đó nắm bắt các xu hướng công nghệ mới nhất.

### Danh sách diễn giả

Sự kiện FCAJ Community Day lần này với sự tham gia của nhiều chuyên gia và kỹ sư hàng đầu trong lĩnh vực **Điện toán đám mây (Cloud)**, **DevOps** và **AI**. Mở đầu với phần chia sẻ rất hay từ anh **Nguyễn Gia Hưng** (Head of Solutions Architect - Việt Nam & Cambodia). Sau đó đến phần chính với các diễn giả:

- **Tinh Truong** - Platform Engineer tại GoTymeX.
- **Anh Pham** - Cloud Consultant tại G-AsiaPacific Vietnam.
- **Thinh Nguyen** - DevOps Engineer tại STYL Solutions Pte. Ltd.
- **Nhóm Team VIB** - Quán quân cuộc thi **LotusHacks**.
- **Duc Dao** - Solution Architect tại Cloud Kinetics.
- **Vy Lam** - Senior Business Systems Analyst tại VPBank.

### Nội dung

Sự kiện được chia ra thành nhiều phiên chia sẻ với các chủ đề khác nhau, tập trung vào các công nghệ hiện đại trên nền tảng AWS.

#### Góc nhìn về thị trường làm việc

AI đang làm cho việc tạo ra phần mềm rẻ hơn, dẫn đến nhu cầu về phần mềm và việc làm liên quan sẽ tăng khủng khiếp. Để cạnh tranh, kỹ sư cần trang bị kiến thức nghiệp vụ chuyên ngành và phải có sản phẩm thực tế chứng minh năng lực thay vì chỉ làm demo.

#### Chủ đề 1: Context Is Everything: Making AI Actually Work for You - Tinh Truong

Phần này nói về tầm quan trọng của ngữ cảnh trong AI. Đa phần, AI trả lời kém không phải do model tệ, mà do ngữ cảnh cung cấp không đủ chi tiết. Không nên mắc lỗi **Internet Puller** (nhồi nhét nhiều tài liệu không liên quan vào trong AI). 

Một prompt tốt cần tuân thủ cấu trúc:

**Mục tiêu - Dữ liệu liên quan - Ràng buộc - Tiêu chí thành công**

#### Chủ đề 2: Friendly AI Assistant with Amazon Quick - Anh Pham

Chủ đề này tập trung vào việc tận dụng AI để tối ưu hóa hiệu suất làm việc cho doanh nghiệp, cụ thể thông qua các trợ lý AI tự động.

Các nội dung chính gồm:

- Giải quyết bài toán thời gian: Tác giả nhấn mạnh việc quản lý, thường thì chúng ta sẽ mất rất nhiều thời gian để tập hợp dữ liệu và làm báo cáo thủ công. **Amazon Quick** được giới thiệu như một giải pháp thông minh giúp giảm tải công việc này.

- Hệ sinh thái thích hợp: **Amazon Quick** kết nối với các hệ sinh thái phổ biến như **Microsoft (PowerBI, Word, Outlook, Teams)** và **Google (Gmail, Calender)** thông qua **platform Agent**, cho phép người dùng tự xây dựng các Agent phục vụ mục đích cá nhân hoặc doanh nghiệp.

- Các tính năng nổi bật:<br>
&bull; **BI (Business Intelligence)**: Tự động phân tích chuyên sâu khi nhận dữ liệu đầu vào.<br>
&bull; **Inside & Chat**: Cho phép tương tác trực tiếp với dữ liệu để hiểu thông tin.<br>
&bull; **Automation**: Tự động hóa hoàn toàn quy trình công việc thông qua **automation flow**.<br>

- Demo thực tế: Phần demo cho thấy khả năng nhập dữ liệu Excel để tạo Dashboard tự động và yêu cầu AI tóm tắt nội dung cuộc họp từ file record, giúp người dùng không chuyên về kỹ thuật cũng có thể xử lý dữ liệu phức tạp một cách dễ dàng.

#### Chủ đề 3: From Edge To Origin: CloudFront as Your Foundation - Thinh Nguyen

Chủ đề này tập trung vào vai trò của **Amazon CloudFront** không chỉ là dịch vụ CDN truyền thống mà còn là nền tảng bảo mật, tối ưu hóa ứng dụng toàn diện.

Các nội dung chính bao gồm:

1. Khả năng bảo mật nâng cao:

- **VPC Private Origin**: Tạo đường truyền riêng biệt từ **CloudFront** vào **private subnet**, giúp ẩn hạ tầng **backend** khỏi internet công cộng.

- **Mutual TLS**: Yêu cầu xác thực chứng chỉ từ cả hai phía (client và server), phù hợp cho các hệ thống tài chính hoặc nội dung bản quyền.

- **Chặn tấn công theo khu vực/IP**: Giảm tải cho server bằng cách chặn các truy cập độc hại ngay tại lớp **Edge** trước khi chúng chạm tới **Origin**.

2. 