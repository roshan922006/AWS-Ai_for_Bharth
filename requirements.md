# TechTutors - System Requirements

## Project Overview

TechTutors is a production-ready AI-powered learning assistant that helps developers learn through Socratic questioning methodology. Instead of providing direct solutions, it guides users to discover answers through progressive questioning and hints.

## Core Architecture

### System Components
- **Frontend**: Next.js 14 with TypeScript and Tailwind CSS
- **Backend**: FastAPI with Python 3.11+
- **Database**: PostgreSQL 15+ with SQLAlchemy ORM
- **Cache**: Redis for session management
- **AI Services**: AWS Bedrock (Claude 3 Sonnet) + ElevenLabs (optional voice)
- **Vector Database**: FAISS for RAG (Retrieval-Augmented Generation)
- **Communication**: WebSocket for real-time chat

### Dual-Agent System
1. **Diagnostic Agent**: Analyzes user issues using RAG and documentation
2. **Socratic Agent**: Transforms solutions into progressive questioning sequences

## Technical Requirements

### Backend Requirements

#### Core Dependencies
```
fastapi==0.104.1
uvicorn[standard]==0.24.0
websockets==12.0
pydantic==2.5.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
alembic==1.13.1
redis==5.0.1
boto3==1.34.0
faiss-cpu==1.7.4
sentence-transformers==2.2.2
numpy==1.24.3
python-multipart==0.0.6
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
httpx==0.25.2
openai==1.3.7
elevenlabs==0.2.26
```

#### System Requirements
- **Python**: 3.11 or higher
- **Memory**: Minimum 4GB RAM (8GB recommended for FAISS operations)
- **Storage**: 2GB for vector embeddings and knowledge base
- **Network**: Internet access for AWS Bedrock and ElevenLabs APIs

### Frontend Requirements

#### Core Dependencies
```json
{
  "next": "14.0.4",
  "react": "^18.2.0",
  "react-dom": "^18.2.0",
  "typescript": "^5.3.3",
  "tailwindcss": "^3.3.6",
  "framer-motion": "^10.16.16",
  "react-markdown": "^9.0.1",
  "react-syntax-highlighter": "^15.5.0",
  "ws": "^8.14.2"
}
```

#### System Requirements
- **Node.js**: 18.0 or higher
- **NPM**: 9.0 or higher
- **Browser**: Modern browsers with WebSocket and Web Speech API support
- **Memory**: 2GB RAM minimum

### Database Requirements

#### PostgreSQL Setup
- **Version**: PostgreSQL 15 or higher
- **Extensions**: None required (using standard SQL)
- **Storage**: 1GB minimum for session data and user progress
- **Connections**: Support for 100+ concurrent connections

#### Redis Setup
- **Version**: Redis 7 or higher
- **Memory**: 512MB minimum for session caching
- **Persistence**: Optional (used for temporary session data)

## External Service Requirements

### AWS Bedrock (Required)
- **Models Required**:
  - Claude 3 Sonnet (for conversational AI)
  - Titan Embed Text v1 (for embeddings)
- **Permissions**:
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
- **Regions**: us-east-1 (recommended), us-west-2, eu-west-1
- **Rate Limits**: Standard Bedrock limits apply

### ElevenLabs (Optional - Voice Features)
- **API Key**: Required for text-to-speech functionality
- **Voice Models**: Any available voice model
- **Rate Limits**: Based on subscription tier
- **Audio Format**: MP3 output supported

## Environment Configuration

### Required Environment Variables

#### Backend (.env)
```bash
# Database
DATABASE_URL=postgresql://postgres:password@localhost:5432/techtutors

# Redis (optional)
REDIS_URL=redis://localhost:6379

# AWS Bedrock (required)
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_DEFAULT_REGION=us-east-1

# ElevenLabs (optional)
ELEVENLABS_API_KEY=your_elevenlabs_api_key

# Application
DEBUG=false
LOG_LEVEL=INFO
```

#### Frontend (.env.local)
```bash
# API Endpoints
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_WS_URL=ws://localhost:8000

# Application
NODE_ENV=development
```

## Functional Requirements

### Core Features

#### 1. Socratic Learning System
- **Never provide direct answers** - always guide through questions
- **Progressive hint system** with 3 levels:
  - Level 1: Subtle hints and guiding questions
  - Level 2: More specific guidance with examples
  - Level 3: Direct guidance while maintaining questioning approach
- **Context awareness** - remember conversation history
- **Adaptive questioning** based on user experience level

#### 2. Dual-Agent Architecture
- **Diagnostic Agent**:
  - Analyze user problems using RAG system
  - Retrieve relevant documentation and examples
  - Identify root causes and solution patterns
  - Generate comprehensive problem analysis

- **Socratic Agent**:
  - Transform diagnostic results into questions
  - Maintain Socratic methodology throughout interaction
  - Provide progressive hints without direct answers
  - Adapt questioning style to user responses

