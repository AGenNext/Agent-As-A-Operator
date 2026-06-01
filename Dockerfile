# Build stage
FROM python:3.11-slim AS builder

WORKDIR /build

# Install dependencies
RUN pip install --no-cache-dir --user \
    fastapi \
    uvicorn \
    kubernetes \
    langchain \
    pydantic

# Production stage
FROM gcr.io/distroless/python3-debian11

WORKDIR /app

# Copy dependencies from builder
COPY --from=builder /root/.local /app/.local

# Copy application
COPY ./src /app/src
COPY ./config /app/config

# Set Python path
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# Non-root user
USER 1000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/ready')"

# Expose port
EXPOSE 8080

# Run
CMD ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]