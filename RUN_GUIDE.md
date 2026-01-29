# 🚀 TechTutors - Complete Setup & Run Guide

## Prerequisites

Before running TechTutors, ensure you have:

- **Docker & Docker Compose** (Recommended - easiest setup)
- **OR** Manual setup requirements:
  - Python 3.11+
  - Node.js 18+
  - PostgreSQL 15+
  - Redis (optional, for caching)

## 🎯 Option 1: Quick Start with Docker (Recommended)

### Step 1: Clone and Setup Environment

```bash
# Create project directory
mkdir techtutors && cd techtutors

# Copy all the project files (assuming you have them)
# Then create environment file
cp .env.example .env
```

### Step 2: Configure Environment Variables

Edit the `.env` file:

```bash
# Database (Docker will handle this)
DATABASE_URL=postgresql://postgres:password@db:5432/techtutors

# Redis (Docker will handle this)
REDIS_URL=redis://redis:6379

# AWS Bedrock (REQUIRED - Get from AWS Console)
AWS_ACCESS_KEY_ID=your_aws_access_key_here
AWS_SECRET_ACCESS_KEY=your_aws_secret_key_here
AWS_DEFAULT_REGION=us-east-1

# ElevenLabs (Optional - for voice synthesis)
ELEVENLABS_API_KEY=your_elevenlabs_key_here

# Frontend URLs (Docker will handle this)
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_WS_URL=ws://localhost:8000
```

### Step 3: Start All Services

```bash
# Start all services in background
docker-compose up -d

# View logs (optional)
docker-compose logs -f
```

### Step 4: Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Database**: localhost:5432 (postgres/password)

### Step 5: Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (reset database)
docker-compose down -v
```

---

## 🛠️ Option 2: Manual Setup (Development)

### Step 1: Setup Backend

```bash
# Navigate to backend directory
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Step 2: Setup Database

```bash
# Install PostgreSQL (if not installed)
# Windows: Download from postgresql.org
# macOS: brew install postgresql
# Ubuntu: sudo apt install postgresql postgresql-contrib

# Create database
createdb techtutors

# Set environment variables
export DATABASE_URL="postgresql://postgres:password@localhost:5432/techtutors"
export AWS_ACCESS_KEY_ID="your_aws_access_key"
export AWS_SECRET_ACCESS_KEY="your_aws_secret_key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Step 3: Start Backend

```bash
# From backend directory
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Step 4: Setup Frontend

```bash
# Open new terminal, navigate to frontend
cd frontend

# Install dependencies
npm install

# Set environment variables
export NEXT_PUBLIC_API_URL="http://localhost:8000"
export NEXT_PUBLIC_WS_URL="ws://localhost:8000"

# Start development server
npm run dev
```

### Step 5: Access Application

- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:8000

---

## 🔧 AWS Bedrock Setup (REQUIRED)

### Step 1: AWS Account Setup

1. **Create AWS Account** (if you don't have one)
2. **Enable Bedrock Service** in your region (us-east-1 recommended)
3. **Request Model Access**:
   - Go to AWS Bedrock Console
   - Navigate to "Model access"
   - Request access to "Claude 3 Sonnet" and "Titan Embed Text"

### Step 2: Create IAM User

```bash
# Create IAM user with these permissions:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:ListFoundationModels"
            ],
            "Resource": "*"
        }
    ]
}
```

### Step 3: Get Credentials

1. Create access key for the IAM user
2. Add to your `.env` file or environment variables

---

## 🎤 ElevenLabs Setup (Optional - for Voice)

### Step 1: Get API Key

1. Sign up at [ElevenLabs](https://elevenlabs.io)
2. Get your API key from dashboard
3. Add to `.env`: `ELEVENLABS_API_KEY=your_key_here`

### Step 2: Test Voice

The application will automatically detect if ElevenLabs is configured and enable voice features.

---

## 🧪 Testing the Application

### Step 1: Basic Functionality Test

1. **Open Frontend**: http://localhost:3000
2. **Check Connection**: Should see "Connected" status in header
3. **Send Test Message**: "I'm getting a 403 error with AWS S3"
4. **Verify Response**: Should get Socratic questions, not direct answers

### Step 2: Voice Test (if configured)

1. **Click "Start Voice"** button
2. **Allow microphone** permissions
3. **Speak a question**
4. **Check transcript** appears
5. **Click speaker icon** on mentor responses

### Step 3: Code Panel Test

1. **Click "Code" tab** in right panel
2. **Paste some code** with an error
3. **Click "Analyze Code"**
4. **Verify mentor asks questions** about the code

---

## 🐛 Troubleshooting

### Common Issues

#### 1. "Connection Error" on Frontend

```bash
# Check if backend is running
curl http://localhost:8000/health

# Check backend logs
docker-compose logs backend
# OR for manual setup:
# Check terminal running uvicorn
```

#### 2. "AWS Bedrock Error"

```bash
# Verify AWS credentials
aws bedrock list-foundation-models --region us-east-1

# Check if Claude model is enabled in AWS Console
# Bedrock > Model access > Request access
```

#### 3. Database Connection Error

```bash
# Check if PostgreSQL is running
docker-compose ps
# OR for manual setup:
pg_isready -h localhost -p 5432

# Check database exists
psql -h localhost -U postgres -l
```

#### 4. WebSocket Connection Failed

```bash
# Check CORS settings in backend/main.py
# Verify frontend is connecting to correct WebSocket URL
# Check browser console for WebSocket errors
```

#### 5. Voice Not Working

```bash
# Check browser permissions for microphone
# Verify ElevenLabs API key is set
# Check browser console for speech recognition errors
```

### Debug Commands

```bash
# View all service logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db

# Check service status
docker-compose ps

# Restart specific service
docker-compose restart backend

# Rebuild services
docker-compose up --build
```

---

## 📊 Monitoring & Logs

### Application Logs

```bash
# Backend logs (FastAPI)
docker-compose logs -f backend

# Frontend logs (Next.js)
docker-compose logs -f frontend

# Database logs
docker-compose logs -f db
```

### Health Checks

- **Backend Health**: http://localhost:8000/health
- **Database**: Check docker-compose ps
- **WebSocket**: Check browser console

---

## 🚀 Production Deployment

### Step 1: Build for Production

```bash
# Build frontend
cd frontend && npm run build

# Build Docker images
docker-compose -f docker-compose.prod.yml build
```

### Step 2: Environment Setup

```bash
# Set production environment variables
export NODE_ENV=production
export DATABASE_URL="your_production_db_url"
export AWS_ACCESS_KEY_ID="your_production_aws_key"
# ... other production variables
```

### Step 3: Deploy

```bash
# Start production services
docker-compose -f docker-compose.prod.yml up -d
```

---

## 🎯 Quick Verification Checklist

- [ ] Backend running on port 8000
- [ ] Frontend running on port 3000
- [ ] Database connected and tables created
- [ ] AWS Bedrock credentials configured
- [ ] WebSocket connection established
- [ ] Can send messages and receive Socratic responses
- [ ] Voice features working (if configured)
- [ ] Code panel accepts input
- [ ] No console errors

---

## 📞 Support

If you encounter issues:

1. **Check logs** using the debug commands above
2. **Verify environment variables** are set correctly
3. **Ensure AWS Bedrock access** is properly configured
4. **Check network connectivity** between services
5. **Review browser console** for frontend errors

The application should now be running successfully! 🎉