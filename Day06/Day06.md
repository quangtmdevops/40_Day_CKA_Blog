# Day06

## Task 6/40

1. **Task Details**
- Document your learnings from the video
    - Video giới thiệu về:
        - cách cài đặt Kubenetes và các công cụ cần thiết
            - Cài đặt Kubenetes trên local bằng: kind
                - [https://kind.sigs.k8s.io/docs/user/quick-start/#installation](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
            - Cài đặt Kubectl
                - [https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux)
            - Dùng `kind` để tạo cluster với yaml:
                - `kind create cluster --config single-controller-multi-worker.yaml --name k8s-cka-cluster2`
            - Cách sử dụng kubectl để:
                - Để list cluster:
                    - `kubectl config get-contexts`
                - list các node trong cluster
                    - `kubectl get nodes`
                - đổi context giữa các cluster
                    - `kubectl config use-context my-cluster-name`
                - 
- Following the [doc](https://kind.sigs.k8s.io/) install a single node kind cluster on your local machine with Kubernetes version 1.34
    - done
- Delete the cluster created in the above step
    - `k config delete-context minikube`
- Run `docker ps` command to verify that all nodes are running as containers.
    - có 1 container là Control Plane
    - có 3 container là Worker Node

## Note