---
title: "Worklog Tuần 11"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 1.11. </b> "
---

### Mục tiêu tuần 11:

* Xây dựng quy trình CI/CD cho CloudCost Insight bằng GitHub Actions và HCP Terraform.
* Tự động kiểm tra Hugo Workshop, mã Python Lambda, Terraform và JavaScript Dashboard trước khi merge.
* Tự động triển khai thay đổi hạ tầng Terraform lên AWS sau khi được merge vào nhánh `main`.
* Cấu hình branch protection cho `main` nhằm bảo đảm thay đổi phải thông qua Pull Request và kiểm tra CI.
* Triển khai lại, kiểm thử toàn bộ hệ thống và khắc phục các lỗi phát sinh.
* Hoàn thiện Workshop theo hướng dẫn từng bước dựa trên quá trình triển khai, kiểm thử và CI/CD thực tế.
* Tổng hợp tiến độ hoàn thành Workshop của các thành viên trong nhóm vào cuối tuần.
* Duy trì phối hợp cùng nhóm: trao đổi kế hoạch trước khi làm và tổng hợp kết quả sau mỗi ngày.

### Các công việc triển khai trong tuần:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu |
| --- | --- | --- | --- | --- |
| 2 | - Học tập trực tiếp tại văn phòng và xây dựng quy trình CI: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Thảo luận về tiến độ dự án, kế hoạch hoàn thành Workshop và nhu cầu tự động hóa kiểm tra mã nguồn. <br>&emsp; + Tạo file `.github/workflows/ci.yml` bằng GitHub Actions. <br>&emsp; + Cấu hình các job kiểm tra Hugo Workshop, cú pháp Python Lambda, định dạng và cấu hình Terraform, cú pháp JavaScript Dashboard. <br>&emsp; + Tạo Pull Request để kiểm tra workflow CI hoạt động đúng. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 20/07/2026 | 20/07/2026 | - GitHub Actions Documentation: <br> https://docs.github.com/en/actions <br> - Terraform GitHub Actions: <br> https://developer.hashicorp.com/terraform/tutorials/automation/github-actions |
| 3 | - Hoàn thiện kiểm thử tự động và Terraform Plan CI: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Xây dựng unit test cho Lambda Collector, Analyzer và API bằng pytest cùng mock AWS client. <br>&emsp; + Cấu hình lint, kiểm tra cú pháp và chạy unit test cho mã Python Lambda. <br>&emsp; + Cấu hình Terraform fmt, validate và Terraform plan trên Pull Request thông qua HCP Terraform. <br>&emsp; + Khắc phục các lỗi lint, định dạng Terraform, biến Terraform và workflow CI phát sinh trong quá trình kiểm thử. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 21/07/2026 | 21/07/2026 | - pytest Documentation: <br> https://docs.pytest.org/ <br> - Ruff Documentation: <br> https://docs.astral.sh/ruff/ <br> - HCP Terraform Documentation: <br> https://developer.hashicorp.com/terraform/cloud-docs |
| 4 | - Xây dựng CD, kiểm thử lại hệ thống và bảo vệ nhánh `main`: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Tạo workflow `.github/workflows/terraform-apply.yml` để tự động Terraform Apply sau khi thay đổi Terraform được merge vào `main`. <br>&emsp; + Cấu hình GitHub Environment `production`, HCP Terraform API token và cơ chế phê duyệt trước khi deploy. <br>&emsp; + Bật branch protection cho nhánh `main`, yêu cầu Pull Request và các CI checks bắt buộc trước khi merge. <br>&emsp; + Triển khai lại và kiểm thử end-to-end toàn bộ hệ thống; kiểm tra luồng Cognito, API Gateway, SQS, Lambda, SNS, CloudWatch và Dashboard. <br>&emsp; + Khắc phục các lỗi phát sinh trong quá trình triển khai và kiểm thử. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 22/07/2026 | 22/07/2026 | - GitHub Environments: <br> https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments <br> - GitHub Branch Protection: <br> https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository |
| 5 | - Viết và hoàn thiện Workshop step-by-step: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Thống nhất với nhóm rằng mỗi thành viên tự triển khai lại project để xây dựng Workshop cá nhân. <br>&emsp; + Viết các bước triển khai hạ tầng, Lambda, Dashboard, Cognito, kiểm thử hệ thống và CI/CD. <br>&emsp; + Bổ sung các kết quả kiểm thử như SQS partial batch failure, xử lý lỗi S3, xác thực JWT và CORS. <br>&emsp; + Chuẩn bị hình ảnh minh họa, log và kết quả mong đợi cho từng bước. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 23/07/2026 | 23/07/2026 | - FCAJ Workshop Template. |
| 6 | - Rà soát Workshop và tổng hợp tiến độ: <br>&emsp; + Trao đổi với nhóm về kế hoạch công việc trong ngày trước khi bắt đầu. <br>&emsp; + Hoàn thiện nội dung Workshop, kiểm tra lại bố cục, hình ảnh, code mẫu và các bước hướng dẫn. <br>&emsp; + Kiểm tra Hugo Workshop build thành công và nội dung được cập nhật trên GitHub Pages. <br>&emsp; + Tổng hợp tiến độ hoàn thành Workshop của các thành viên còn lại trong nhóm. <br>&emsp; + Chia sẻ kết quả, rà soát tài liệu và chuẩn bị cho giai đoạn nghiệm thu. <br>&emsp; + Cuối ngày tổng hợp và chia sẻ kết quả với nhóm. | 24/07/2026 | 24/07/2026 | - FCAJ Workshop Template. <br> - Hugo Documentation: <br> https://gohugo.io/documentation/ |

