FROM python:2.7
ADD schema.sql /
ADD requirements.txt /
ADD createdb.py /
ADD app_b.py /
RUN pip install -r requirements.txt
RUN [ "python", "./createdb.py" ]
CMD [ "python", "./app_b.py" ]
