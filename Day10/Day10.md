# Day10

## Task 10/40

In this exercise, you will explore namespaces in depth by creating multiple Kubernetes resources.

### Task details

- Create two namespaces and name them ns1 and ns2
    - `k create namespace ns1`
    - `k create namespace ns2`
- Create a deployment with a single replica in each of these namespaces with the image as nginx and name as deploy-ns1 and deploy-ns2, respectively
    - `k create deploy deploy-ns1 --namespace ns1 --image nginx --port 80`
    - `k create deploy deploy-ns2 --namespace ns2 --image nginx --port 80`
- Get the IP address of each of the pods (Remember the kubectl command for that?)
    - `k get po -n ns1 -o wide`
    - `k get po -n ns2 -o wide`
- Exec into the pod of deploy-ns1 and try to curl the IP address of the pod running on deploy-ns2
    - `k exec -it deploy-ns1-dbfb9c97c-pv7cg -- sh -n ns1`
    - `curl 10.244.1.13:80`
        - the result is: “Welcome to nginx”
- Your pod-to-pod connection should work, and you should be able to get a successful response back.
- Now scale both of your deployments from 1 to 3 replicas.
    - `k scale deploy/deploy-ns1 --replicas=3 -n ns1`
    - `k scale deploy/deploy-ns2 --replicas=3 -n ns2`
- Create two services to expose both of your deployments and name them svc-ns1 and svc-ns2
    - `k create service clusterip  svc-ns1 -n ns1 --tcp=8081:80`
    - `k create service clusterip  svc-ns2 -n ns2 --tcp=8082:80`
- exec into each pod and try to curl the IP address of the service running on the other namespace.
    - lấy IP của Service clusterip:
        - `k get svc -n ns1 -o wide`
    - exec pod
        - `k exec -it pod/deploy-ns1-dbfb9c97c-gdcsb -n ns1 -- sh`
    - curl:
        - `curl 10.96.78.225:8082`
        - FAILS: NO RESULT????
    - TROUBLESHOOTING:
        - kiểm tra endpoint của service:
            - `k get ep -n ns2`
            - nhận thấy endpoint đang là `None`
            - → service đang không redirect về Pod
            - → selector của service đang không đúng → kiểm tra: `k describe svc/svc-ns2 -n ns2`
    - FIXING:
        - kiểm tra labels của Deployment:
            - `k describe deploy/deploy-ns2 -n ns2`
            - edit lại phần selector của service
                - `k edit svc/svc-ns2 -n ns2`
        - thực hiện exec vào pod của deployment ns1 và curl IP của service ns2 → “Welcome to nginx”
- This curl should work.
- Now try curling the service name instead of IP. You will notice that you are getting an error and cannot resolve the host.
    - `curl [http://svc-ns2.ns2:8082](http://svc-ns2.ns2:8082/)` this work.
- Now use the FQDN of the service and try to curl again, this should work.
    - `curl [http://svc-ns2.ns2.svc.cluster.local:8082](http://svc-ns2.ns2.svc.cluster.local:8082/)` this also work too.
- In the end, delete both the namespaces, which should delete the services and deployments underneath them.
    - `k delete ns/ns1`
    - `k delete ns/ns2`
1. **Share your learnings**: Document your key takeaways and insights in a blog post and social media update
    - khi không chỉ rõ name space khi tạo resouce → resource đó sẽ thuộc default namespace
    - các Pod khác namespace vẫn có thể giao tiếp với nhau bằng địa chỉ IP của chính chúng
    - khi tạo Cluster, các namespace được tạo mặc định:
        - `k get ns`
            
            ```bnf
            default              
            kube-node-lease
            kube-public        
            kube-system 
            local-path-storage
            ```
            
    - xem toàn bộ resource nằm trong namespace:
        - `k get all --namespace=<namespace_name>`
        - `k get all --namespace default`
    - cách để tạo namespace:
        - viết file.yaml
            
            ```bnf
            apiVersion: v1
            kind: Namespace
            metadata:
              name: production
            ```
            
        - run command:
        `kubectl create namespace NAME [--dry-run=server|client|none]`
    - cách để exec vào 1 Pod
        
        `k exec -it <Pod_name> -- sh -n <namespace_name>`
        

## Blog Post Focus 📝

- **Clarity is essential**: Write your blog post clearly and concisely, making it easy for anyone to grasp the concepts, regardless of their prior Kubernetes experience.

## Note