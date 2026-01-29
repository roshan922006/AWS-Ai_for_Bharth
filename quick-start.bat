@echo off
echo 🚀 TechTutors Quick Start (Temporary)
echo =====================================

REM Check if .env exists
if not exist .env (
    echo Creating temporary .env file...
    copy .env.example .env
    echo.
    echo ⚠️  IMPORTANT: Edit .env file with your AWS credentials
    echo    AWS_ACCESS_KEY_ID=your_key
    echo    AWS_SECRET_ACCESS_KEY=your_secret
    echo.
    pause
)

echo Starting TechTutors temporarily...
docker-compose up

echo.
echo 🛑 Cleaning up temporary files...
docker-compose down -v

echo ✅ Temporary run complete - all data removed
pause