# Day21: Manage TLS Certificate

## Task 21/40 December 21, 2025

In this exercise, you to work with TLS certificates in Kubernetes

### Task details

1. Create a CertificateSigningRequest for learner and set the expiration date to 1 week
    
    To generate a key file: `openssl genrsa -out learner.pem 2048` 
    
    To generate a csr file: `openssl req -new -key learner.key -out learner.csr -subj "/CN=quangtm”`
    
2. Make sure to use the encoded value of csr in the request field
    
    Encode the value of csr file: `cat learner.csr | base64 | tr -d "\\n”`
    
3. Approve the csr
    
    ```jsx
    apiVersion: certificates.k8s.io/v1
    kind: CertificateSigningRequest
    metadata:
      name: my-app-csr # A unique name for the request
    spec:
      request: <base64-encoded-csr-data-here>
      signerName: kubernetes.io/kube-apiserver-client # Or other signer, like cert-manager's
      expirationSeconds: 604800
      usages:
        - client auth
    ```
    
    `kubectl certificate approve <certificate-signing-request-name>`
    
4. Retrieve the certificate from the CSR
    
    `k get csr`
    
5. Export the issued certificate from the CertificateSigningRequest to a yaml
    
    `kubectl get csr learner -o yaml > learner-csr-issued.yaml`
    
6. Redirect the certificate value to learner.crt file after decoding it
    
    ```jsx
    echo "" | base64 --decode > learner.crt
    ```
    

## Note: December 21, 2025

### Các bước tạo cer:

1. tạo private key
2. tạo file csr từ private key
3. tạo file yaml với request là nội dung file csr được encode
4. approve csr vừa tạo
5. lưu lại cert thu được sau khi approve