---
title : "Triển khai"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.5.3 </b> "
---

1. Trên Terminal WSL2, triển khai các Alarm vừa cấu hình:

```bash
terraform apply
```

2. Sau khi apply thành công, bạn kiểm tra danh sách Alarm trên Console. Ban đầu, các Alarm sẽ ở trạng thái **OK** vì chưa có lỗi nào:

![Monitoring](/fcaj-workshop-threenines/images/5-Workshop/5.5-Monitoring/5.5.3-Deploy/deploy_1.png)

Sau khi hoàn thành phần này, hệ thống đã có đầy đủ khả năng tự giám sát. Bất cứ khi nào một hàm Lambda gặp lỗi hoặc có sự kiện rơi vào **Dead Letter Queue**, bạn sẽ nhận được email cảnh báo để xử lý kịp thời.

#### Nội dung tiếp theo

- [Dashboard](5-Workshop/5.6-Dashboard/)

