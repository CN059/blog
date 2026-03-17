# 使用 nginx 作为静态文件服务器
FROM docker.io/nginx:alpine

# 复制构建产物到 nginx 目录
COPY dist /usr/share/nginx/html

# 复制 nginx 配置
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]