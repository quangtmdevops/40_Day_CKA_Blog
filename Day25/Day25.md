# Day25: Kubernetes Service Account - RBAC Continued

## Task 25/40 December 31, 2025

- What is a Kubernetes Service account
    - là tài khoản dành cho ứng dụng hoặc Pod, dùng để xác thực và phân quyền khi Pod gọi Kubernetes API hoặc các service nội bộ.
    - ví dụ: khi 1 Pod cần list Pod, hay một dịch vụ vào đó cần quyền thực thi trong Kubernetes
- Why do we need a service account
    - giúp cấp quyền thực thi trong Kubernetes cho service, pod, hay một gì dịch vụ đang chạy nào đó
- Default service account in Kubernetes
    - là **ServiceAccount được tạo tự động trong mỗi namespace**, và được dùng **mặc định cho Pod** nếu bạn không chỉ định ServiceAccount khác.
- How to create a service account
    - tạo service account: `k create sa build-sa`
    - tạo role: `k create role pod-reader --verb=get,list,watch --resource=pods`
    - tạo config yaml cho rolebindings:
- Create a role and rolebinding for the service account
    
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: pod-reader-binding
      namespace: default
    subjects:
      - kind: ServiceAccount
        name: build-sa
        namespace: default
    roleRef:
      kind: Role
      name: pod-reader
      apiGroup: rbac.authorization.k8s.io
    ```
    

## Note December 31, 2025