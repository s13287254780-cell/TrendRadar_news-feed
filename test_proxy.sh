#!/bin/bash

echo "=========================================="
echo "Cursor 代理连接测试"
echo "=========================================="
echo ""

PROXY="http://127.0.0.1:7897"

echo "1. 测试代理是否可用..."
if curl -x $PROXY -s --connect-timeout 5 https://www.google.com > /dev/null 2>&1; then
    echo "✅ 代理连接成功"
else
    echo "❌ 代理连接失败"
    echo "   请检查："
    echo "   - VPN 是否已连接"
    echo "   - 端口 7897 是否正确"
    exit 1
fi
echo ""

echo "2. 测试当前 IP 地址..."
echo "直连 IP:"
curl -s https://api.ip.sb/ip
echo ""
echo "代理 IP:"
curl -x $PROXY -s https://api.ip.sb/ip
echo ""

echo "3. 测试代理 IP 的地区..."
PROXY_IP=$(curl -x $PROXY -s https://api.ip.sb/ip)
LOCATION=$(curl -s https://ipapi.co/$PROXY_IP/json/ | grep -o '"country_name":"[^"]*' | cut -d'"' -f4)
echo "代理地区: $LOCATION"
echo ""

echo "4. 测试 Anthropic API 访问..."
if curl -x $PROXY -s --connect-timeout 5 https://api.anthropic.com > /dev/null 2>&1; then
    echo "✅ 可以通过代理访问 Anthropic"
else
    echo "❌ 无法访问 Anthropic"
    echo "   建议："
    echo "   - 更换为美国/欧洲节点"
    echo "   - 检查 VPN 的 HTTP 代理设置"
fi
echo ""

echo "=========================================="
echo "推荐配置（复制到 Cursor settings.json）："
echo "=========================================="
cat << 'EOF'
{
  "http.proxy": "http://127.0.0.1:7897",
  "http.proxyStrictSSL": false,
  "http.proxySupport": "on",
  "http.systemProxyAuthorization": true
}
EOF
echo ""
