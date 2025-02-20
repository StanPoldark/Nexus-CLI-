#!/bin/bash

set -e  # 遇到错误时停止执行

echo "Updating system packages..."
sudo apt update && sudo apt install -y build-essential pkg-config libssl-dev protobuf-compiler curl

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# 加载 Rust 环境（如果没有生效，建议手动执行 source ~/.cargo/env）
export PATH="$HOME/.cargo/bin:$PATH"

echo "Adding riscv32i target to Rust..."
rustup target add riscv32i-unknown-none-elf

echo "Installing Nexus CLI..."
curl https://cli.nexus.xyz/ | sh

echo "Installation complete! Please restart your terminal or run: source ~/.cargo/env"