### Kết quả đạt được tuần 11:

* **Hoàn thành quy trình CI:** Đã xây dựng workflow GitHub Actions tại file `ci.yml` để tự động kiểm tra mã nguồn khi có Pull Request vào nhánh `main`. CI thực hiện build Hugo Workshop, kiểm tra mã Python Lambda, kiểm tra định dạng và cấu hình Terraform, đồng thời kiểm tra cú pháp JavaScript của Dashboard.

* **Bổ sung unit test và Terraform Plan CI:** Đã xây dựng unit test cho Lambda Collector, Analyzer và API bằng pytest cùng mock AWS client, giúp kiểm tra logic xử lý mà không cần gọi tài nguyên AWS thật. Đồng thời đã cấu hình Terraform fmt, validate và Terraform plan thông qua HCP Terraform để phát hiện lỗi hạ tầng trước khi merge.

* **Hoàn thành CD Terraform:** Đã tạo workflow `terraform-apply.yml` để tự động triển khai thay đổi Terraform lên AWS sau khi thay đổi được merge vào nhánh `main`. Workflow sử dụng HCP Terraform để quản lý state và remote run, đồng thời sử dụng GitHub Environment `production` để quản lý token cũng như kiểm soát quá trình deploy.

* **Bảo vệ nhánh main:** Đã cấu hình branch protection cho nhánh `main`, yêu cầu thay đổi phải thông qua Pull Request và vượt qua các CI checks bắt buộc trước khi merge. Cơ chế này giúp hạn chế thay đổi không được kiểm tra và giảm rủi ro triển khai Terraform lỗi lên môi trường production.

* **Triển khai lại, kiểm thử và khắc phục lỗi:** Đã triển khai lại hệ thống CloudCost Insight bằng Terraform và tiến hành kiểm thử end-to-end. Các luồng thu thập dữ liệu, phân tích chi phí, SQS, DLQ, SNS, CloudWatch, Cognito, API Gateway và Dashboard được kiểm tra để bảo đảm hoạt động đúng. Các lỗi phát sinh trong quá trình kiểm thử đã được ghi nhận và khắc phục.

* **Hoàn thiện tài liệu Workshop:** Đã viết và rà soát Workshop theo hướng dẫn từng bước, mô tả quá trình chuẩn bị môi trường, triển khai hạ tầng, xây dựng Lambda, Dashboard, Cognito, kiểm thử hệ thống, CI/CD và dọn dẹp tài nguyên. Nội dung được bổ sung code mẫu, hình ảnh minh họa, log và kết quả mong đợi để người đọc có thể thực hiện theo.

* **Tổng hợp tiến độ của nhóm:** Cuối tuần đã tổng hợp tiến độ hoàn thành Workshop của các thành viên còn lại trong nhóm. Các thành viên cùng trao đổi, rà soát và chia sẻ kinh nghiệm triển khai nhằm nâng cao chất lượng tài liệu.

* **Phối hợp cùng nhóm:** Duy trì thói quen làm việc nhóm hiệu quả trong suốt tuần. Trước khi bắt đầu công việc mỗi ngày, tôi trao đổi kế hoạch với các thành viên trong nhóm, và cuối mỗi ngày tổng hợp lại kết quả đã làm để cả nhóm cùng nắm tiến độ.