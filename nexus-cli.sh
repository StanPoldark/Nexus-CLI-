#!/bin/bash

set -e  # 遇到错误时停止执行

echo "Updating system packages..."
sudo apt update && sudo apt install -y build-essential pkg-config libssl-dev protobuf-compiler curl unzip

echo "Checking installed protoc version..."
PROTOC_VERSION=$(protoc --version | awk '{print $2}' | cut -d. -f1)

if [ "$PROTOC_VERSION" -lt 15 ]; then
    echo "⚠️  protoc version is outdated ($PROTOC_VERSION), upgrading..."
    PROTOC_NEW_VERSION=25.2
    curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_NEW_VERSION}/protoc-${PROTOC_NEW_VERSION}-linux-x86_64.zip
    sudo unzip -o protoc-${PROTOC_NEW_VERSION}-linux-x86_64.zip -d /usr/local/
    sudo chmod +x /usr/local/bin/protoc
    rm protoc-${PROTOC_NEW_VERSION}-linux-x86_64.zip
    echo "✅ Upgraded to protoc $(protoc --version)"
else
    echo "✅ protoc version is up-to-date: $(protoc --version)"
fi

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 加载 Rust 环境
export PATH="$HOME/.cargo/bin:$PATH"

echo "Adding riscv32i target to Rust..."
rustup target add riscv32i-unknown-none-elf

echo "Installing Nexus CLI..."
curl https://cli.nexus.xyz/ | sh

echo "Installation complete! Please restart your terminal or run: source ~/.cargo/env"
