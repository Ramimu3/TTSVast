#!/bin/bash

# Start Fish Speech API Server for vast.ai
# This script starts the API server with GPU support and external access

set -e

echo "🚀 Starting Fish Speech API Server..."

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

# Start the API server
# Listen on all interfaces (0.0.0.0) to allow external connections
# Default port 8080 (you can change this if needed)
echo "🌐 Starting API server on 0.0.0.0:8080..."
echo "📡 API will be accessible at: http://[YOUR_VAST_AI_IP]:8080"
echo ""
echo "🔑 API Endpoints:"
echo "   POST /v1/tts - Text-to-Speech generation"
echo "   GET /docs - API documentation"
echo ""
echo "💡 To stop the server, press Ctrl+C"
echo ""

python tools/api_server.py \
    --listen 0.0.0.0:8080 \
    --device $DEVICE \
    --llama-checkpoint-path checkpoints/openaudio-s1-mini \
    --decoder-checkpoint-path checkpoints/openaudio-s1-mini/codec.pth \
    --decoder-config-name modded_dac_vq
