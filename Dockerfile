# Stage 1: Clone repo and prepare dependencies
FROM python:3.11-slim AS builder

WORKDIR /app

# Fix: Corrected GitHub URL (missing slash after "github.com/")
RUN apt-get update && apt-get install -y git \
    && git clone https://github.com/assafelovic/gptr-mcp.git gptr-mcp

# Stage 2: Final image
FROM python:3.11-slim

WORKDIR /app
ENV MCP_TRANSPORT=sse
ENV DOCKER_CONTAINER=true
ENV PYTHONUNBUFFERED=1
# Copy necessary files from builder
COPY --from=builder /app/gptr-mcp/requirements.txt .
COPY --from=builder /app/gptr-mcp/*.py .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "server.py"]
