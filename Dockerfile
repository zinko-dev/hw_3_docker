FROM python:3.13-slim

WORKDIR /app

COPY app/ .

EXPOSE 8000

RUN python -m pip install --no-cache-dir -r requirements.txt

USER 10001:10001

CMD ["python", "app.py"]