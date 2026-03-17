# 使用官方 bun 镜像
FROM oven/bun:1 AS base
WORKDIR /app

# 安装依赖阶段
FROM base AS install
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

# 构建阶段
FROM base AS build
COPY --from=install /app/node_modules ./node_modules
COPY . .
RUN bun run build

# 运行阶段
FROM base AS release
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./

ENV HOST=0.0.0.0
ENV PORT=4321

EXPOSE 4321

CMD ["bun", "run", "preview"]