# Day 4

## Note

## Task

- Write the challenges of using standalone containers.
    - chỉ sử dụng container sẽ gây ra 1 số khó khăn sau
        - gây ra downtime cho ứng dụng khi có bug
        - khi cùng lúc có nhiều container bị bug → thời gian downtime sẽ càng lớn
        - khó quản lý cùng lúc nhiều container
- Describe how Kubernetes solves those challenges
    - K8s giúp:
        - quản lý vòng đời của container đơn giản
        - tự động khởi động lại, scale, rollback
- List out 5 usecases where you should use Kubernetes and 5 usecases where you shouldn't use Kubernetes
    - Nên dùng K8s use case:
        - Ứng dụng Microservices architecture > 10 service
        - Ứng dụng cần auto-scaling theo CPU/traffic
        - CI/CD liên tục, zero downtime deploy (GitOps)
        - Hệ thống stateful (DB, message queue) cần HA & backup
    - Không nên dùng K8s cho các use case:
        - Ứng dụng đơn giản, 1-2 container
        - Serverless fuction (API nhỏ, xử lý event)
        - Demo
        - Team nhỏ