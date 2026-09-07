FROM python:3.12-alpine

WORKDIR /code

COPY . /code

RUN apk add --update curl 

RUN pip install -r requirements.txt


CMD ["python", "app.py"]