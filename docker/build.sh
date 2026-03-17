#!/bin/bash
# 自动构建脚本 - 构建Astro博客并创建容器镜像
# 支持 docker 和 podman

set -e

# 配置
IMAGE_NAME="blog"
IMAGE_TAG="latest"
CONTAINER_NAME="blog"

# 容器运行时 (docker 或 podman)
CONTAINER_RUNTIME="${CONTAINER_RUNTIME:-podman}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查依赖
check_dependencies() {
    log_info "检查依赖..."

    if ! command -v bun &> /dev/null; then
        log_error "bun 未安装，请先安装 bun"
        exit 1
    fi

    # 检测可用的容器运行时
    if [ "$CONTAINER_RUNTIME" = "auto" ] || [ -z "$CONTAINER_RUNTIME" ]; then
        if command -v podman &> /dev/null; then
            CONTAINER_RUNTIME="podman"
        elif command -v docker &> /dev/null; then
            CONTAINER_RUNTIME="docker"
        else
            log_error "未找到 docker 或 podman，请先安装其中之一"
            exit 1
        fi
    fi

    if ! command -v "$CONTAINER_RUNTIME" &> /dev/null; then
        log_error "$CONTAINER_RUNTIME 未安装"
        exit 1
    fi

    log_info "使用容器运行时: $CONTAINER_RUNTIME"
    log_info "依赖检查通过"
}

# 构建Astro项目
build_astro() {
    log_info "开始构建 Astro 项目..."

    # 回到项目根目录
    cd "$(dirname "$0")/.."

    # 安装依赖（如果需要）
    if [ ! -d "node_modules" ]; then
        log_info "安装依赖..."
        bun install
    fi

    # 构建
    log_info "执行 bun run build..."
    bun run build

    if [ ! -d "dist" ]; then
        log_error "构建失败：dist 目录不存在"
        exit 1
    fi

    log_info "Astro 项目构建完成"
}

# 构建容器镜像
build_image() {
    log_info "开始构建容器镜像..."

    cd "$(dirname "$0")/.."

    $CONTAINER_RUNTIME build -f docker/Dockerfile -t ${IMAGE_NAME}:${IMAGE_TAG} .

    if [ $? -eq 0 ]; then
        log_info "镜像构建成功: ${IMAGE_NAME}:${IMAGE_TAG}"
    else
        log_error "镜像构建失败"
        exit 1
    fi
}

# 运行容器
run_container() {
    log_info "启动容器..."

    # 停止并删除已存在的容器
    if $CONTAINER_RUNTIME ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        log_warn "容器 ${CONTAINER_NAME} 已存在，正在停止并删除..."
        $CONTAINER_RUNTIME stop ${CONTAINER_NAME} 2>/dev/null || true
        $CONTAINER_RUNTIME rm ${CONTAINER_NAME} 2>/dev/null || true
    fi

    $CONTAINER_RUNTIME run -d --name ${CONTAINER_NAME} -p 4321:80 ${IMAGE_NAME}:${IMAGE_TAG}

    if [ $? -eq 0 ]; then
        log_info "容器启动成功！"
        log_info "访问地址: http://localhost:4321"
    else
        log_error "容器启动失败"
        exit 1
    fi
}

# 停止容器
stop_container() {
    log_info "停止容器..."

    if $CONTAINER_RUNTIME ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        $CONTAINER_RUNTIME stop ${CONTAINER_NAME}
        log_info "容器已停止"
    else
        log_warn "容器 ${CONTAINER_NAME} 未在运行"
    fi
}

# 清理
clean() {
    log_info "清理..."

    # 停止并删除容器
    if $CONTAINER_RUNTIME ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        $CONTAINER_RUNTIME stop ${CONTAINER_NAME} 2>/dev/null || true
        $CONTAINER_RUNTIME rm ${CONTAINER_NAME} 2>/dev/null || true
    fi

    # 删除镜像
    if $CONTAINER_RUNTIME images --format '{{.Repository}}:{{.Tag}}' | grep -q "^${IMAGE_NAME}:${IMAGE_TAG}$"; then
        $CONTAINER_RUNTIME rmi ${IMAGE_NAME}:${IMAGE_TAG}
    fi

    log_info "清理完成"
}

# 显示帮助
show_help() {
    echo "用法: $0 [命令]"
    echo ""
    echo "环境变量:"
    echo "  CONTAINER_RUNTIME  容器运行时 (docker/podman)，默认: podman"
    echo ""
    echo "命令:"
    echo "  build     构建Astro项目并创建镜像（默认）"
    echo "  run       构建镜像并启动容器"
    echo "  stop      停止容器"
    echo "  clean     清理容器和镜像"
    echo "  help      显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 build                    # 使用 podman 构建项目"
    echo "  CONTAINER_RUNTIME=docker $0  # 使用 docker 构建"
    echo "  $0 run                       # 构建并启动容器"
}

# 主函数
main() {
    local command=${1:-build}

    case $command in
        build)
            check_dependencies
            build_astro
            build_image
            ;;
        run)
            check_dependencies
            build_astro
            build_image
            run_container
            ;;
        stop)
            stop_container
            ;;
        clean)
            clean
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $command"
            show_help
            exit 1
            ;;
    esac
}

main "$@"