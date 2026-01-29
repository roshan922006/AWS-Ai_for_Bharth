# TechTutors - System Design Document

## Executive Summary

TechTutors is an AI-powered learning platform that revolutionizes developer education through the Socratic method. Instead of providing direct solutions, it guides developers to discover answers through progressive questioning, building deeper understanding and problem-solving skills.

## Design Philosophy

### Core Principles

1. **Never Give Direct Answers**: The system transforms all solutions into guiding questions
2. **Progressive Learning**: Three-tier hint system from subtle to direct guidance
3. **Contextual Awareness**: Adapts to user's environment, experience, and past interactions
4. **Real-time Interaction**: Seamless WebSocket communication for natural conversation flow
5. **Multimodal Learning**: Support for text, voice, and code analysis

### Socratic Method Implementation

The system implements the Socratic method through:
- **Diagnostic Analysis**: Understanding the root cause before questioning
- **Question Transformation**: Converting solutions into discovery-oriented questions
- **Progressive Hints**: Escalating guidance while maintaining questioning approach
- **Context Preservation**: Building on previous interactions for deeper learning

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Frontend Layer                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │   Chat UI       │  │   Voice UI      │  │   Code Panel    │ │
│  │   (React)       │  │   (Web Speech)  │  │   (Monaco)      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
│                              │                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │              WebSocket Context Manager                      │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────▼─────────┐
                    │   API Gateway     │
                    │   (FastAPI)       │
                    └─────────┬─────────┘
                              │
┌─────────────────────────────▼─────────────────────────────────────┐
│                      Backend Services                             │
│                                                                   │
│  ┌─────────────────┐              ┌─────────────────┐            │
│  │ Diagnostic      │              │ Socratic        │            │
│  │ Agent           │◄────────────►│ Agent           │            │
│  │                 │              │                 │            │
│  │ • Issue Analysis│              │ • Question Gen  │            │
│  │ • RAG Retrieval │              │ • Hint Levels   │            │
│  │ • Root Cause    │              │ • Context Adapt │            │
│  └─────────────────┘              └─────────────────┘            │
│           │                                │                     │
│  ┌────────▼────────┐              ┌───────▼────────┐            │
│  │ RAG Service     │              │ Session Service │            │
│  │                 │              │                 │            │
│  │ • FAISS Index   │              │ • User Context  │            │
│  │ • Embeddings    │              │ • Progress Track│            │
│  │ • Doc Retrieval │              │ • Hint History  │            │
│  └─────────────────┘              └────────────────┘            │
│                                                                   │
│  ┌─────────────────┐              ┌─────────────────┐            │
│  │ Bedrock Service │              │ Voice Services  │            │
│  │                 │              │                 │            │
│  │ • Claude 3      │              │ • ElevenLabs    │            │
│  │ • Embeddings    │              │ • Speech-to-Text│            │
│  │ • Model Mgmt    │              │ • Text-to-Speech│            │
│  └─────────────────┘              └─────────────────┘            │
└───────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────▼─────────────────────────────────────┐
│                      Data Layer                                   │
│                                                                   │
│  ┌─────────────────┐              ┌─────────────────┐            │
│  │ PostgreSQL      │              │ Redis Cache     │            │
│  │                 │              │                 │            │
│  │ • Sessions      │              │ • Session State │            │
│  │ • User Progress │              │ • WebSocket Mgmt│            │
│  │ • Interactions  │              │ • Temp Data     │            │
│  └─────────────────┘              └─────────────────┘            │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                 FAISS Vector Store                          │ │
│  │                                                             │ │
│  │ • Documentation Embeddings                                  │ │
│  │ • Semantic Search Index                                     │ │
│  │ • Knowledge Base Vectors                                    │ │
│  └─────────────────────────────────────────────────────────────┘ │
└───────────────────────────────────────────────────────────────────┘
```

### Component Interaction Flow

```
User Input → WebSocket → API Gateway → Dual Agent System → Response Generation
     ↑                                        ↓
     └── Real-time Response ←── WebSocket ←── Session Update
```

## Core Components Design

### 1. Dual-Agent System

#### Diagnostic Agent
**Purpose**: Analyze user issues and identify root causes using RAG

**Key Responsibilities**:
- Extract structured information from user messages
- Retrieve relevant documentation via RAG service
- Perform root cause analysis using LLM
- Assess technical complexity and environment factors

**Design Pattern**: Service Layer with dependency injection

```python
class DiagnosticAgent:
    def __init__(self):
        self.rag_service = RAGService()
        self.bedrock_service = BedrockService()
    
    async def analyze(self, user_message: str, session_id: str) -> DiagnosticResult:
        # 1. Extract issue information
        # 2. Retrieve relevant docs via RAG
        # 3. Analyze with LLM
        # 4. Return structured diagnostic
