#!/bin/bash

# TechTutors Startup Script
echo "🚀 Starting TechTutors - Socratic AI Mentor"
echo "=========================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "   Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from template..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ Created .env file from template"
        echo ""
        echo "🔧 IMPORTANT: Please edit .env file with your AWS credentials:"
        echo "   - AWS_ACCESS_KEY_ID=your_aws_access_key"
        echo "   - AWS_SECRET_ACCESS_KEY=your_aws_secret_key"
        echo "   - ELEVENLABS_API_KEY=your_elevenlabs_key (optional)"
        echo ""
        read -p "Press Enter after updating .env file..."
    else
        echo "❌ .env.example file not found. Please create .env manually."
        exit 1
    fi
fi

# Start services
echo "🐳 Starting Docker services..."
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 10

# Check service status
echo "📊 Checking service status..."
docker-compose ps

# Health check
echo "🏥 Performing health checks..."

# Check backend
if curl -s http://localhost:8000/health > /dev/null; then
    echo "✅ Backend is healthy"
else
    echo "❌ Backend health check failed"
fi

# Check if frontend is responding
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Frontend is responding"
else
    echo "❌ Frontend is not responding"
fi

echo ""
echo "🎉 TechTutors is starting up!"
echo ""
echo "📱 Access your application:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:8000"
echo "   API Docs: http://localhost:8000/docs"
echo ""
echo "📋 To view logs: docker-compose logs -f"
echo "🛑 To stop:      docker-compose down"
echo ""
echo "💡 First time setup:"
echo "   1. Ensure AWS Bedrock access is enabled in your AWS account"
echo "   2. Request access to Claude 3 Sonnet model"
echo "   3. Test with: 'I'm getting a 403 error with AWS S3'"
echo ""
echo "Happy learning! 🧠✨"