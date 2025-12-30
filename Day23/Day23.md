# Day23: Kubernetes RBAC Explained - Role Based Access Control Kubernetes

## Task 23/40 December 23, 2025 and December 27, 2025

### Task details

### Checking Default User Permissions

Note: I am referring the username as `krishna` here in this task but feel free to use your own name or `adam` as per the previous task.

1. Change to the context to `krishna` that you created in the previous day 22 task.
2. Create a new Pod. What would you expect to happen?

### Granting Access to the User December 27, 2025

- Switch back to the original context with admin permissions.
- Create a new Role named `pod-reader`. The Role should grant permissions to get, watch and list Pods.
    
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      namespace: default
      name: pod-reader
    rules:
      - apiGroups: [""] # "" indicates the core API group
        resources: ["pods"]
        verbs: ["get", "watch", "list"]
    
    ```
    
- Create a new RoleBinding named `read-pods`. Map the user `krishna` to the Role named `pod-reader`.
    
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    # This role binding allows "jane" to read pods in the "default" namespace.
    # You need to already have a Role named "pod-reader" in that namespace.
    kind: RoleBinding
    metadata:
      name: read-pods
      namespace: default
    subjects:
      # You can specify more than one "subject"
      - kind: User
        name: quangtm # "name" is case-sensitive
        apiGroup: rbac.authorization.k8s.io
    roleRef:
      # "roleRef" specifies the binding to a Role / ClusterRole
      kind: Role #this must be Role or ClusterRole
      name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
      apiGroup: rbac.authorization.k8s.io
    
    ```
    
- Make sure that both objects have been created properly.
    - `k get roles`
    - `k get rolebindings`
- Switch to the context named `krishna`.
    - `k config get-contexts`
    - `k config use-context quangtm-context`
- Create a new Pod named `nginx` with the image `nginx`. What would you expect to happen?
    - `k run nginx --image=nginx`
        
        > Error from server (Forbidden): pods is forbidden: User "quangtm" cannot create resource "pods" in API group "" in the namespace "default"
        > 
- List the Pods in the namespace. What would you expect to happen?
    - List Pod OK
- Create a new deploymened named `nginx-deploy`. What would you expect to happen?
    - `k create deploy nginx-deploy --image nginx`
        
        > error: failed to create deployment: deployments.apps is forbidden: User "quangtm" cannot create resource "deployments" in API group "apps" in the namespace "default"
        > 

## Note: December 27, 2025

### I. Để cấp quyền cho 1 user có thể sử dụng tài nguyên K8s thì cần làm:

- cần cấp quyền cho user gọi được API của K8s
    - user cần có chứng chỉ X.509
    - chứng chỉ này phải được CA trong cluster K8s đó tin cậy (CA này thường là CA nội bộ nằm trong cụm K8s)

### II. Các bước để tạo Certificate cho user:

1. User tạo private key: `openssl genrsa -out <file_name>.pem 2048`
2. Tạo 1 CertificateSigningRequest (CSR để yêu cầu CA cấp chứng chỉ)
Lệnh tạo file CSR: `openssl req -new -key <file_name>.key -out <file_name>.csr -subj "/CN=<user_name>”`
    - Khi tạo được CSR, cần phải encode nội dung file bằng lệnh: `cat learner.csr | base64 | tr -d "\\n”`
    - Dựa vào yaml CSR có sẵn, chèn nội dung CSR được mã hóa vào thuộc tính request:
        
        ```yaml
        apiVersion: certificates.k8s.io/v1
        kind: CertificateSigningRequest
        metadata:
          name: my-app-csr # A unique name for the request
        spec:
          request: <base64-encoded-csr-data-here>
          signerName: kubernetes.io/kube-apiserver-client # Or other signer, like cert-manager's
          expirationSeconds: 604800
          usages:
            - client auth
        ```
        
3. Admin quản lý cụm K8s sẽ approve CSR
    - chạy lệnh để approve: `kubectl certificate approve <certificate-signing-request-name>`
    - sau khi approve thì K8s CA sẽ ký certificate
    - user sẽ nhận certificate chính thức bằng cách chạy lệnh:
        - lọc kết quả từ file vừa lấy và tạo 1 file certificate mới: `k get csr/quangtm -o jsonpath='{.status.certificate}' | base64 --decode ><file_name>.crt`
4. Client dùng Certificate được cấp để call API K8s
    - Client cấu hình:
        - private key
        - certificate
    - Khi gọi API:
        - client gửi certificate
        - API Server xác thực:
            - Certificate có hợp lệ không?
            - CA tin cậy không?
            - CN/O (username/group) là ai?
        - Nếu xác thực thành công, K8s sẽ check tiếp RBAC để xác định quyền của user đó.

### III. Role dùng để làm gì? Cách tạo Role?

1. Role dùng để:
    - Định nghĩa quyền
    - Chỉ áp dụng cho 1 namespace duy nhất được khai báo trong yaml config của role đó
    - Role không cấp quyền trực tiếp cho user, mà phải sử dụng RoleBinding
2. Cách tạo Role (giải thích 1 số config)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]

```

`namespace:` namespace mà Role được phép thao tác

`rules:` là để khai báo các rule mà Role áp dụng

- `apiGroups: [””]`, tức là cho phép sử dụng Core API group bao gồm: `pods, services, configmaps, secrets, namespaces`
- `resources`: là loại tài nguyên được phép thao tác
- `verbs:` là các hành động được phép

### IV. Tạo context cho user

Các bước:

1. Tạo credentials cho user: `kubectl config set-credentials quangtm --client-certificate=quangtm.crt --client-key=quangtm.pem`
2. Tạo context cho user: `k config set-context quangtm-context --cluster=kind-k8s-cka-cluster2 --user=quangtm --namespace=default`