# Day26: Network Policies Kubernetes

## Task 26/40 January 2, 2026

### Task details

1. Create a new kind cluster by disabling the default CNI → ✅
2. Install `Calico` Network Add-on to your Kind cluster → ✅
3. Create 3 deployments with as below:
name: frontend , image-name: nginx , replicas=1 , containerPort
name: backend , image-name: nginx , replicas=1 , containerPort
name: db , image-name: mysql , replicas=1 , containerPort: 3306
    - `k create deployment frontend --namespace=quickstart --image=nginx --replicas=1 --port=80`
    - `k create deployment backend --namespace=quickstart --image=nginx --replicas=1 --port=80`
    
    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: mysql-secret
      namespace: quickstart
    type: Opaque
    stringData:
      MYSQL_ROOT_PASSWORD: ''
      MYSQL_DATABASE: ''
      MYSQL_USER: appuser
      MYSQL_PASSWORD: ''
    
    ```
    
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: db
      namespace: quickstart
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: mysql
      template:
        metadata:
          labels:
            app: mysql
        spec:
          containers:
            - name: db
              image: mysql:8.0
              ports:
                - containerPort: 3306
              envFrom:
                - secretRef:
                    name: mysql-secret
    
    ```
    
    - `k create deployment db --namespace=quickstart --image=mysql --replicas=1 --port=3306`
4. Expose all of these applications on a nodePort service with the same name as the deployment name
    - `k expose deployment frontend --namespace=quickstart --type=NodePort --port=80 --target-port=80`
    - `k expose deployment backend --namespace=quickstart --type=NodePort --port=80 --target-port=80`
    - `k expose deployment backend --namespace=quickstart --type=NodePort --port=80 --target-port=80`
    
5. Do the connectivity test that all of your pods are able to interact with each other.
    - `k exec -it <pod_name> -- bash`
    - `apt update && apt install telnet iputils-ping dnsutils -y`
    - `telnet frontend:80`
    - `telnet backend:80`
    - `telnet db:80`
6. Create a network policy and restrict the access so that only backend pod should be able to access the db service on port 3306.
    
    ```yaml
    apiVersion: projectcalico.org/v3                                       kind: NetworkPolicy
    metadata:
      name: allow-backend-to-mysql
      namespace: quickstart
    spec:
      selector: app == 'mysql'
      types:
      - Ingress
      ingress:
      - action: Allow
        source:
          selector: app == 'backend'  
    ```
    
    ```yaml
    apiVersion: projectcalico.org/v3                                       kind: NetworkPolicy
    metadata:
      name: allow-backend-to-mysql
      namespace: quickstart
    spec:
      selector: app == 'backend'
      types:
      - Ingress
      ingress:
      - action: Allow
        source:
          selector: app == 'frontend'  
    ```
    
    `spec.selector:` là pod có label được áp dụng rule ingress đi vào pod đó
    
    `spec.ingress.source.selector`: là pod được phép gửi gói tin đến pod mục tiêu 
    
7. Attach this network policy to the backend deployment: `k apply -f network-policies-allow-ingress-db.yaml`

## Note January 2, 2026

1. **Calico**: là 1 opensource giúp quản lý network và các policies lquan đến network trong Kubernetes. Xem thêm: [link](https://docs.tigera.io/calico/latest/about/)
2. **Network Policies:** là để giới hạn khả năng giao tiếp giữa các Pod.
    - Mặc định, các Pod trong Cụm K8s có khả năng giao tiếp với nhau.
    - Thực tế, ta sẽ không muốn 1 Pod bất kỳ có thể giao tiếp với Pod có chức năng Database
    - Do đó, cần hạn chế khả năng giao tiếp giữa các Pod với Pod chạy Database
3. **Network Policies**: sử dụng matchLabels để chọn Pod được áp dụng Policies

### Các bước để tạo cụm k8s với calico để quản lý network:

1. Tạo Cluster
    - Mặc định, khi tạo Cluster sẽ dùng CNI mặc định - tự động tải và cài đặt plugin network (sẽ không thể cấu hình network policies)
    - config.yaml
        
        ```jsx
        kind: Cluster
        apiVersion: kind.x-k8s.io/v1alpha4
        nodes:
          - role: control-plane
          - role: worker
          - role: worker
        networking:
          disableDefaultCNI: true
          podSubnet: 192.168.0.0/16
        ```
        
        Sử dụng disableDefaultCNI: để disableDefaultCNI
        
        podSubnet có giải 192.168.0.0/16 là quy định riêng của Calico
        
    - chạy lệnh: `kind create cluster --name=calico-cluster --config=config.yaml` tạo cluster với name là `calico-cluster`
2. Install Calico
    - Sau khi chạy bước 1, các Node sẽ ở trạng thái NotReady do chưa cấu hình networking
    - Install Calico in your cluster
        1. Install the Tigera Operator and custom resource definitions
        `kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.3/manifests/tigera-operator.yaml` 
        2. Install Calico by creating the necessary custom resources.
        `kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.3/manifests/custom-resources.yaml` 
        3. Monitor the deployment by running the following command: `watch kubectl get tigerastatus`
        4. Monitor network traffic in Calico Whisker: `kubectl port-forward -n calico-system service/whisker 8081:8081` 
            
            January 5, 2026 
            
            - rule allow all engress
            
            ```yaml
            apiVersion: projectcalico.org/v3
            kind: NetworkPolicy
            metadata:
              name: allow-egress
              namespace: quickstart
            spec:
              selector: run == 'access'
              types:
              - Egress
              egress:
              - action: Allow
            
            ```
            
            - rule allow ingress đi vào mysql từ backend
            
            ```yaml
            apiVersion: projectcalico.org/v3                                       kind: NetworkPolicy
            metadata:
              name: allow-backend-to-mysql
              namespace: quickstart
            spec:
              selector: app == 'mysql'
              types:
              - Ingress
              ingress:
              - action: Allow
                source:
                  selector: app == 'backend'  
            ```
            
            - rule allow ingress đi từ vào backend từ frontend
            
            ```yaml
            apiVersion: projectcalico.org/v3                                       kind: NetworkPolicy
            metadata:
              name: allow-backend-to-mysql
              namespace: quickstart
            spec:
              selector: app == 'backend'
              types:
              - Ingress
              ingress:
              - action: Allow
                source:
                  selector: app == 'frontend'  
            ```