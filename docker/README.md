# Podman 部署指南

## 快速开始

```bash
# 构建并运行（默认使用 podman）
./docker/build.sh run

# 访问博客
# http://localhost:4321
```

## 手动操作

### 构建镜像

```bash
# 方式1: 使用 build.sh 脚本
CONTAINER_RUNTIME=podman ./docker/build.sh build

# 方式2: 直接使用 podman
podman build -f docker/Dockerfile -t blog:latest .

# 方式3: 使用 buildah
buildah bud -f docker/Dockerfile -t blog:latest .
```

### 运行容器

```bash
# 后台运行
podman run -d --name blog -p 4321:80 blog:latest

# 查看日志
podman logs -f blog

# 停止容器
podman stop blog

# 删除容器
podman rm blog
```

### 镜像管理

```bash
# 查看镜像
podman images

# 导出镜像为 tar 包
podman save -o blog.tar blog:latest

# 加载镜像
podman load -i blog.tar

# 推送到 registry（如 docker.io）
podman tag blog:latest docker.io/yourname/blog:latest
podman push docker.io/yourname/blog:latest
```

## 使用 Quadlet（推荐）

Podman Quadlet 允许将容器作为 systemd 服务管理：

```bash
# 1. 复制 quadlet 文件
mkdir -p ~/.config/containers/systemd/
cp docker/blog.container ~/.config/containers/systemd/

# 2. 重载 systemd
systemctl --user daemon-reload

# 3. 启动服务
systemctl --user start blog

# 4. 查看状态
systemctl --user status blog

# 5. 开机自启
systemctl --user enable blog

# 6. 查看日志
journalctl --user -u blog
```

## Podman vs Docker 命令对照

| 功能 | Docker | Podman |
|------|--------|--------|
| 构建镜像 | docker build | podman build |
| 运行容器 | docker run | podman run |
| 查看容器 | docker ps | podman ps |
| 查看镜像 | docker images | podman images |
| 查看日志 | docker logs | podman logs |
| 进入容器 | docker exec -it | podman exec -it |
| 停止容器 | docker stop | podman stop |

## Podman 特有功能

### Rootless 模式（无需 root 权限）
Podman 默认以 rootless 模式运行，更安全：

```bash
# 无需 sudo 即可运行
podman run -d --name blog -p 4321:80 blog:latest
```

### Pod 管理（类似 K8s Pod）
```bash
# 创建 pod
podman pod create --name blog-pod -p 4321:80

# 在 pod 中运行容器
podman run -d --pod blog-pod --name blog blog:latest

# 查看 pod
podman pod ps
```

### 生成 Kubernetes YAML
```bash
# 导出为 Kubernetes 部署配置
podman generate kube blog > kube-deployment.yaml
```