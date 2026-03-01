#!/bin/bash

# Voice Notes Worktree - 项目启动脚本
# 实现一键启动，包含环境检查功能

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查命令是否存在
check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# 环境检查
check_environment() {
    log_info "开始环境检查..."

    local has_error=0

    # 检查 .env 文件
    if [ ! -f "$PROJECT_ROOT/.env" ]; then
        log_warning ".env 文件不存在，正在从 .env.example 复制..."
        if [ -f "$PROJECT_ROOT/.env.example" ]; then
            cp "$PROJECT_ROOT/.env.example" "$PROJECT_ROOT/.env"
            log_success "已创建 .env 文件"
        else
            log_error ".env.example 文件不存在，请手动创建 .env 文件"
            has_error=1
        fi
    else
        log_success ".env 文件已存在"
    fi

    # 检查端口配置
    local port=${PORT:-3000}
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        log_error "端口 $port 已被占用"
        log_info "请修改 .env 中的 PORT 配置或关闭占用端口的进程"
        has_error=1
    else
        log_success "端口 $port 可用"
    fi

    # 检查必要的目录
    local upload_path=${UPLOAD_PATH:-"./uploads"}
    if [ ! -d "$PROJECT_ROOT/$upload_path" ]; then
        log_info "创建上传目录: $upload_path"
        mkdir -p "$PROJECT_ROOT/$upload_path"
    fi

    if [ ! -d "$PROJECT_ROOT/generated" ]; then
        log_info "创建产出目录: generated"
        mkdir -p "$PROJECT_ROOT/generated"
    fi

    return $has_error
}

# 检查运行依赖
check_dependencies() {
    log_info "检查运行依赖..."

    # 检查是否有可用的HTTP服务器
    local server_found=0

    if check_command python3; then
        log_success "找到 python3"
        server_found=1
    fi

    if check_command node; then
        log_success "找到 node"
        server_found=1
    fi

    if check_command npx; then
        log_success "找到 npx"
        server_found=1
    fi

    if [ $server_found -eq 0 ]; then
        log_error "未找到可用的HTTP服务器，请安装 python3 或 node.js"
        return 1
    fi

    return 0
}

# 启动服务器
start_server() {
    local port=${PORT:-3000}

    log_info "正在启动服务器..."

    cd "$PROJECT_ROOT"

    # 优先使用 Python 服务器
    if check_command python3; then
        log_success "使用 Python HTTP 服务器启动"
        log_info "服务地址: http://localhost:$port"
        log_info "按 Ctrl+C 停止服务器"
        python3 -m http.server $port
    # 备选使用 npx serve
    elif check_command npx; then
        log_success "使用 npx serve 启动"
        log_info "服务地址: http://localhost:$port"
        log_info "按 Ctrl+C 停止服务器"
        npx serve -p $port
    else
        log_error "无法启动服务器"
        exit 1
    fi
}

# 主函数
main() {
    echo "========================================"
    echo "  Voice Notes Worktree - 启动脚本"
    echo "========================================"
    echo ""

    # 加载环境变量
    if [ -f "$PROJECT_ROOT/.env" ]; then
        log_info "加载环境变量..."
        export $(grep -v '^#' "$PROJECT_ROOT/.env" | xargs)
    fi

    # 环境检查
    if ! check_environment; then
        log_error "环境检查失败，请解决上述问题后重试"
        exit 1
    fi

    # 依赖检查
    if ! check_dependencies; then
        log_error "依赖检查失败，请安装必要的依赖后重试"
        exit 1
    fi

    echo ""
    log_success "所有检查通过，准备启动..."
    echo ""

    # 启动服务器
    start_server
}

# 执行主函数
main "$@"