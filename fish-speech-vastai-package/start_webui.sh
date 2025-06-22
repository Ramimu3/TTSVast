#!/bin/bash

# Start Fish Speech Web UI for vast.ai
# This script starts the Gradio web interface with external access

set -e

echo "🌐 Starting Fish Speech Web UI..."

# Navigate to the project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
echo "📁 Working in directory: $(pwd)"

# Activate virtual environment
source .venv/bin/activate

# Check if CUDA is available
if python -c "import torch; exit(0 if torch.cuda.is_available() else 1)" 2>/dev/null; then
    DEVICE="cuda"
    echo "✅ Using GPU (CUDA)"
else
    DEVICE="cpu"
    echo "⚠️  Using CPU (CUDA not available)"
fi

# Start the Web UI
# The --share flag creates a public Gradio link
echo "🚀 Starting Web UI with public access..."
echo "📱 Web UI will be accessible via a public Gradio link"
echo ""
echo "💡 To stop the server, press Ctrl+C"
echo ""

python tools/run_webui.py \
    --device $DEVICE \
    --llama-checkpoint-path checkpoints/openaudio-s1-mini \
    --decoder-checkpoint-path checkpoints/openaudio-s1-mini/codec.pth \
    --decoder-config-name modded_dac_vq \
    --share
