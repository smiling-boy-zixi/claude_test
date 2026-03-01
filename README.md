# Voice Notes Worktree

语音笔记工作空间项目，用于管理和处理语音笔记。

## 项目用途

本项目提供一个语音笔记管理工作空间，支持：

- 语音录制与存储
- 多种音频格式支持（webm, mp3, wav）
- 本地存储管理
- 可扩展的API接口

## 快速开始

### 环境准备

1. 复制环境变量配置文件：
   ```bash
   cp .env.example .env
   ```

2. 根据实际需求修改 `.env` 中的配置项

### 启动项目

1. 安装依赖：
   ```bash
   bash scripts/install-deps.sh
   ```

2. 启动服务：
   ```bash
   # 使用 Python 简易服务器
   python3 -m http.server 3000

   # 或使用 Node.js 服务器
   npx serve -p 3000
   ```

3. 打开浏览器访问 `http://localhost:3000`

## 目录结构

```
.
├── index.html          # 项目入口页面
├── .env.example        # 环境变量配置模板
├── .gitignore          # Git 忽略规则
├── .prettierrc         # 代码格式化配置
├── scripts/            # 脚本目录
│   ├── check-tasks.js  # 任务检查脚本
│   ├── install-deps.sh # 依赖安装脚本
│   └── list-tasks.js   # 任务列表脚本
├── generated/          # 产出文档目录
├── test/               # 测试目录
└── README.md           # 项目说明文档
```

## 配置说明

主要环境变量说明：

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| PORT | 服务端口 | 3000 |
| ENVIRONMENT | 运行环境 | development |
| MAX_RECORDING_DURATION | 最大录制时长(ms) | 60000 |
| STORAGE_TYPE | 存储类型 | local |
| UPLOAD_PATH | 上传文件路径 | ./uploads |

更多配置请参考 `.env.example` 文件。

## 许可证

MIT License