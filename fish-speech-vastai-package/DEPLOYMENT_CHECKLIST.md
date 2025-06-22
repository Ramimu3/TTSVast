# 🚀 Fish Speech vast.ai Deployment Checklist

## ✅ Pre-Deployment

- [ ] Rent a GPU instance on vast.ai (RTX 3090+ recommended)
- [ ] Ensure at least 10GB storage space
- [ ] Upload this entire folder to `/workspace/` in Jupyter
- [ ] Verify GPU is available: `nvidia-smi`

## 🔧 Setup Steps

- [ ] Open `setup_and_run.ipynb` in Jupyter
- [ ] Run all cells in order, OR
- [ ] Run manually: `./setup_vastai.sh`
- [ ] Verify CUDA: Check Python can see GPU
- [ ] Test installation: Run setup verification

## 🌐 API Server Deployment

- [ ] Start API server: `./start_api_server.sh`
- [ ] Verify server is running: Check `http://localhost:8080/docs`
- [ ] Get external IP: Note your vast.ai instance IP
- [ ] Test external access: `http://[VAST_IP]:8080/docs`
- [ ] Run API test: Use the test cell in notebook

## 🧪 Testing

- [ ] Test basic TTS: "Hello world" example
- [ ] Verify audio output: Check generated WAV file
- [ ] Test client code: Run `api_client_example.py`
- [ ] Check performance: Monitor GPU usage with `nvidia-smi`

## 🔗 Integration

- [ ] Update client code with your vast.ai IP
- [ ] Test from your application
- [ ] Set up API key (optional): For security
- [ ] Monitor resource usage: GPU memory, bandwidth

## 📊 Performance Verification

Expected performance with RTX 3090:
- [ ] Generation speed: ~14 tokens/sec
- [ ] GPU memory usage: ~5GB
- [ ] Response time: <30 seconds for typical requests

## 🛠️ Troubleshooting

If issues occur:
- [ ] Check logs in terminal/notebook output
- [ ] Verify GPU availability: `nvidia-smi`
- [ ] Test CUDA in Python: `torch.cuda.is_available()`
- [ ] Check port accessibility: Try different ports if needed
- [ ] Restart services: Kill and restart API server

## 🎯 Success Criteria

✅ **Deployment is successful when:**
- API server responds at `/docs` endpoint
- External IP access works from your application
- TTS generation produces audio files
- GPU acceleration is active (check logs)
- Client example connects successfully

## 📞 Support

- Check `README_VASTAI.md` for detailed instructions
- Use the Jupyter notebook for guided setup
- Test with provided examples before custom integration
- Monitor resource usage to optimize performance

---

**🎉 Once all items are checked, your Fish Speech API is ready for production use!**
