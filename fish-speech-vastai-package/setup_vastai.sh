#!/bin/bash

# Fish Speech Setup Script for vast.ai
# This script sets up Fish Speech with GPU support on vast.ai

set -e  # Exit on any error

echo "🐟 Fish Speech Setup for vast.ai 🐟"
echo "=================================="

# Update system packages
echo "📦 Updating system packages..."
apt-get update
apt-get install -y \
    portaudio19-dev \
    libsox-dev \
    ffmpeg \
    build-essential \
    libc6-dev \
    python3-pyaudio \
    curl \
    wget

# Install uv if not present
echo "🔧 Installing uv package manager..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi
# Add uv to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Create virtual environment and install dependencies
echo "🐍 Setting up Python environment..."
# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
echo "📁 Working in directory: $(pwd)"
uv sync --python 3.12 --extra stable

# Activate virtual environment
source .venv/bin/activate

# Verify CUDA availability
echo "🚀 Checking CUDA availability..."
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'GPU count: {torch.cuda.device_count()}'); print(f'GPU name: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"N/A\"}')"

echo "✅ Setup complete!"
echo ""
echo "🎯 To start the API server:"
echo "   ./start_api_server.sh"
echo ""
echo "🌐 To start the Web UI:"
echo "   ./start_webui.sh"
echo ""
echo "📚 Check README_VASTAI.md for detailed instructions"
