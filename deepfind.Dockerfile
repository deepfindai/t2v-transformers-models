FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
    apt-get install -y build-essential software-properties-common; \    
    apt-add-repository contrib; \
    apt-add-repository non-free; \
    add-apt-repository -y ppa:deadsnakes/ppa; \
    apt-get update; \
    apt-get install -y python3.8 python3-pip
RUN pip install --upgrade pip setuptools

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY custom_prerequisites.py .
RUN ./custom_prerequisites.py

ARG MODEL_NAME
ARG MODEL_PATH

COPY download.py .
RUN ./download.py

COPY . .

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["uvicorn app:app --host 0.0.0.0 --port 8080"]
