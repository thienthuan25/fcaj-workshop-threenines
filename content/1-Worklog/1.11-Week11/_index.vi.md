---
title: "Worklog Tuần 11"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 1.11. </b> "
---

### Mục tiêu tuần 11:

* Triển khai lại toàn bộ hệ thống CloudCost Insight để kiểm chứng khả năng tái lập và đảm bảo hệ thống hoạt động ổn định.
* Kiểm thử toàn bộ hệ thống và khắc phục các lỗi phát sinh trong quá trình triển khai.
* Thống nhất với nhóm về việc mỗi thành viên tự triển khai lại project để viết Workshop cá nhân cho riêng mình.
* Hoàn thành tài liệu Workshop theo hướng dẫn từng bước (step-by-step) dựa trên quá trình triển khai thực tế.
* Tổng hợp tiến độ hoàn thành Workshop của các thành viên trong nhóm vào cuối tuần.
* Duy trì phối hợp cùng nhóm: trao đổi kế hoạch trước khi làm và tổng hợp kết quả sau mỗi ngày.

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Học tập trực tiếp tại văn phòng. <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Thảo luận về tiến độ dự án và kế hoạch hoàn thành Workshop trong tuần cuối. <br>&emsp; + Chia sẻ kinh nghiệm triển khai hệ thống và các vấn đề cần lưu ý khi viết Workshop. <br>&emsp; | 20/07/2026 | 20/07/2026 | |
| 3 | - Triển khai lại và kiểm thử toàn bộ hệ thống: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Triển khai lại toàn bộ hệ thống CloudCost Insight trên AWS bằng Terraform. <br>&emsp; + Kiểm thử end-to-end toàn bộ hệ thống để xác nhận tất cả các thành phần hoạt động đúng như thiết kế. <br>&emsp; + Khắc phục các lỗi phát sinh trong quá trình triển khai và kiểm thử. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 21/07/2026 | 21/07/2026 | - AWS Management Console. |
| 4 | - Bắt đầu viết Workshop: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Thống nhất với nhóm rằng mỗi thành viên sẽ tự triển khai lại project để tự xây dựng Workshop cá nhân. <br>&emsp; + Bắt đầu viết Workshop dựa trên quá trình triển khai thực tế của bản thân. <br>&emsp; + Hoàn thiện các phần đầu của Workshop và chuẩn bị hình ảnh minh họa. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 22/07/2026 | 22/07/2026 | - FCAJ Workshop Template. |
| 5 | - Tiếp tục hoàn thiện Workshop: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Viết tiếp các bước triển khai hệ thống, cấu hình dịch vụ AWS và kiểm thử. <br>&emsp; + Bổ sung hình ảnh minh họa và rà soát nội dung để đảm bảo tính chính xác. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 23/07/2026 | 23/07/2026 | - FCAJ Workshop Template. |
| 6 | - Hoàn thành Workshop và tổng hợp tiến độ: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Hoàn thiện toàn bộ nội dung Workshop, kiểm tra lại bố cục, hình ảnh và các bước hướng dẫn. <br>&emsp; + Tổng hợp tiến độ hoàn thành Workshop của các thành viên còn lại trong nhóm. <br>&emsp; + Chia sẻ kết quả và chuẩn bị cho giai đoạn nghiệm thu tài liệu. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 24/07/2026 | 24/07/2026 | - FCAJ Workshop Template. |

### Kết quả đạt được tuần 11:

* **Triển khai lại và xác minh toàn bộ hệ thống:** Đã triển khai lại hoàn chỉnh hệ thống CloudCost Insight trên AWS bằng Terraform và tiến hành kiểm thử toàn bộ các thành phần. Quá trình này giúp xác nhận rằng toàn bộ hạ tầng và ứng dụng có thể được tái tạo thành công từ mã nguồn, đồng thời khẳng định tính nhất quán của phương pháp Infrastructure as Code.

* **Kiểm thử và khắc phục lỗi:** Đã thực hiện kiểm thử end-to-end toàn bộ hệ thống, bao gồm các luồng thu thập dữ liệu, phân tích chi phí, cảnh báo, giám sát và web dashboard. Trong quá trình kiểm thử, một số lỗi nhỏ đã được phát hiện và khắc phục.

* **Thống nhất phương án viết Workshop:** Nhóm đã thống nhất rằng mỗi thành viên sẽ tự triển khai lại project và tự xây dựng một Workshop cá nhân dựa trên quá trình triển khai của mình. Cách làm này giúp mỗi thành viên hiểu rõ toàn bộ quy trình triển khai, đồng thời tạo ra tài liệu hướng dẫn mang tính thực tiễn và có thể tái sử dụng.

* **Hoàn thành tài liệu Workshop:** Đã hoàn thiện tài liệu Workshop theo hướng dẫn từng bước (step-by-step), mô tả chi tiết toàn bộ quá trình triển khai hệ thống từ chuẩn bị môi trường, xây dựng hạ tầng, phát triển các thành phần của hệ thống, kiểm thử cho đến dọn dẹp tài nguyên. Tài liệu được bổ sung đầy đủ hình ảnh minh họa và kết quả mong đợi ở từng bước để người đọc có thể dễ dàng thực hiện theo.

* **Tổng hợp tiến độ của nhóm:** Vào cuối tuần, đã tổng hợp tiến độ hoàn thành Workshop của các thành viên còn lại trong nhóm nhằm đảm bảo mọi người đều hoàn thành đúng kế hoạch. Đồng thời cùng nhau trao đổi, rà soát và chia sẻ kinh nghiệm để nâng cao chất lượng tài liệu.

* **Phối hợp cùng nhóm:** Duy trì thói quen làm việc nhóm hiệu quả trong suốt tuần. Trước khi bắt đầu công việc mỗi ngày, tôi trao đổi kế hoạch với các thành viên trong nhóm, và cuối mỗi ngày tổng hợp lại kết quả đã làm để cả nhóm cùng nắm tiến độ.