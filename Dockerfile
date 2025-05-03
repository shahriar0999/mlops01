# Use a lightweight python image
FROM python:3.9-slim

# Set environment variables to prevent Python from writing .pyc files & Ensure Python output is not buffered
# This reduces the docker image size further
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Copy only the requirements file to leverage Docker cache
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Train the model model before running the application
RUN python train.py

# Expose the port
EXPOSE 8502

# Run the application
CMD ["python", "app.py"]