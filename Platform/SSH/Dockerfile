FROM python:3

WORKDIR /app

RUN pip install --no-cache-dir --upgrade sshtunnel

COPY set-tunnel.py .

EXPOSE 1438
CMD ["python", "set-tunnel.py"]
