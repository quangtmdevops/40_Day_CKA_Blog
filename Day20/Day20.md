# Day20: How SSL/TLS work?

## Task 20/40

In this exercise, you will explore config maps, secrets and environment variables

### Task details

1. No tasks

## Note: December 21, 2025

### I. Cơ chế Symmetric encryption - mã hóa đối xứng:

- người gửi dùng 1 secret key để mã hóa
- người gửi chia sẻ secret key cho người nhận
- người nhận dùng key đó để giải mã

### II. Cơ chế AssSymmetric encryption - mã hóa bất đối xứng:

- người nhận tạo ra cặp khóa private - public key
- công khai khóa public key
- người gửi sẽ lấy public key của người nhận để mã hóa
- vậy nên cho private key tương ứng mới có thể giải mã để giải mã

### III. Cơ chế Hybrid encryption - **kết hợp mã hóa bất đối xứng và đối xứng**:

- người nhận tạo cặp khóa private - public key
- gửi gửi tạo 1 symmectric key ngẫu nhiên - hay còn gọi là session key
- người gửi dùng symmectric key để mã hóa dữ liệu → sau đó dùng public key để mã hóa symmetric key
- người gửi sẽ gửi:
    - symmetric key đã mã hóa
    - dữ liệu đã mã hóa cho người nhận