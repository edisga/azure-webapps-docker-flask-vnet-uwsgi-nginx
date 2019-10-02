FROM tiangolo/uwsgi-nginx-flask:python3.7
RUN pip install pandas sqlalchemy keras --upgrade
RUN apt-get update && apt-get install -y --no-install-recommends g++ curl wget gnupg curl unixodbc unixodbc-dev net-tools
COPY app /app
WORKDIR /app