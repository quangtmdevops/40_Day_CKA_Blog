# Day18:

## Task 18/40

### Task details November 29, 2025

1. 
- Login to your cluster and create a pod with the image name as [registry.k8s.io/busybox](http://registry.k8s.io/busybox)
    - `k run pod-busybox --image=busybox --dry-run=client -o=yaml > pod.yaml`
- use the below command for the container
`touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600` → ✅
    - edit pod.yaml and apply with —force flag:
        
        ```jsx
        apiVersion: v1                                                                                                                         │
        kind: Pod                                                                                                                              │
        metadata:                                                                                                                              │
          labels:                                                                                                                              │
            run: pod-busybox                                                                                                                   │
          name: pod-busybox                                                                                                                    │
        spec:                                                                                                                                  │
          containers:                                                                                                                          │
          - image: busybox                                                                                                                     │
            name: pod-busybox                                                                                                                  │
            resources: {}                                                                                                                      │
            command: ["/bin/sh"]                                                                                                               │
            args: ["-c", "touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600"]                                                        │
          dnsPolicy: ClusterFirst                                                                                                              │
          restartPolicy: Always                                                                                                                │
        status: {}
        ```
        
        we also use this type for using command:
        
        ```jsx
        apiVersion: v1                                                                                                                         │
        kind: Pod                                                                                                                              │
        metadata:                                                                                                                              │
          labels:                                                                                                                              │
            run: pod-busybox                                                                                                                   │
          name: pod-busybox                                                                                                                    │
        spec:                                                                                                                                  │
          containers:                                                                                                                          │
          - image: busybox                                                                                                                     │
            name: pod-busybox                                                                                                                  │
            resources: {}                                                                                                                      │
            args:
            - /bin/sh
            - -c
            - touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600                                                        │
          dnsPolicy: ClusterFirst                                                                                                              │
          restartPolicy: Always                                                                                                                │
        status: {}
        ```
        
- create a livenessprobe that executes the command `cat /tmp/healthy` after every 5 seconds, the first check should be after 5 seconds
    - Pod được tạo sẽ tự động tạo file healthy → Sau 30s sẽ xóa file healthy đó.
    - initialDelaySeconds=5, sau 5s đầu tiên, LivenessProbe sẽ liên tục check xem Pod có thỏa mãn điều kiện hay không (check mỗi 5s) → nếu không thỏa mã điều kiện thì cho báo FAIL và RESTART Pod.
    
    ```jsx
    apiVersion: v1                                                                                                                         │
    kind: Pod                                                                                                                              │
    metadata:                                                                                                                              │
      labels:                                                                                                                              │
        run: pod-busybox                                                                                                                   │
      name: pod-busybox                                                                                                                    │
    spec:                                                                                                                                  │
      containers:                                                                                                                          │
      - image: busybox                                                                                                                     │
        name: pod-busybox                                                                                                                  │
        resources: {}                                                                                                                      │
        args:
        - /bin/sh
        - -c
        - touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600                                                        │
        livenessProbe:
          exec:
            command:
            - cat
            - /tmp/healthy
          initialDelaySeconds: 5
          periodSeconds: 5    
      dnsPolicy: ClusterFirst                                                                                                              │
      restartPolicy: Always                                                                                                                │
    status: {}
    ```
    
- create another pod with the image name as [`registry.k8s.io/e2e-test-images/agnhost:2.40`](http://registry.k8s.io/e2e-test-images/agnhost:2.40) December 6, 2025 → not found it
- add the liveness and readiness probes that perform health checks on port 8080 on the path /healthz , the checks should start after 5 seconds for every 10 seconds
    - → Skip

## Note:

### I. Health Probes

- giúp đảm bảo Pod chắc chắn chạy đúng

### II. **Type of health probes**

- liveness: kiểm tra container còn sống hay bị treo
    - nếu fail → restart container
    - dùng để phát hiện deadlock, treo, leak memory
- readness: kiểm tra xem container đã sẵn sàng phục vụ traffic hay chưa.
    - nếu fail → Pod bị gỡ khỏi Service Endpoint, ngừng nhận traffic.
    - không restart container
- starup: dùng cho các ứng dụng khởi động chậm
    - trong thời gian starupProbe đang chạy →liveness và readiness sẽ bị disable
    - startupProbe thành công thì Kubernetes mới bắt đầu dùng liveness và readiness
- periodSeconds: mỗi bao lâu thì sẽ chạy lại probe
- timeoutSeconds: timeout cho mỗi lần probe
- initialDelaySeconds: chờ bao lâu sau khi container start mới chạy probe
- failureThreshold: fail lần thứ n thì sẽ coi là thất bại
- successThreshold: pass ần thứ n thì sẽ coi là thành công
- terminationGracePeriodSeconds: timeout khi kill pod sau khi probe fail