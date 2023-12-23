FROM python:3

WORKDIR /app

# MSSQL ODBC Driver
RUN mkdir -p /etc/apt/keyrings \
    && curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-prod.gpg \
    && curl -sSL https://packages.microsoft.com/config/debian/12/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    # Install ODBC Driver 17 for SQL Server (does not include SQLCMD)
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    # Optional 1: for bcp and sqlcmd
    && ACCEPT_EULA=Y apt-get install -y mssql-tools \
    # Optional 1: export the connection string to set up the SQLCMD environment variable
    && echo 'export PATH="$PATH:/opt/mssql-tools17/bin"' >> ~/.bashrc \
    # Optional 2: for unixODBC development headers
    && apt-get install -y unixodbc-dev \
    && apt-get install -y libgssapi-krb5-2
    
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

COPY result_lists.py .

EXPOSE 8000

CMD ["uvicorn", "result_lists:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
