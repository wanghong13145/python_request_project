#!/bin/bash

# OSS文件URL
OSS_URL="http://prod-alphadrive-warehouse-flink-oss.oss-cn-wulanchabu.aliyuncs.com/artifacts/namespaces/warehouse-flink-default/intel_voice_requirements.txt?OSSAccessKeyId=LTAI5tKJsX6FSJgz1S9m9cVE&Expires=1775635660&Signature=MAZysR%2FsHMlxXyCu2wl66NzA4ng%3D"

# 临时文件路径
REQUIREMENTS_FILE="intel_voice_requirements.txt"
LOG_FILE="pip_install_$(date +%Y%m%d_%H%M%S).log"

echo "=========================================="
echo "开始下载intel_voice_requirements.txt文件"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 下载文件并显示进度
echo "正在从OSS下载intel_voice_requirements.txt..."
if wget --progress=bar:force -O "$REQUIREMENTS_FILE" "$OSS_URL" 2>&1 | tee -a "$LOG_FILE"; then
    echo ""
    echo "✓ intel_voice_requirements.txt下载成功"
    echo "文件大小: $(du -h $REQUIREMENTS_FILE | cut -f1)"
    echo ""
else
    echo "✗ intel_voice_requirements.txt下载失败"
    exit 1
fi

echo "=========================================="
echo "开始安装Python依赖包"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 显示intel_voice_requirements.txt内容
echo "依赖包列表:"
echo "----------------------------------------"
cat "$REQUIREMENTS_FILE"
echo "----------------------------------------"
echo ""

# 安装依赖包，显示详细日志
echo "正在安装依赖包..."
if python -m pip install -r "$REQUIREMENTS_FILE" --no-cache-dir 2>&1 | tee -a "$LOG_FILE"; then
    echo ""
    echo "✓ 依赖包安装成功"
else
    echo "✗ 依赖包安装失败"
    rm -f "$REQUIREMENTS_FILE"
    exit 1
fi

echo ""
echo "=========================================="
echo "安装完成"
echo "结束时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "日志文件: $LOG_FILE"
echo "=========================================="

# 清理临时文件
rm -f "$REQUIREMENTS_FILE"
echo "已清理临时文件: $REQUIREMENTS_FILE"