#!/usr/bin/env python3
"""
Fish Speech API Client Example
This script demonstrates how to use the Fish Speech API from your application.
"""

import requests
import json
import base64
from pathlib import Path

class FishSpeechClient:
    def __init__(self, base_url: str, api_key: str = None):
        """
        Initialize the Fish Speech API client.
        
        Args:
            base_url: The base URL of your vast.ai Fish Speech API (e.g., "http://your-vast-ip:8080")
            api_key: Optional API key if authentication is enabled
        """
        self.base_url = base_url.rstrip('/')
        self.api_key = api_key
        self.headers = {
            'Content-Type': 'application/json'
        }
        if api_key:
            self.headers['Authorization'] = f'Bearer {api_key}'
    
    def text_to_speech(self, text: str, reference_audio: str = None, reference_text: str = None, 
                      max_new_tokens: int = 1024, chunk_length: int = 200, 
                      top_p: float = 0.7, repetition_penalty: float = 1.2, 
                      temperature: float = 0.7) -> bytes:
        """
        Convert text to speech using the Fish Speech API.
        
        Args:
            text: The text to convert to speech
            reference_audio: Path to reference audio file (optional)
            reference_text: Reference text for voice cloning (optional)
            max_new_tokens: Maximum number of tokens to generate
            chunk_length: Length of text chunks for processing
            top_p: Top-p sampling parameter
            repetition_penalty: Repetition penalty
            temperature: Sampling temperature
            
        Returns:
            Audio data as bytes
        """
        
        # Prepare the request data
        data = {
            "text": text,
            "max_new_tokens": max_new_tokens,
            "chunk_length": chunk_length,
            "top_p": top_p,
            "repetition_penalty": repetition_penalty,
            "temperature": temperature
        }
        
        # Add reference audio if provided
        if reference_audio and Path(reference_audio).exists():
            with open(reference_audio, 'rb') as f:
                audio_data = base64.b64encode(f.read()).decode('utf-8')
                data["reference_audio"] = audio_data
        
        # Add reference text if provided
        if reference_text:
            data["reference_text"] = reference_text
        
        # Make the API request
        response = requests.post(
            f"{self.base_url}/v1/tts",
            headers=self.headers,
            json=data,
            timeout=300  # 5 minute timeout for long texts
        )
        
        if response.status_code == 200:
            return response.content
        else:
            raise Exception(f"API request failed: {response.status_code} - {response.text}")
    
    def health_check(self) -> dict:
        """Check if the API server is healthy."""
        try:
            response = requests.get(f"{self.base_url}/health", timeout=10)
            return {"status": "healthy" if response.status_code == 200 else "unhealthy"}
        except Exception as e:
            return {"status": "error", "message": str(e)}


# Example usage
if __name__ == "__main__":
    # Replace with your vast.ai instance IP and port
    VAST_AI_URL = "http://your-vast-ai-ip:8080"
    
    # Initialize the client
    client = FishSpeechClient(VAST_AI_URL)
    
    # Check if the server is running
    health = client.health_check()
    print(f"Server health: {health}")
    
    if health.get("status") == "healthy":
        # Generate speech from text
        text = "Hello! This is a test of Fish Speech running on vast.ai."
        
        try:
            print(f"Generating speech for: '{text}'")
            audio_data = client.text_to_speech(text)
            
            # Save the audio file
            output_file = "generated_speech.wav"
            with open(output_file, 'wb') as f:
                f.write(audio_data)
            
            print(f"✅ Speech generated successfully! Saved to: {output_file}")
            
        except Exception as e:
            print(f"❌ Error generating speech: {e}")
    else:
        print("❌ Server is not healthy. Please check your vast.ai instance.")
