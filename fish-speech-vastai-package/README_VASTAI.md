# 🐟 Fish Speech for vast.ai Deployment

This package contains everything you need to deploy Fish Speech on vast.ai with GPU acceleration and API access.

## 📦 Package Contents

- **Complete Fish Speech codebase** with all dependencies
- **Pre-trained models** (3.4GB) - ready to use
- **Setup scripts** for automated installation
- **API server** configured for external access
- **Web UI** with public sharing capability
- **Client examples** for connecting your applications

## 🚀 Quick Start

### 1. Upload to vast.ai
1. Rent a GPU instance on vast.ai (recommended: RTX 3090 or better)
2. Open Jupyter Lab
3. Upload this entire folder to `/workspace/`
4. Open the `setup_and_run.ipynb` notebook

### 2. Run Setup
Execute the cells in the Jupyter notebook, or manually run:
```bash
chmod +x setup_vastai.sh start_api_server.sh start_webui.sh
./setup_vastai.sh
```

### 3. Start the API Server
```bash
./start_api_server.sh
```

The API will be available at: `http://[YOUR_VAST_IP]:8080`

## 🔧 Manual Setup (Alternative)

If you prefer manual setup:

```bash
# Install system dependencies
apt-get update
apt-get install -y portaudio19-dev libsox-dev ffmpeg build-essential python3-pyaudio

# Install uv package manager
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"

# Install Python dependencies
uv sync --python 3.12 --extra stable

# Start API server
source .venv/bin/activate
python tools/api_server.py --listen 0.0.0.0:8080 --device cuda
```

## 🌐 API Usage

### Endpoints
- **POST** `/v1/tts` - Text-to-Speech generation
- **GET** `/docs` - Interactive API documentation
- **GET** `/health` - Health check

### Example Request
```python
import requests

url = "http://your-vast-ip:8080/v1/tts"
data = {
    "text": "Hello, this is Fish Speech!",
    "max_new_tokens": 1024,
    "chunk_length": 200,
    "top_p": 0.7,
    "repetition_penalty": 1.2,
    "temperature": 0.7
}

response = requests.post(url, json=data)
with open("output.wav", "wb") as f:
    f.write(response.content)
```

### Using the Client Example
Use the provided `api_client_example.py`:

```python
from api_client_example import FishSpeechClient

client = FishSpeechClient("http://your-vast-ip:8080")
audio_data = client.text_to_speech("Hello world!")

with open("speech.wav", "wb") as f:
    f.write(audio_data)
```

## 📱 Web UI Access

For a user-friendly interface:
```bash
./start_webui.sh
```

This creates a public Gradio link you can access from anywhere.

## ⚡ Performance

With GPU acceleration (RTX 3090):
- **Speed**: ~14 tokens/sec (16x faster than CPU)
- **Memory**: ~5GB GPU memory usage
- **Quality**: High-quality neural speech synthesis

## 🔒 Security Options

### API Key Authentication
To secure your API, set an API key:
```bash
python tools/api_server.py --listen 0.0.0.0:8080 --device cuda --api-key YOUR_SECRET_KEY
```

Then include in requests:
```python
headers = {"Authorization": "Bearer YOUR_SECRET_KEY"}
response = requests.post(url, json=data, headers=headers)
```

## 🛠️ Troubleshooting

### Common Issues

**1. CUDA not available**
- Ensure you rented a GPU instance
- Check: `nvidia-smi` shows your GPU
- Verify: `python -c "import torch; print(torch.cuda.is_available())"`

**2. Port not accessible**
- vast.ai instances expose ports automatically
- Use the external IP, not localhost
- Check firewall settings if needed

**3. Out of memory**
- Reduce `max_new_tokens` in requests
- Use smaller batch sizes
- Consider a GPU with more VRAM

**4. Slow generation**
- Ensure using `--device cuda` not `cpu`
- Check GPU utilization with `nvidia-smi`
- Verify CUDA installation

### Getting Help
- Check the logs in the terminal/notebook
- Visit the `/docs` endpoint for API documentation
- Test with the provided examples first

## 📊 Resource Requirements

- **GPU**: RTX 3090 or better (minimum 8GB VRAM)
- **RAM**: 16GB+ recommended
- **Storage**: 10GB+ (models + dependencies)
- **Network**: Good bandwidth for model downloads

## 🔄 Updates

To update the models or code:
1. Download new models: `python tools/download_models.py`
2. Update dependencies: `uv sync --upgrade`
3. Restart the API server

## 📞 Integration Examples

### Python Application
```python
from api_client_example import FishSpeechClient

client = FishSpeechClient("http://your-vast-ip:8080")
audio = client.text_to_speech("Your text here")
```

### cURL
```bash
curl -X POST "http://your-vast-ip:8080/v1/tts" \
     -H "Content-Type: application/json" \
     -d '{"text": "Hello world!"}' \
     --output speech.wav
```

### JavaScript/Node.js
```javascript
const response = await fetch('http://your-vast-ip:8080/v1/tts', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({text: 'Hello world!'})
});
const audioBuffer = await response.arrayBuffer();
```

## 🎯 Next Steps

1. **Test the setup** with the provided examples
2. **Integrate with your app** using the client code
3. **Customize voice** by providing reference audio
4. **Scale up** by running multiple instances
5. **Monitor usage** and optimize parameters

Happy speech synthesis! 🎤✨
