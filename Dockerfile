FROM python:3.8.2-slim-buster

LABEL maintainer="mail@jamescross.io"

WORKDIR /usr/src/app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python",  "minikube-hello-world/hello_world.py" ]