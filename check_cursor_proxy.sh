#!/bin/bash

echo "======================================"
echo "Cursor Sonnet 连接诊断工具"
echo "======================================"
echo ""

# 检查常见代理端口
echo "1. 检查常见代理端口..."
for port in 7890 10808 1080 7891 8080; do
    if nc -zv 127.0.0.1 $port 2>/dev/null; then
        echo "✅ 发现代理运行在端口: $port"
    fi
done
echo ""

# 测试直连 Anthropic
echo "2. 测试直连 Anthropic API..."
if curl -s --connect-timeout 3 https://api.anthropic.com 2>&1 | grep -q "Cloudflare\|challenge"; then
    echo "❌ 直连失败（需要代理）"
else
    echo "✅ 可以直连"
fi
echo ""

# 测试代理连接
echo "3. 测试通过代理连接 Anthropic..."
if curl -s --connect-timeout 3 -x http://127.0.0.1:7890 https://api.anthropic.com 2>&1 | grep -q "Anthropic"; then
    echo "✅ 代理连接成功"
    echo ""
    echo "推荐配置："
    echo '{
  "http.proxy": "http://127.0.0.1:7890",
  "http.proxyStrictSSL": false
}'
else
    echo "❌ 代理连接失败，请检查："
    echo "   1. 代理软件是否运行"
    echo "   2. 端口是否正确（尝试其他端口）"
    echo "   3. 代理是否支持 HTTPS"
fi
echo ""

echo "======================================"
echo "如果所有测试都失败，建议："
echo "1. 使用国内API服务（302.AI/SiliconFlow）"
echo "2. 或使用其他模型（GPT-4）"
echo "======================================"
