FROM python:3.11-slim

# Avoid Python writing .pyc files + buffer issues
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Workdir inside container
WORKDIR /app

# Install Django directly (since no requirements.txt)
RUN pip install --no-cache-dir django python-dotenv

# Copy your whole project
COPY . /app/

# Expose Django’s default port
EXPOSE 8000

# Run Django dev server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