#### 3. Real-time Communication
- **WebSocket connection** for instant messaging
- **Connection status indicators** in UI
- **Message queuing** for offline scenarios
- **Session persistence** across disconnections

#### 4. Voice Interface (Optional)
- **Speech-to-text** using browser Web Speech API
- **Text-to-speech** using ElevenLabs API
- **Voice activity detection** for natural conversation flow
- **Seamless voice/text switching**

#### 5. Code Analysis
- **Syntax highlighting** for multiple programming languages
- **Code snippet analysis** through Socratic questioning
- **Error log interpretation** with guided discovery
- **Best practices guidance** through questions

#### 6. Session Management
- **User session tracking** with unique identifiers
- **Conversation history** persistence
- **Progress tracking** per topic/technology
- **Learning analytics** and insights

### User Interface Requirements

#### 1. Chat Interface
- **Clean, modern design** with dark/light theme support
- **Message bubbles** with clear user/mentor distinction
- **Typing indicators** during AI response generation
- **Message timestamps** and status indicators
- **Scrollable history** with infinite scroll

#### 2. Code Panel
- **Syntax-highlighted code editor** (read-only display)
- **File upload** for code analysis
- **Copy/paste functionality** for code snippets
- **Multiple language support** (JavaScript, Python, Java, etc.)

#### 3. Voice Controls
- **Push-to-talk** and **voice activation** modes
- **Visual feedback** for voice recording status
- **Audio playback controls** for mentor responses
- **Microphone permission handling**

#### 4. Progress Tracking
- **Hint usage statistics** per session
- **Topic coverage indicators**
- **Learning streak tracking**
- **Session duration metrics**

## Performance Requirements

### Response Times
- **Chat messages**: < 3 seconds for AI response
- **WebSocket connection**: < 1 second establishment
- **Voice synthesis**: < 2 seconds for audio generation
- **Code analysis**: < 5 seconds for complex code snippets

### Scalability
- **Concurrent users**: Support 100+ simultaneous sessions
- **Database queries**: < 100ms for session data retrieval
- **Memory usage**: < 1GB per active session
- **CPU usage**: < 80% under normal load

### Availability
- **Uptime**: 99.5% availability target
- **Error handling**: Graceful degradation for service failures
- **Backup systems**: Database backups every 24 hours
- **Monitoring**: Health checks for all services

## Security Requirements

### Authentication & Authorization
- **Session-based authentication** with secure tokens
- **CORS configuration** for cross-origin requests
- **Input validation** for all user inputs
- **SQL injection prevention** through parameterized queries

### Data Protection
- **Conversation data encryption** at rest
- **Secure API key storage** using environment variables
- **No sensitive data logging** in application logs
- **GDPR compliance** for user data handling

### Network Security
- **HTTPS enforcement** in production
- **WebSocket security** with origin validation
- **Rate limiting** to prevent abuse
- **Input sanitization** for code snippets

## Deployment Requirements

### Development Environment
- **Docker Compose** setup for local development
- **Hot reload** for both frontend and backend
- **Development database** with sample data
- **Debug logging** enabled

### Production Environment
- **Container orchestration** (Docker/Kubernetes)
- **Load balancing** for multiple backend instances
- **SSL/TLS certificates** for HTTPS
- **Environment-specific configuration**
- **Monitoring and logging** infrastructure

### Infrastructure
- **Minimum server specs**:
  - 4 CPU cores
  - 8GB RAM
  - 50GB SSD storage
  - 100Mbps network connection

## Quality Assurance

### Testing Requirements
- **Unit tests** for core business logic
- **Integration tests** for API endpoints
- **End-to-end tests** for critical user flows
- **Performance tests** for load handling
- **Security tests** for vulnerability assessment

### Code Quality
- **TypeScript strict mode** for frontend
- **Python type hints** for backend
- **ESLint/Prettier** for code formatting
- **Code coverage** minimum 80%
- **Documentation** for all public APIs

## Monitoring & Maintenance

### Logging
- **Structured logging** with JSON format
- **Log levels**: DEBUG, INFO, WARN, ERROR
- **Request/response logging** for API calls
- **Error tracking** with stack traces

### Metrics
- **Application performance** monitoring
- **Database query performance**
- **API response times**
- **User engagement metrics**
- **System resource usage**

### Backup & Recovery
- **Database backups** daily with 30-day retention
- **Configuration backups** for environment settings
- **Disaster recovery** procedures documented
- **Recovery time objective**: < 4 hours

## Compliance & Standards

### Accessibility
- **WCAG 2.1 AA compliance** for web interface
- **Keyboard navigation** support
- **Screen reader compatibility**
- **High contrast mode** support

### Standards Compliance
- **REST API** following OpenAPI 3.0 specification
- **WebSocket** protocol compliance
- **HTTP/2** support for improved performance
- **JSON** for all data exchange formats

This requirements document serves as the comprehensive specification for the TechTutors system, covering all technical, functional, and operational aspects needed for successful development and deployment.