FROM python:3.11

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY main.py .

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "main.py"]