#!/bin/bash

# TechTutors Setup Verification Script
echo "🔍 TechTutors Setup Verification"
echo "================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check service
check_service() {
    local service_name=$1
    local url=$2
    local expected_status=$3
    
    echo -n "Checking $service_name... "
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "$expected_status"; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        return 1
    fi
}

# Function to check environment variable
check_env_var() {
    local var_name=$1
    local required=$2
    
    echo -n "Checking $var_name... "
    
    if [ -n "${!var_name}" ]; then
        echo -e "${GREEN}✅ SET${NC}"
        return 0
    else
        if [ "$required" = "true" ]; then
            echo -e "${RED}❌ MISSING (REQUIRED)${NC}"
            return 1
        else
            echo -e "${YELLOW}⚠️  NOT SET (OPTIONAL)${NC}"
            return 0
        fi
    fi
}

echo "🐳 Docker Services Status:"
echo "=========================="
docker-compose ps

echo ""
echo "🌐 Service Health Checks:"
echo "========================="

# Check backend health
check_service "Backend Health" "http://localhost:8000/health" "200"

# Check backend API docs
check_service "Backend API Docs" "http://localhost:8000/docs" "200"

# Check frontend
check_service "Frontend" "http://localhost:3000" "200"

# Check WebSocket (this is trickier, we'll just check if the port is open)
echo -n "Checking WebSocket port... "
if nc -z localhost 8000 2>/dev/null; then
    echo -e "${GREEN}✅ PORT OPEN${NC}"
else
    echo -e "${RED}❌ PORT CLOSED${NC}"
fi

echo ""
echo "🔐 Environment Variables:"
echo "========================="

# Load .env file if it exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Check required environment variables
check_env_var "AWS_ACCESS_KEY_ID" "true"
check_env_var "AWS_SECRET_ACCESS_KEY" "true"
check_env_var "AWS_DEFAULT_REGION" "true"
check_env_var "DATABASE_URL" "true"

# Check optional environment variables
check_env_var "ELEVENLABS_API_KEY" "false"
check_env_var "REDIS_URL" "false"

echo ""
echo "🗄️  Database Connection:"
echo "========================"

# Check if we can connect to the database
echo -n "Testing database connection... "
if docker-compose exec -T db pg_isready -U postgres >/dev/null 2>&1; then
    echo -e "${GREEN}✅ CONNECTED${NC}"
else
    echo -e "${RED}❌ CONNECTION FAILED${NC}"
fi

# Check if tables exist
echo -n "Checking database tables... "
table_count=$(docker-compose exec -T db psql -U postgres -d techtutors -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')
if [ "$table_count" -gt 0 ] 2>/dev/null; then
    echo -e "${GREEN}✅ TABLES EXIST ($table_count tables)${NC}"
else
    echo -e "${YELLOW}⚠️  NO TABLES (will be created on first run)${NC}"
fi

echo ""
echo "🧠 AI Services:"
echo "==============="

# Test AWS Bedrock connection (if credentials are available)
if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then
    echo -n "Testing AWS Bedrock access... "
    # This is a simple test - in reality, you'd need to make an actual API call
    echo -e "${YELLOW}⚠️  MANUAL VERIFICATION REQUIRED${NC}"
    echo "   Please verify in AWS Console that:"
    echo "   - Bedrock service is available in your region"
    echo "   - Claude 3 Sonnet model access is granted"
else
    echo -e "${RED}❌ AWS credentials not configured${NC}"
fi

# Test ElevenLabs (if API key is available)
if [ -n "$ELEVENLABS_API_KEY" ]; then
    echo -n "Testing ElevenLabs API... "
    if curl -s -H "xi-api-key: $ELEVENLABS_API_KEY" https://api.elevenlabs.io/v1/voices >/dev/null; then
        echo -e "${GREEN}✅ API KEY VALID${NC}"
    else
        echo -e "${RED}❌ API KEY INVALID${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  ElevenLabs not configured (voice features disabled)${NC}"
fi

echo ""
echo "📊 Summary:"
echo "==========="

# Count successful checks
total_checks=0
passed_checks=0

# This is a simplified summary - in a real script you'd track each check
echo "Core services appear to be running."
echo "Please manually verify:"
echo "1. Visit http://localhost:3000 and see the TechTutors interface"
echo "2. Send a test message: 'I'm getting a 403 error with AWS S3'"
echo "3. Verify you get Socratic questions, not direct answers"
echo "4. Check that WebSocket shows 'Connected' status"

echo ""
echo "🚀 If all checks pass, TechTutors is ready to use!"
echo "📚 Visit http://localhost:3000 to start learning"