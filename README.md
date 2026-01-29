# TechTutors - Socratic AI Mentor for Developers

> "We don't solve your bugs; we build the architect who prevents them."

TechTutors is a production-ready AI-powered learning assistant that helps developers learn faster and understand technology deeply by guiding them using Socratic questioning instead of directly giving answers.

## What Makes TechTutors Different

- **Never gives direct solutions** - builds understanding through inquiry
- **Asks guiding questions** that lead to discovery
- **Progressive hint system** - from subtle to direct guidance
- **Dual-agent architecture** - diagnostic analysis + Socratic transformation
- **Voice-enabled learning** - speak your questions, hear responses
- **Environment-aware** - adapts to your tech stack and experience

## Quick Start (Recommended)

### Prerequisites
- **Docker Desktop** installed ([Download here](https://docs.docker.com/desktop/))
- **AWS Account** with Bedrock access ([Setup guide](#aws-bedrock-setup))

### 1. Setup Environment

```bash
# Create .env file
copy .env.example .env

# Edit .env with your AWS credentials:
# AWS_ACCESS_KEY_ID=your_aws_access_key
# AWS_SECRET_ACCESS_KEY=your_aws_secret_key
# ELEVENLABS_API_KEY=your_elevenlabs_key (optional)
```

### 2. Start Application

**Windows:**
```cmd
start.bat
```

**macOS/Linux:**
```bash
chmod +x start.sh
./start.sh
```

**Manual Docker:**
```bash
docker-compose up -d
```

### 3. Access Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

### 4. Test the System

1. Open http://localhost:3000
2. Wait for "Connected" status in header
3. Send test message: `"I'm getting a 403 error with AWS S3"`
4. Verify you get **questions**, not direct answers!

##  Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Frontend      │    │     Backend      │    │   AWS Bedrock   │
│   (Next.js)     │◄──►│   (FastAPI)      │◄──►│   (Claude 3)    │
│                 │    │                  │    │                 │
│ • Chat UI       │    │ • Dual Agents   │    │ • LLM Inference │
│ • Voice I/O     │    │ • RAG System    │    │ • Embeddings    │
│ • Code Panel    │    │ • WebSocket      │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                       ┌────────▼────────┐
                       │   PostgreSQL    │
                       │   + FAISS       │
                       │                 │
                       │ • Sessions      │
                       │ • Progress      │
                       │ • Knowledge     │
                       └─────────────────┘
```

## 🎮 How It Works

### The Socratic Method in Action

** Traditional AI Assistant:**
```
User: "My S3 returns 403"
AI: "Add s3:GetObject permission to your IAM role"
```

** TechTutors Socratic Approach:**
```
User: "My S3 returns 403"
TechTutors: "What do you think happens when AWS can't verify your identity? 
            Let's explore - what IAM role is your application using?"

User: "I'm not sure about the role"
TechTutors: "Great question! How does AWS determine if you have permission 
            to access a resource? What are the two main components involved?"
```

### Dual-Agent System

1. **Diagnostic Agent**
   - Analyzes your issue using RAG
   - Identifies root causes
   - Retrieves relevant documentation

2. **Socratic Agent**
   - Transforms solutions into questions
   - Provides progressive hints (3 levels)
   - Adapts to your experience level

##  Key Features

###  Intelligent Chat Interface
- Real-time WebSocket communication
- Progressive hint system (Subtle → Moderate → Direct)
- Suggested follow-up questions
- Session memory and context

###  Voice-Enabled Learning
- Speech-to-text input (browser-based)
- Natural text-to-speech responses (ElevenLabs)
- Seamless voice + text interaction

###  Code & Log Analysis
- Paste code snippets for analysis
- Upload error logs and stack traces
- Syntax highlighting and formatting
- Context-aware questioning

###  Learning Analytics
- Progress tracking per topic
- Hint usage patterns
- Mistake learning opportunities
- Session duration and engagement

###  RAG-Powered Knowledge
- Vector database with AWS documentation
- Contextual information retrieval
- Environment-specific guidance
- Expandable knowledge base

##  Manual Setup (Development)

<details>
<summary>Click to expand manual setup instructions</summary>

### Backend Setup

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate

pip install -r requirements.txt

# Set environment variables
set DATABASE_URL=postgresql://postgres:password@localhost:5432/techtutors
set AWS_ACCESS_KEY_ID=your_key
set AWS_SECRET_ACCESS_KEY=your_secret

# Start backend
uvicorn main:app --reload
```

### Frontend Setup

```bash
cd frontend
npm install

# Set environment variables
set NEXT_PUBLIC_API_URL=http://localhost:8000
set NEXT_PUBLIC_WS_URL=ws://localhost:8000

# Start frontend
npm run dev
```

### Database Setup

```bash
# Install PostgreSQL
# Create database
createdb techtutors

# Tables will be created automatically on first run
```

</details>

##  AWS Bedrock Setup

### 1. Enable Bedrock Service

1. **Log into AWS Console**
2. **Navigate to Bedrock** service
3. **Select your region** (us-east-1 recommended)
4. **Request Model Access**:
   - Go to "Model access" in left sidebar
   - Request access to "Claude 3 Sonnet"
   - Request access to "Titan Embed Text v1"
   - Wait for approval (usually instant)

### 2. Create IAM User

```json
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

### 3. Get Credentials

1. Create access key for IAM user
2. Add to `.env` file:
   ```
   AWS_ACCESS_KEY_ID=your_access_key
   AWS_SECRET_ACCESS_KEY=your_secret_key
   AWS_DEFAULT_REGION=us-east-1
   ```

##  ElevenLabs Setup (Optional)

1. **Sign up** at [ElevenLabs](https://elevenlabs.io)
2. **Get API key** from dashboard
3. **Add to .env**: `ELEVENLABS_API_KEY=your_key`

Voice features will automatically enable when configured.

##  Testing & Verification

### Automated Verification

**Windows:**
```cmd
# Run verification script
verify-setup.bat
```

**macOS/Linux:**
```bash
chmod +x verify-setup.sh
./verify-setup.sh
```

### Manual Testing

1. **Basic Chat Test**:
   - Send: "I'm getting a 403 error with AWS S3"
   - Expect: Questions about IAM roles, not direct solutions

2. **Voice Test** (if configured):
   - Click "Start Voice" button
   - Speak a question
   - Verify transcript appears
   - Click speaker icon on responses

3. **Code Analysis Test**:
   - Paste code in right panel
   - Click "Analyze Code"
   - Verify mentor asks about the code structure

4. **Hint Progression Test**:
   - Ask a question
   - Click "More Help" to escalate hints
   - Verify responses become more direct

##  Troubleshooting

### Common Issues

<details>
<summary>Connection Error on Frontend</summary>

**Symptoms**: "Connection Error" or "Connecting..." status

**Solutions**:
```bash
# Check if backend is running
curl http://localhost:8000/health

# Check Docker services
docker-compose ps

# View backend logs
docker-compose logs backend
```
</details>

<details>
<summary>AWS Bedrock Errors</summary>

**Symptoms**: "Failed to generate response" errors

**Solutions**:
1. Verify AWS credentials are correct
2. Check if Claude model access is approved
3. Verify region is supported (us-east-1)
4. Test AWS CLI: `aws bedrock list-foundation-models`
</details>

<details>
<summary>Database Connection Issues</summary>

**Symptoms**: Database connection errors

**Solutions**:
```bash
# Check if PostgreSQL container is running
docker-compose ps db

# Check database logs
docker-compose logs db

# Reset database
docker-compose down -v
docker-compose up -d
```
</details>

<details>
<summary>WebSocket Connection Failed</summary>

**Symptoms**: "Disconnected" status, messages not sending

**Solutions**:
1. Check browser console for WebSocket errors
2. Verify backend WebSocket endpoint is accessible
3. Check CORS settings in `backend/main.py`
4. Restart services: `docker-compose restart`
</details>

##  Monitoring & Logs

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### Health Checks

- **Backend**: http://localhost:8000/health
- **API Docs**: http://localhost:8000/docs
- **Frontend**: http://localhost:3000
- **Database**: `docker-compose exec db pg_isready`

##  Production Deployment

### Build for Production

```bash
# Build optimized images
docker-compose -f docker-compose.prod.yml build

# Start production services
docker-compose -f docker-compose.prod.yml up -d
```

### Environment Variables

Set these for production:
```bash
NODE_ENV=production
DATABASE_URL=your_production_db_url
AWS_ACCESS_KEY_ID=your_production_aws_key
AWS_SECRET_ACCESS_KEY=your_production_aws_secret
ELEVENLABS_API_KEY=your_production_elevenlabs_key
```

##  Contributing

1. **Follow Socratic Principles**: Never provide direct answers
2. **Maintain Architecture**: Keep dual-agent system intact
3. **Add Tests**: Include tests for new features
4. **Update Documentation**: Keep guides current

##  License

MIT License - see LICENSE file for details.

##  Quick Verification Checklist

- [ ] Docker services running (`docker-compose ps`)
- [ ] Backend health check passes (http://localhost:8000/health)
- [ ] Frontend loads (http://localhost:3000)
- [ ] WebSocket shows "Connected" status
- [ ] AWS Bedrock credentials configured
- [ ] Test message receives Socratic questions
- [ ] Voice features work (if configured)
- [ ] Code panel accepts input
- [ ] No console errors

---

##  Ready to Learn?

Visit **http://localhost:3000** and start your Socratic learning journey!


Try asking: *"I'm getting a 403 error with AWS S3"* and experience the difference! 🧠✨
