# TechTutors Setup Guide

## Quick Start with Docker

1. **Clone and setup environment**:
```bash
cp .env.example .env
# Edit .env with your AWS credentials
```

2. **Start all services**:
```bash
docker-compose up -d
```

3. **Access the application**:
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## Manual Setup

### Backend Setup

1. **Install Python dependencies**:
```bash
cd backend
pip install -r requirements.txt
```

2. **Set environment variables**:
```bash
export DATABASE_URL="postgresql://postgres:password@localhost:5432/techtutors"
export AWS_ACCESS_KEY_ID="your_key"
export AWS_SECRET_ACCESS_KEY="your_secret"
```

3. **Start the backend**:
```bash
uvicorn main:app --reload
```

### Frontend Setup

1. **Install Node.js dependencies**:
```bash
cd frontend
npm install
```

2. **Start the development server**:
```bash
npm run dev
```

## Configuration

### AWS Bedrock Setup
1. Ensure your AWS credentials have access to Bedrock
2. Enable the Claude model in your AWS region
3. Update the model ID in `backend/services/bedrock_service.py` if needed

### ElevenLabs Setup (Optional)
1. Get API key from ElevenLabs
2. Add to environment variables
3. Voice synthesis will work automatically

### Database Setup
The application will automatically create tables on first run.

## Architecture Overview

```
Frontend (Next.js) ←→ Backend (FastAPI) ←→ AWS Bedrock
                           ↓
                    PostgreSQL + Redis
                           ↓
                    RAG System (FAISS)
```

## Key Features

- **Socratic Learning**: Never gives direct answers, guides through questions
- **Dual-Agent System**: Diagnostic + Socratic agents work together  
- **Voice Interface**: Speech-to-text and text-to-speech
- **RAG System**: Retrieves relevant documentation
- **Progressive Hints**: 3-level hint system
- **Session Tracking**: Monitors learning progress

## Troubleshooting

### Common Issues

1. **WebSocket connection fails**:
   - Check if backend is running on port 8000
   - Verify CORS settings in main.py

2. **AWS Bedrock errors**:
   - Verify AWS credentials and region
   - Check if Claude model is enabled

3. **Voice not working**:
   - Check browser permissions for microphone
   - ElevenLabs API key may be missing

4. **Database connection issues**:
   - Ensure PostgreSQL is running
   - Check DATABASE_URL format

### Development Tips

- Use `docker-compose logs -f` to see all service logs
- Backend API docs available at `/docs` endpoint
- Frontend has hot reload enabled in development
- Check browser console for WebSocket connection status

## Production Deployment

1. **Build frontend**:
```bash
cd frontend && npm run build
```

2. **Set production environment variables**
3. **Use production database**
4. **Configure reverse proxy (nginx)**
5. **Enable HTTPS**

## Contributing

1. Follow the existing code structure
2. Maintain the Socratic principle - no direct answers
3. Add tests for new features
4. Update documentation