```

#### Socratic Agent
**Purpose**: Transform diagnostic results into Socratic questions and progressive hints

**Key Responsibilities**:
- Convert solutions into guiding questions
- Implement three-tier hint progression
- Maintain Socratic principles (never give direct answers)
- Adapt questioning style to user experience level

**Design Pattern**: Strategy Pattern for hint levels

```python
class SocraticAgent:
    def __init__(self):
        self.question_templates = {
            HintLevel.SUBTLE: [...],
            HintLevel.MODERATE: [...],
            HintLevel.DIRECT: [...]
        }
    
    async def transform_to_questions(
        self, diagnostic_result: DiagnosticResult, 
        hint_level: HintLevel, session_id: str
    ) -> SocraticResponse:
        # Transform diagnostic into questions
```

### 2. RAG (Retrieval-Augmented Generation) System

**Purpose**: Provide contextual knowledge retrieval for accurate diagnostics

**Architecture**:
- **Embedding Model**: SentenceTransformers (all-MiniLM-L6-v2)
- **Vector Store**: FAISS with cosine similarity
- **Knowledge Base**: AWS documentation, best practices, common issues

**Design Features**:
- Semantic search with relevance scoring
- Environment-specific filtering (AWS, Azure, GCP)
- Incremental document addition
- Persistent index storage

```python
class RAGService:
    def __init__(self):
        self.embedding_model = SentenceTransformer('all-MiniLM-L6-v2')
        self.index = faiss.IndexFlatIP(384)  # 384-dim embeddings
    
    async def search(self, query: str, top_k: int = 5) -> List[RAGResult]:
        # Generate query embedding
        # Search FAISS index
        # Return ranked results
```

### 3. Session Management System

**Purpose**: Track user context, progress, and learning patterns

**Key Features**:
- Session-based user tracking
- Hint level progression management
- Conversation history persistence
- Learning analytics collection

**Data Model**:
```python
class Session:
    session_id: str
    user_context: Dict[str, Any]
    hint_level: HintLevel
    interaction_history: List[Interaction]
    created_at: datetime
    last_active: datetime
```

### 4. WebSocket Communication Layer

**Purpose**: Enable real-time bidirectional communication

**Design Features**:
- Connection management with auto-reconnection
- Message queuing for offline scenarios
- Session-based routing
- Error handling and recovery

**Message Flow**:
```typescript
interface WebSocketMessage {
    type: 'user_message' | 'socratic_response' | 'system_event'
    content: string
    session_id: string
    metadata?: any
}
```

## Frontend Architecture

### Component Hierarchy

```
App Layout
├── Header (Connection Status, Settings)
├── Main Content
│   ├── Chat Interface
│   │   ├── Message List
│   │   ├── Message Input
│   │   └── Hint Controls
│   ├── Code Panel (Optional)
│   │   ├── Code Editor
│   │   └── Analysis Tools
│   └── Voice Interface (Optional)
│       ├── Recording Controls
│       └── Transcript Display
└── Footer (Tips, Status)
```

### State Management

**Context Providers**:
- `WebSocketContext`: Real-time communication state
- `SessionContext`: User session and progress state

**State Flow**:
```typescript
User Action → Component State → Context Update → WebSocket Message → Backend Processing → Response → UI Update
```

### Key Design Patterns

1. **Provider Pattern**: Context-based state management
2. **Observer Pattern**: WebSocket message handling
3. **Component Composition**: Reusable UI components
4. **Hooks Pattern**: Custom hooks for complex logic

## Data Models & Schemas

### Core Entities

#### Message Flow Schema
```python
class ChatRequest(BaseModel):
    message: str
    session_id: str
    hint_level: HintLevel
    environment: Optional[Dict[str, Any]]
    code_context: Optional[str]

class ChatResponse(BaseModel):
    content: str
    hint_level: HintLevel
    has_more_hints: bool
    session_id: str
    suggested_questions: Optional[List[str]]
    resources: Optional[List[str]]
```

#### Diagnostic Schema
```python
class DiagnosticResult(BaseModel):
    issue_type: str
    root_cause: str
    context: List[str]
    confidence: float
    environment_factors: Dict[str, Any]

class SocraticResponse(BaseModel):
    content: str
    hint_level: HintLevel
    has_more_hints: bool
    reasoning_path: List[str]
    next_questions: List[str]
```

### Database Schema

#### Sessions Table
```sql
CREATE TABLE sessions (
    id UUID PRIMARY KEY,
    user_id VARCHAR(255),
    created_at TIMESTAMP,
    last_active TIMESTAMP,
    hint_level INTEGER DEFAULT 1,
    context JSONB,
    environment JSONB
);
```

#### Interactions Table
```sql
CREATE TABLE interactions (
    id UUID PRIMARY KEY,
    session_id UUID REFERENCES sessions(id),
    user_message TEXT,
    mentor_response TEXT,
    hint_level INTEGER,
    timestamp TIMESTAMP,
    diagnostic_data JSONB
);
```

## AI/ML Integration Design

### AWS Bedrock Integration

**Model Selection**:
- **Primary LLM**: Claude 3 Sonnet (anthropic.claude-3-sonnet-20240229-v1:0)
- **Embedding Model**: Titan Embed Text v1 (amazon.titan-embed-text-v1)

**Service Design**:
```python
class BedrockService:
    def __init__(self):
        self.client = boto3.client('bedrock-runtime')
        self.model_id = "anthropic.claude-3-sonnet-20240229-v1:0"
    
    async def generate_response(self, prompt: str, **kwargs) -> str:
        # Handle model-specific request formatting
        # Invoke Bedrock model
        # Parse and return response
