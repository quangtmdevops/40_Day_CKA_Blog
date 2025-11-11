# Day07

## Task 7/40

1. **Task Details** ☕️
- Document what you learned from the video in a blog, embed the video, and include all the references in the blog.

**Task 1**

- Create a pod using the imperative command and use nginx as the image
- Use this command to:
    - Create a pod with specific image
        - `kubectl run <pod_name> --image <image_name>`
    - Get Pod in default namespace
        - `kubectl get pods`
    - Describe pod
        - `kubectl describe <TYPE> <NAME_PREFIX>`
        - `kubectl describe -f <resource_file>`

**Task2**

- Create the YAML from the nginx pod created in task 1
    - Export the pod resource to yaml output
        - `kubectl get pod <pod-name> -n <namespace> -o yaml > pod-config.yaml`
- Update the pod name in the YAML
    - to update the pod name, we have to delete the exist pod
        - `kubectl delete pod <pod_name>`
        - modify the `name` properties in `metadata`
- Use that YAML to create a new pod with the name nginx-new.
    - Update the new name:
        - `kubectl apply -f <config.yaml>`

**Task3**

- Apply the below YAML and fix the errors, including all the commands that you run during the troubleshooting and the error message

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: test
  name: redis
spec:
  containers:
  - image: rediss
    name: redis
```

- This is the correct YAML
    
    ```jsx
    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        app: test
      name: redis
    spec:
      containers:
        - image: redis
          name: redis
    ```
    

## Note