# Day03

## Note

1. Install Docker
    
    Bạn có thể Install Docker như hướng dẫn trên github, hoặc có thể [cài đặt Docker nhanh](https://github.com/docker/docker-install) bằng lệnh sau:
    
    ```bash
    curl -fsSL https://get.docker.com | sh
    ```
    
2. Các bước để build một React Project
    - Đọc file package.json
    - Chạy lệnh `npm install` để install các dependency cần thiết cho project
    - Chạy lệnh `npm run build` để build ra một folder dist/build
    - Khi đã có folder dist/build thì sử dụng file tĩnh `/usr/share/nginx/html` để chạy web.

## Task

1. **Task Details**
    - Either clone an existing app from Github or use your application repository and dockerize the project
    - Document the process in a step-by-step blog
        - search: how to build react app → `npm install`
        - search: how to run react app → read `package.json` → run `npm start`
        - create Dockerfile
            
            ```bnf
            FROM node:22-alpine AS build
            
            WORKDIR /app
            
            COPY package.json package-lock.json ./
            
            RUN npm install --production
            
            COPY . .
            
            RUN npm run build
            
            FROM nginx:alpine AS production
            
            COPY --from=build /app/build /usr/share/nginx/html
            
            EXPOSE 80
            
            # Run Nginx in the foreground
            CMD ["nginx", "-g", "daemon off;"]
            ```
            
        - build Dockerfile and run this Image
    - Write the benefits of docker multistage build and review the doc for best practices of writing a Dockerfile --> [https://docs.docker.com/build/building/best-practices/](https://docs.docker.com/build/building/best-practices/)
    - Also explore `docker init` command
        - in Day02/README.md
    - Write all the commands and their respective explanation
        - `docker build -t t .`
            - lệnh này sẽ đọc `Dockerfile` tại folder hiện tại và build thành một image có tag là `t`
        - `docker run —name ta -dp 3001:80 t`
            - lệnh này sẽ chạy container
            - cờ `—name` : để khai báo tên cho container
            - cờ `-d` : khai báo container chạy với chế độ detach
            - cờ `-p` : khai bỏ port trên `local:container`
            - `t` : là tên của image build ở lệnh bên trên
    - Benifit of using multi stage?
        - Giúp Image có kích thước nhẹ hơn
        - Quá trình push/pull image sẽ nhanh hơn
        - Đối với project này: giảm từ khoảng 450MB xuống còn 50MB