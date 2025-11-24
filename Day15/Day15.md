# Day15: Node Affinity

## Task 15/40

### Task details November 24, 2025

create a pod with nginx as the image and add the nodeffinity with propertyrequiredDuringSchedulingIgnoredDuringExecution and condition disktype = ssd

- Create  manifest yaml file:  `k run pod-nginx --image=nginx --dry-run=client -o yaml > pod-nginx.yaml`
- add the `affinity` spec:

```bnf
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod-nginx
  name: pod-nginx
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: disktype
            operator: In
            values:
            - ssd
  containers:
  - image: nginx
    name: pod-nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

- check the status of the pod and see why it is not scheduled
    - `k get po`
    - `k describe po/pod-nginx`
        
        > Warning  FailedScheduling  4m23s  default-scheduler  0/4 nodes are available: 1 node(s) had untolerated taint {[node-role.kubernetes.io/control-plane:](http://node-role.kubernetes.io/control-plane:) }, 3 node(s) didn't match Pod's node affinity/selector. no new claims to deallocate, preemption: 0/4 nodes are available: 4 Preemption is not helpful for scheduling.
        > 
- add the label to your worker01 node as distype=ssd and then check the status of the pod
    - check label of node: `kubectl get nodes --show-labels`
    - add label to node: `k label nodes k8s-cka-cluster2-worker disktype=ssd`
- It should be scheduled on worker node 1: ✅
- create a new pod with redis as the image and add the nodeaffinity with property requiredDuringSchedulingIgnoredDuringExecution and condition disktype without any value
    - create manifest: `k run pod-redis --image redis --dry-run=client -o yaml >| pod-redis.yaml`
    - Using `operator: Exists`
- add the label to worker02 node with disktype and no value
    - add label to Node: `k label nodes k8s-cka-cluster2-worker2 disktype=`
    - show label of Nodes: `k get node --show-labels`
- ensure that pod2 should be scheduled on worker02 node
    - chúng ta có thể đổi label của Node 1 đi, giữ nguyên config của → xóa pod đi và apply lại → Pod sẽ nằm ở Node 2
        - command to overwrite label of Node: `k label nodes k8s-cka-cluster2-worker disktype=hdd --overwrite`
        - `k get po -o wide`

## Note:

### Affinity Node

- là để gán điều kiện cho Pod, nhằm chỉ định Node đáp ứng yêu cầu với điều kiện của Pod.
- Affinity được thêm vào Pod, và được check bằng cách kiểm tra Label của Node
- Affinity Node có 2 thuộc tính:
    - **requiredDuringSchedulingIgnoredDuringExecution:** đảm bảo Pod có Affinity match với Label của node thì mới được triển khai. Nếu không có Node match thì pending việc tạo Pod.
    - **preferredDuringSchedulingIgnoredDuringExecution:** Pod có Affinity match với Label của node thì mới được triển khai. Nếu không match thì sẽ ngẫu nhiên triển khai trên 1 Node có đủ tài nguyên.