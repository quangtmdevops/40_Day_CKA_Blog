# Day17: AutoScalling

## Task 17/40

In this exercise, you will explore Kubernetes Autoscaling , HPA, VPA, Cluster Autoscaling etc

### Task details

1. Perform the steps as per the video demo , commands and yaml given in the readme file
    - `k apply -f deploy.yaml`
        
        ```bnf
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: php-apache
        spec:
          selector:
            matchLabels:
              run: php-apache
          template:
            metadata:
              labels:
                run: php-apache
            spec:
              containers:
              - name: php-apache
                image: registry.k8s.io/hpa-example
                ports:
                - containerPort: 80
                resources:
                  limits:
                    cpu: 500m
                  requests:
                    cpu: 200m
        ---
        apiVersion: v1
        kind: Service
        metadata:
          name: php-apache
          labels:
            run: php-apache
        spec:
          ports:
          - port: 80
          selector:
            run: php-apache
        ```
        
    - `kubectl autoscale deployment php-apache --cpu=50 --min=1 --max=10`
    - `k get hpa`
    
    ```bnf
    apiVersion: autoscaling/v2
    kind: HorizontalPodAutoscaler
    metadata:
      name: php-apache
    spec:
      scaleTargetRef:
        apiVersion: apps/v1
        kind: Deployment
        name: php-apache
      minReplicas: 1
      maxReplicas: 10
      metrics:
      - type: Resource
        resource:
          name: cpu
          target:
            type: Utilization
            averageUtilization: 50
    ```
    

## Note:

### Horizonal:

- scale theo chiều ngang → khi lượng CPU/RAM đạt ngưỡng → tăng số lượng Pod

### Vertical:

- scale theo chiều dọc - khi lượng CPU/RAM đạt ngưỡng → tăng cấu hình của phần cứng