```

**Prompt Engineering Strategy**:
- Structured prompts with clear role definitions
- JSON response formatting for consistent parsing
- Context injection for personalized responses
- Validation rules to ensure Socratic compliance

### Voice Processing Integration

**ElevenLabs Integration**:
- Text-to-speech for mentor responses
- Voice cloning for consistent personality
- Streaming audio for real-time experience

**Browser Speech API**:
- Speech-to-text for user input
- Real-time transcription display
- Fallback to audio upload for unsupported browsers

## Security & Privacy Design

### Authentication & Authorization
- Session-based authentication with secure tokens
- No persistent user accounts (privacy-focused)
- Session data encryption at rest

### Data Protection
- Conversation data encrypted in database
- No logging of sensitive information
- GDPR-compliant data handling
- Automatic session cleanup after inactivity

### API Security
- CORS configuration for cross-origin requests
- Input validation and sanitization
- Rate limiting to prevent abuse
- SQL injection prevention through ORM

### Network Security
- HTTPS enforcement in production
- WebSocket security with origin validation
- Secure API key management via environment variables

## Performance & Scalability Design

### Response Time Targets
- **Chat Response**: < 3 seconds end-to-end
- **WebSocket Connection**: < 1 second establishment
- **Voice Synthesis**: < 2 seconds for audio generation
- **RAG Search**: < 500ms for document retrieval

### Scalability Strategies

#### Horizontal Scaling
- Stateless backend services for easy scaling
- Load balancing across multiple instances
- Database connection pooling
- Redis for session state sharing

#### Caching Strategy
- Redis for session data caching
- FAISS index caching in memory
- CDN for static assets
- Response caching for common queries

#### Resource Optimization
- Async/await patterns for I/O operations
- Connection pooling for database and external APIs
- Lazy loading for large components
- Efficient vector operations with NumPy

### Monitoring & Observability

#### Metrics Collection
- Response time monitoring
- Error rate tracking
- User engagement analytics
- Resource utilization metrics

#### Logging Strategy
- Structured logging with JSON format
- Log levels: DEBUG, INFO, WARN, ERROR
- Request/response logging for API calls
- Error tracking with stack traces

## Deployment Architecture

### Container Strategy
```dockerfile
# Multi-stage builds for optimization
FROM node:18-alpine AS frontend-build
# Frontend build steps

FROM python:3.11-slim AS backend-build  
# Backend setup steps

FROM nginx:alpine AS production
# Production configuration
```

### Environment Configuration
- **Development**: Docker Compose with hot reload
- **Staging**: Kubernetes with resource limits
- **Production**: Auto-scaling with load balancers

### CI/CD Pipeline
1. **Code Quality**: ESLint, Prettier, Python linting
2. **Testing**: Unit tests, integration tests, E2E tests
3. **Security**: Dependency scanning, SAST analysis
4. **Deployment**: Blue-green deployment strategy

## Error Handling & Recovery

### Frontend Error Handling
- WebSocket reconnection with exponential backoff
- Graceful degradation for voice features
- User-friendly error messages
- Offline mode with message queuing

### Backend Error Handling
- Circuit breaker pattern for external APIs
- Retry logic with exponential backoff
- Fallback responses for AI service failures
- Comprehensive error logging

### Data Recovery
- Database backups with point-in-time recovery
- Session state recovery from Redis
- FAISS index backup and restoration
- Configuration backup procedures

## Testing Strategy

### Unit Testing
- **Backend**: pytest with mocking for external services
- **Frontend**: Jest and React Testing Library
- **Coverage Target**: 80% minimum

### Integration Testing
- API endpoint testing with real database
- WebSocket communication testing
- AI service integration testing
- Voice processing pipeline testing

### End-to-End Testing
- User journey testing with Playwright
- Cross-browser compatibility testing
- Performance testing under load
- Accessibility testing (WCAG 2.1 AA)

## Future Extensibility

### Plugin Architecture
- Modular agent system for new learning domains
- Configurable hint strategies
- Custom knowledge base integration
- Third-party LLM provider support

### API Extensibility
- RESTful API design for external integrations
- Webhook support for external notifications
- GraphQL endpoint for flexible data queries
- OpenAPI specification for documentation

### Learning Analytics
- Advanced progress tracking
- Learning pattern analysis
- Personalized learning paths
- Instructor dashboard for educational institutions

## Conclusion

TechTutors represents a sophisticated implementation of AI-powered Socratic learning, combining modern web technologies with advanced AI capabilities. The dual-agent architecture ensures consistent application of the Socratic method while the RAG system provides accurate, contextual information retrieval.

The system's design prioritizes:
- **Educational Effectiveness**: Never compromising on the Socratic principle
- **Technical Excellence**: Modern, scalable architecture
- **User Experience**: Seamless, multimodal interaction
- **Maintainability**: Clean code, comprehensive testing, clear documentation

This design provides a solid foundation for revolutionizing developer education through AI-guided discovery learning.