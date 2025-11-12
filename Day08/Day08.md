# Day08

## Task 8/40

In this exercise, you will create a Deployment with multiple replicas. After inspecting the Deployment, you will update its Pod template. You will also be able to use the rollout history to roll back to a previous revision.

> [!NOTE]
If you do not already have a Kubernetes cluster, you can create a local Kubernetes cluster by following Day06 Video
> 

## Replicaset

- Create a new Replicaset based on the nginx image with 3 replicas
    
    November 12, 2025 
    
    - we have to create yaml file first
    - run `kubectl explain rs` to get information: apiVersion, kind
    
    ```bnf
    apiVersion: apps/v1
    kind: ReplicaSet
    metatada:
      name: nginx-rs
      labels:
        env: demo
    spec:
    	replicas: 3
      selectors:
        matchLabels:
          env: demo
      template:
        metadata:
          labels:
            env: demo
        spec:
          containers:
          - image: nginx
            name: nginx
    ```
    
    - run `kubectl apply -f <file.yaml>`
- Update the replicas to 4 from the YAML
    
    November 12, 2025 
    
    - Options 1:
        - edit the file.yaml, modify the replicas to 4
        - run `kubectl apply -f <file.yaml>`
    - Option 2:
        - edit directly the ReplicaSet by command:
            - `kubectl edit rs/nginx-rs`
            - edit the number of replicas
    - Option 3:
        - scale the number of replicas by command:
            - `kubectl scale --replicas=3 rs/nginx-rs`
- Update the replicas to 6 from the command line
    
    November 12, 2025 
    
    - scale the number of replicas by command:
        - `kubectl scale --replicas=6 rs/nginx-rs`

## Deployment

1. Create a Deployment named `nginx` with 3 replicas. The Pods should use the `nginx:1.23.0` image and the name `nginx`. The Deployment uses the label `tier=backend`. The Pod template should use the label `app=v1`.
    
    November 12, 2025 
    
    - deploy.yaml
        
        ```bnf
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: nginx
          labels:
            tier: backend
        spec:
          replicas: 3
          selector:
            matchLabels:
              app: v1
          template:
            metadata:
              labels:
                app: v1
            spec:
              containers:
              - name: nginx
                image: nginx:1.23.0
        ```
        
    - apply the file
        - `kubectl apply -f deploy.yaml`
    - check deployments:
        - `kubectl get deploy` or `kubectl get deployments`
2. List the Deployment and ensure the correct number of replicas is running.
    - check deployments:
        - `kubectl get deploy` or `kubectl get deployments`
3. Update the image to `nginx:1.23.4`.
    - choose one of these commands:
        - `kubectl set image deploy/nginx <container_name1>=<new_image1> <container_name2>=<new_image2>`
        - `kubectl set image -f deploy.yaml <container_name1>=<new_image1> <container_name2>=<new_image2>`
        - `kubectl set image deploy/nginx nginx=nginx:1.24.0`
    - add the change-cause after update image:
        - `kubectl annotate deploy/nginx [kubernetes.io/change-cause=](http://kubernetes.io/change-cause=)"text" --overwrite`
4. Verify that the change has been rolled out to all replicas.
    - `kubectl describe deploy/nginx`
5. Assign the change cause "Pick up patch version" to the revision.
    - Rollback Pod version
        - `kubectl rollout undo deploy/nginx --to-revision=2`
6. Scale the Deployment to 5 replicas.
    - scale replicas to 5
        - `kubectl scale deploy/nginx --replicas=5`
7. Have a look at the Deployment rollout history.
    - `kubectl rollout history deploy/nginx`
8. Revert the Deployment to revision 1.
    - `kubectl rollout undo deploy/nginx --to-revision=1`
9. Ensure that the Pods use the image `nginx:1.23.0`.

## Troubleshooting the issue

1. Apply the below YAML and fix the issue with it

```
apiVersion: v1
kind:  Deployment
metadata:
  name: nginx-deploy
  labels:
    env: demo
spec:
  template:
    metadata:
      labels:
        env: demo
      name: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
  replicas: 3
  selector:
    matchLabels:
      env: demo

```

Modify:

- apiVersion: v1 → apiVersion: apps/v1
1. Apply the below YAML and fix the issue with it

```
apiVersion: v1
kind:  Deployment
metadata:
  name: nginx-deploy
  labels:
    env: demo
spec:
  template:
    metadata:
      labels:
        env: demo
      name: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        ports:
        - containerPort: 80
  replicas: 3
  selector:
    matchLabels:
      env: dev
```

Modify:

- apiVersion: v1 → apiVersion: apps/v1
- matchLabels:
      env: dev → env: demo
1. **Share your learnings**: Document your key takeaways and insights in a blog post and social media update
    1. Difinition
        1. Replication Controller
            - có nhiệm vụ: đảm bảo các Replicas đang running
            - đảm bảo application mà Replication Controller đang quản lý không bị crash
            - nó cũng nhận request từ bên ngoài và đóng vai trò Load Balacing: redirect tới các Pod mà nó quản lý
            - có các thuật toán Load Balancing
        2. ReplicaSet
            - là một phiên bản nâng cấp của Replication Controller
            - kế thừa các tính năng của Replication Controller
            - ReplicaSet có thêm khả năng manage những resouce bất kỳ, bằng cách sử dung thêm thuộc tính `selector/matchLabel` để chọn resouce có Label tương ứng.
        3. Deployment
            - là một lớp bọc ngoài, chứa ReplicaSet
            - khi tạo Deployment → nó sẽ tạo thêm 1 lớp ReplicaSet bên trong
            - có thêm tính năng:
                - tự đánh version cho Pod
                - Rollback về Version được chỉ định
    2. Hand-ons
        1. Dùng lệnh `kubectl explain` xem giải thích về resource nào đó
        2. ReplicaSet
            - bạn không thể trực tiếp tạo ReplicaSet từ command, bạn cần viết file yaml và chạy lệnh `kubectl apply`
        3. Deployment
        - Khi có apply file.yaml có nội dung giống nhau thì K8s sẽ báo deployment unchanged

## Blog Post Focus 📝

- **Clarity is essential**: Write your blog post clearly and concisely, making it easy for anyone to grasp the concepts, regardless of their prior Kubernetes experience.

## Note