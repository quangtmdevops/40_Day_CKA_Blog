# Day01

1. Docker Architecture
    
    ![Ref: [this](https://data-flair.training/blogs/docker-architecture/)](Images/image.png)
    
    Ref: [this](https://data-flair.training/blogs/docker-architecture/)
    
2. Docker Workflow
    
    ![Ref: [this](https://k21academy.com/docker-kubernetes/docker-and-kubernetes/)](Images/image%201.png)
    
    Ref: [this](https://k21academy.com/docker-kubernetes/docker-and-kubernetes/)
    

## Note (Giải thích một số ý chính về Docker)

1. Docker là gì?
    
    Docker là một công cụ giúp dễ dàng triển khai ứng dụng một cách đơn giản, nhanh chóng và đồng nhất.
    
    Khi deploy 1 dự án bất kì, Docker cho phép tạo ra một môi trường riêng biệt, chứa toàn bộ: Libralies, appication, runtime, dependencies cần thiết cho việc deploy dự án.
    
2. Sự khác nhau giữa Virtual Machine và Container
    - Virtual Machine được chia thành 4 tầng:
        - Tầng phần cứng (Hardware)
        - Tầng hệ điều hành (Operator System)
        - Tầng Hypervisor
        - Tầng Virtual Machine
        
        Đối với một server có 1 cấu hình phần cứng nhất định (VD: 16GB ram, 20CPU) thì có thể tạo ra khoảng 8 máy ảo (mỗi máy sẽ tiêu tốn cấu hình phần cứng nhất định). ⇒ không thể đáp ứng được nhu cầu cần chạy 20-30 dịch vụ đồng thời.
        
    - Containers cũng có 4 tầng:
        - Tầng phần cứng (Hardware)
        - Tầng hệ điều hành (Operator System)
        - Tầng Container Engine
        - Tầng Container
        
        Với cùng server có cấu hình như trên, số container được tạo ra có thể đáp ứng việc phục vụ nhiều ứng dụng nếu tính toán tài nguyên hợp lý.
        
3. Các bối cảnh mà Docker cho thấy tác dụng:
    1. Khi chạy nhiều dịch vụ trên cùng 1 server, tài nguyên cấp phát cho các dịch vụ không đồng đều. → Docker cho phép người dùng quản lý và phân bổ tài nguyên theo nhu cầu sử dụng.
    2. Khi chạy cùng 1 dịch vụ ở trên nhiều môi trường khác nhau, thường bị conflict → Docker cho phép xây dựng những môi trường giống hệt với môi trường gốc, đảm bảo không bị lỗi deploy do môi trường.
    

Tag [@PiyushSachdeva](https://www.linkedin.com/in/piyush-sachdeva) and [@CloudOps Community](https://www.linkedin.com/company/thecloudopscomm) 

**#40daysofkubernetes**