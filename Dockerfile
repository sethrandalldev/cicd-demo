FROM python:3.11-slim
WORKDIR /app

# Install runtime deps
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

ENV PORT=8080
EXPOSE ${PORT}

CMD ["python", "app.py"]
