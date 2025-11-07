# Day02

## Note

1. Docker init command ?
    
    Lệnh này sẽ khởi tạo 1 project với các file cần thiết để run project trong container
    
    - .dockerignore
    - Dockerfile
    - compose.yaml
    - README.Docker.md
2. Các khái niệm cần lưu ý:
    1. Dockerfile
        
        Dockerfile là 1 file chứa các chỉ dẫn (instruction) cho quá trình đóng gói (build) source code thành một Image.
        
        Các Instructions trong Dockerfile được viết dạng in hoa (uppercase)
        
        Docker engine sẽ đọc nội dung Dockerfile và thực hiện build thành Image
        
    2. Image
        
        Là một form mẫu riêng của mà Docker build ra, khi chạy một Image sẽ tạo ra 1 Container.
        
        Tags: được dùng để gán cho một Image (có thể hiểu là tên của Image). Mỗi Image có một Tags riêng, nếu thực hiện gán lại Tags cho Image thì sẽ tạo ra 1 Image ý hệt cái cũ nhưng có Tags mới.
        
    3. Container
        
        Là một môi trường nhẹ, riêng biệt được chạy dựa trên Image, dùng để chạy ứng dụng nào đó mà ta muốn.
        
    4. compose.yaml
        
        Là một file cấu hình ở dạng yaml, file này phục vụ cho việc chạy nhiều container cùng lúc.
        

Tag [@PiyushSachdeva](https://www.linkedin.com/in/piyush-sachdeva) and [@CloudOps Community](https://www.linkedin.com/company/thecloudopscomm) 

**#40daysofkubernetes**