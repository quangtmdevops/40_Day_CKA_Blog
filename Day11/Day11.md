# Day11

## Task 11/40

In this exercise, you will explore environment variables and multi-container pods in Kubernetes.

### Task details

November 15, 2025 

- Create a multi-container pod as per the demo shown in the video.
    1. create yaml
        
        ```bnf
        apiVersion: v1
        kind: Pod
        metadata:
          name: myapp-container
          labels:
            env: demo
        spec:
          containers:
          - name: myapp-containers
            image: busybox:1.28
            command: ['sh', '-c', 'echo The app is running! && sleep 3600']
            env:
            - name: MYDEVNAME
              value: quangtm123123
          initContainers:
          - name: myapp-init
            image: busybox:1.28
            command: ['sh', '-c', "until nslookup myservice.default.svc.cluster.local; do echo waiting for myservice; sleep 2; done"]
        ```
        
    2. apply yaml: `k apply -f multi-container-pod.yaml` 
    3. we cannot run: `k logs po/myapp-container` because we need to specify the container which we want to show log
    4. show log of a container: `k logs po/myapp-container -c myapp-init`
    5. create new nginx deploy: `k deploy nginx-deploy --port 80 --image image` 
    6. expose a service with the name “*myservice”: `k expose deploy/nginx-deploy --port 80 --name myservice`*
    7. get pod again to check status.
1. **Share your learnings**: Document your key takeaways and insights in a blog post and social media update
    - Thông thường, việc run nhiều hơn 1 container trên 1 pod cho trường hợp:
        - để chạy được ứng dụng thì container chính sẽ cần thêm 1 hoặc nhiều container init
    - khi 1 Pod bị restart thì toàn bộ containers trong Pod cũng restart theo
    - Containers phụ thường là: init/slidecar/helper
    - Một số note khác:
        - command `until` dùng thế nào?
            - **until** được sử dụng để chạy 1 danh sách command cho đến khi có mã code trả về khác 0.
            Lệnh này chủ yếu được sử dụng khi người dùng cần thực thi một tập hợp lệnh cho đến khi một điều kiện được thỏa mãn.
            - syntax: 
            `until COMMANDS; do COMMANDS; done`
        - khi chạy lệnh `k get` thì có thể dùng thêm cờ `-w` để xem realtime

## Note