@echo off
REM TechTutors Startup Script for Windows
echo 🚀 Starting TechTutors - Socratic AI Mentor
echo ==========================================

REM Check if Docker is installed
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not installed. Please install Docker Desktop first.
    echo    Visit: https://docs.docker.com/desktop/windows/
    pause
    exit /b 1
)

REM Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose is not installed. Please install Docker Compose first.
    echo    Visit: https://docs.docker.com/compose/install/
    pause
    exit /b 1
)

REM Check if .env file exists
if not exist .env (
    echo ⚠️  .env file not found. Creating from template...
    if exist .env.example (
        copy .env.example .env
        echo ✅ Created .env file from template
        echo.
        echo 🔧 IMPORTANT: Please edit .env file with your AWS credentials:
        echo    - AWS_ACCESS_KEY_ID=your_aws_access_key
        echo    - AWS_SECRET_ACCESS_KEY=your_aws_secret_key
        echo    - ELEVENLABS_API_KEY=your_elevenlabs_key (optional)
        echo.
        pause
    ) else (
        echo ❌ .env.example file not found. Please create .env manually.
        pause
        exit /b 1
    )
)

REM Start services
echo 🐳 Starting Docker services...
docker-compose up -d

REM Wait for services to start
echo ⏳ Waiting for services to start...
timeout /t 10 /nobreak >nul

REM Check service status
echo 📊 Checking service status...
docker-compose ps

REM Health check
echo 🏥 Performing health checks...

REM Check backend
curl -s http://localhost:8000/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend is healthy
) else (
    echo ❌ Backend health check failed
)

REM Check frontend
curl -s http://localhost:3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend is responding
) else (
    echo ❌ Frontend is not responding
)

echo.
echo 🎉 TechTutors is starting up!
echo.
echo 📱 Access your application:
echo    Frontend: http://localhost:3000
echo    Backend:  http://localhost:8000
echo    API Docs: http://localhost:8000/docs
echo.
echo 📋 To view logs: docker-compose logs -f
echo 🛑 To stop:      docker-compose down
echo.
echo 💡 First time setup:
echo    1. Ensure AWS Bedrock access is enabled in your AWS account
echo    2. Request access to Claude 3 Sonnet model
echo    3. Test with: 'I'm getting a 403 error with AWS S3'
echo.
echo Happy learning! 🧠✨
pause