# FastAPI Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic App Structure](#basic-app-structure)
- [Path Parameters](#path-parameters)
- [Query Parameters](#query-parameters)
- [Request Body](#request-body)
- [Response Model](#response-model)
- [Validation](#validation)
- [Dependency Injection](#dependency-injection)
- [Authentication and Authorization](#authentication-and-authorization)
- [Background Tasks](#background-tasks)
- [Middleware](#middleware)
- [Exception Handling](#exception-handling)
- [CORS](#cors)
- [WebSocket Support](#websocket-support)
- [Testing with FastAPI](#testing-with-fastapi)
- [Database Integration (SQLAlchemy Example)](#database-integration-sqlalchemy-example)
- [Asynchronous Programming](#asynchronous-programming)
- [Deployment](#deployment)
- [Advanced Features](#advanced-features)
- [Performance Tips](#performance-tips)
- [References](#references)

## Introduction
FastAPI is a modern, fast (high-performance) web framework for building APIs with Python 3.7+ based on standard Python type hints.

## Installation
```bash
pip install fastapi
pip install "uvicorn[standard]"  # ASGI server
```

## Basic App Structure
```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

# Run with:
# uvicorn main:app --reload
```

## Path Parameters
```python
@app.get("/items/{item_id}")
def read_item(item_id: int):
    return {"item_id": item_id}
```

## Query Parameters
```python
@app.get("/items/")
def read_item(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}
```

## Request Body
```python
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    description: str = None
    price: float
    tax: float = None

@app.post("/items/")
def create_item(item: Item):
    return item
```

## Response Model
```python
@app.post("/items/", response_model=Item)
def create_item(item: Item):
    return item
```

## Validation
- FastAPI uses Pydantic for data validation
- Automatic validation of input data
- Custom validators with `@validator` in Pydantic models
- Nested models for complex schemas

## Dependency Injection
```python
from fastapi import Depends

def common_parameters(q: str = None, skip: int = 0, limit: int = 10):
    return {"q": q, "skip": skip, "limit": limit}

@app.get("/items/")
def read_items(commons: dict = Depends(common_parameters)):
    return commons
```

## Authentication and Authorization
- OAuth2 Password Flow
- API Keys
- JWT Authentication

Example OAuth2:
```python
from fastapi.security import OAuth2PasswordBearer

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

@app.get("/users/me")
def read_users_me(token: str = Depends(oauth2_scheme)):
    return {"token": token}
```

## Background Tasks
```python
from fastapi import BackgroundTasks

def write_log(message: str):
    with open("log.txt", "a") as f:
        f.write(message)

@app.post("/send_notification/")
def send_notification(background_tasks: BackgroundTasks, email: str):
    background_tasks.add_task(write_log, f"Notification sent to {email}")
    return {"message": "Notification sent"}
```

## Middleware
```python
from fastapi import Request
from fastapi.middleware.cors import CORSMiddleware

@app.middleware("http")
async def add_process_time_header(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Process-Time"] = "123"
    return response
```

## Exception Handling
```python
from fastapi import HTTPException

@app.get("/items/{item_id}")
def read_item(item_id: int):
    if item_id == 3:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"item_id": item_id}
```

## CORS
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

## WebSocket Support
```python
from fastapi import WebSocket

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        await websocket.send_text(f"Message text was: {data}")
```

## Testing with FastAPI
```python
from fastapi.testclient import TestClient

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"Hello": "World"}
```

## Database Integration (SQLAlchemy Example)
```python
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)

Base.metadata.create_all(bind=engine)

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```

## Asynchronous Programming
- Use `async def` for non-blocking endpoints
- Await I/O operations like database calls, HTTP requests

Example:
```python
@app.get("/async-items/")
async def get_items():
    await some_async_function()
    return {"message": "Done"}
```

## Deployment
```bash
# Run Uvicorn in production mode
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
```
- Use Gunicorn + Uvicorn workers for large-scale deployments
- Use Docker for containerization
- Enable logging and monitoring with Prometheus and Grafana

## Advanced Features
- **Dependency Overrides** for testing
- **Lifespan Events**: startup and shutdown handlers
- **Streaming Responses**
- **Custom Response Classes**: `HTMLResponse`, `StreamingResponse`, `FileResponse`

Example Startup Event:
```python
@app.on_event("startup")
async def startup_event():
    print("Starting up...")
```

Example Streaming Response:
```python
from fastapi.responses import StreamingResponse

@app.get("/stream")
async def stream_file():
    def iterfile():
        for i in range(100):
            yield f"Line {i}\n"
    return StreamingResponse(iterfile())
```

## Performance Tips
- Prefer `async def` for endpoints doing I/O
- Use connection pooling for databases
- Reduce validation overhead with lightweight Pydantic models
- Enable gzip compression
- Serve static assets using a CDN

## References
- [FastAPI Official Documentation](https://fastapi.tiangolo.com/)
- [Pydantic Official Documentation](https://docs.pydantic.dev/)
- [Uvicorn ASGI Server](https://www.uvicorn.org/)

