#!/usr/bin/env fish

# Bluetooth接続スクリプト
# Pebble V3への自動接続

set DEVICE_MAC "00:02:3C:C2:A8:EF"
set DEVICE_NAME "Pebble V3"

echo "🔵 $DEVICE_NAME への接続を開始します..."

# Bluetoothサービスが起動しているか確認
if not systemctl is-active --quiet bluetooth
    echo "❌ Bluetoothサービスが起動していません"
    echo "起動しています..."
    sudo systemctl start bluetooth
    sleep 2
end

# Bluetoothコントローラーの電源を確認・オン
echo "📡 Bluetoothコントローラーを有効化..."
echo -e "power on\nquit" | bluetoothctl > /dev/null 2>&1
sleep 1

# デバイスに接続
echo "🔗 $DEVICE_NAME ($DEVICE_MAC) に接続中..."
if echo -e "connect $DEVICE_MAC\nquit" | bluetoothctl | grep -q "Connection successful"
    echo "✅ 接続成功！"
    exit 0
else
    echo "❌ 接続失敗"
    echo ""
    echo "トラブルシューティング："
    echo "1. デバイスの電源が入っているか確認してください"
    echo "2. デバイスがペアリング済みか確認: bluetoothctl devices Paired"
    echo "3. 手動で接続: bluetoothctl"
    exit 1
end
