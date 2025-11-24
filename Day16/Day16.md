# Day16: Request and Limit

## Task 16/40

### Task details November 24, 2025

- login to your cluster and create a new namespace with the name mem-example: `k create ns demo-metric`
    - `k get ns`
- Install metrics server using the yaml provided in this repo: ✅
- Perform the steps given in the below doc:

[https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/#specify-a-memory-request-and-a-memory-limit](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/#specify-a-memory-request-and-a-memory-limit)

`k top pod memory-demo -n demo-metric`

## Note:

### Request and Limit (giới hạn tài nguyên CPU và RAM cho Pod)

- Request: là lượng resource tối thiểu mà Pod cần để chạy ứng dụng mượt.
- Limits: là lượng resource tối đa mà Pod được sử dụng,
- request và limit là cần thiết khi cấu hình Pod
- giúp giới hạn lượng tài nguyên tối đa mà một Pod được sử dụng
- nếu không giới hạn → Pod sẽ mặc định sử dụng thêm tài nguyên của Node cho đến khi Node cạn tài nguyên → mã lỗi: OOM (out out memories)
- nếu Pod dùng hết tài nguyên được giới hạn → Pod sẽ bị Crash → Mã lỗi: insufficient resources

- Cách cài Add-ons để monitoring cho Node, Pod …
    - Follow this to install: https://github.com/kubernetes-sigs/metrics-server
    - Follow this if has the problem about tls: [Fix “error: Metrics API not available” in Kubernetes | by CloudSpinx Global | Medium](https://medium.com/@cloudspinx/fix-error-metrics-api-not-available-in-kubernetes-aa10766e1c2f)