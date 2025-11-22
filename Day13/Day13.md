# Day13

## Task 13/40

In this exercise, you will explore node selectors, labels and selectors along with static pods

### Task details

- Create a pod and try to schedule it manually without the scheduler. November 22, 2025
    - create nginx-pod.yaml: `k run nginx-pod --image nginx -o yaml > nginx-pod.yaml`
    - edit the `nginx-pod.yaml` , add `nodeName: k8s-cka-cluster2-worker` with the same level as `containers`
    properties.
    - run: `k apply -f nginx-pod.yaml`
    - check the pod on which Node: `k get po -o wide`
    - the result should be: `k8s-cka-cluster2-worker`
- Login to the control plane node and go to the directory of default static pod manifests and try to restart the control plane components
    - `docker exec -it k8s-cka-cluster2-control-plane bash`
    - `cd /etc/kubernetes/manifests`
    - `mv kube-controller-manager.yaml /tmp/`
    - re check: `k get po -n kube-system`
- Create 3 pods with the name as pod1, pod2 and pod3 based on the nginx image and use labels as env:test, env:dev and env:prod for each of these pods respectively.
    - `k run pod1 --image nginx --labels="env=test”`
    - `k run pod2 --image nginx --labels="env=dev”`
    - `k run pod3 --image nginx --labels="env=prod”`
- Then using the kubectl commands, filter the pods that have labels dev and prod.
    - `kubectl get pods -l 'env in (dev,prod)'`
1. **Share your learnings**: Document your key takeaways and insights in a blog post and social media update
2. **Make it public**: Share what you learn publicly on LinkedIn or Twitter.
    - **Tag us and use the hashtag**: Include the following in your post:
        - Tag [@PiyushSachdeva](https://www.linkedin.com/in/piyush-sachdeva) and [@CloudOps Community](https://www.linkedin.com/company/thecloudopscomm) (on both platforms)
        - Use the hashtag **#40daysofkubernetes**
        - **Embed the video**: Enhance your blog post by embedding the video lesson from the Kubernetes series. This will give you visual context and reinforce your written explanations.

## Note

**Note chung:**

- Khi xóa file manifest trong `/etc/kubernetes/manifests` thì component tương ứng sẽ bị xóa (các component hệ thống của Kubernetes nằm ở `kube-system` namespace)
    - thông thường các file manifests của Node được lưu tại `/etc/kubernetes/manifests`
1. Scheduler
    - chịu trách nhiệm checking và monitoring toàn bộ Pod
    - nó quyết định Pod được chạy ở Node nào
    - khi xóa file manifest của scheduler trong `/etc/kubernetes/manifests` , component đó sẽ biến mất → chức năng scheduling của Kubernetes cũng mất → Việc tạo Pod sẽ bị pending do không biết Pod được chỉ định chạy trong Node nào.
2. Static Pod
    - là những Pod được Kubelet tạo ra mặc định khi khởi tạo Control Plane hay Worker Node
    - các Pod này nằm trong namespace `kube-system`
    - thường là: etcd, kube controller manager, kube scheduler, kube api server …
3. Node Selector
    - sử dụng để chỉ ra địa chỉ của Node mà Pod sẽ chạy trên đó  (manually)
    - **`nodeName` Field**: Use this field in the pod specification to specify the node where the pod should run.
    - khi `nodeName` được chỉ ra, Scheduler sẽ bypass Pod đó, trực tiếp thêm Pod vào địa chỉ Node đã khai báo
4. Label and Selector
    - Label: có kiểu `key:value` , sử dụng để filter rất tiện (mục đích chính: query resource dễ dàng)
    - Thêm cờ `--selector` để query theo label