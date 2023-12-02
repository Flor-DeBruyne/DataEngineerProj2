from sshtunnel import SSHTunnelForwarder
import time

## Define SSH credentials
ssh_host = 'vichogent.be'
ssh_port = 40096
ssh_username = 'testing_account'
ssh_password = 'testing123'

## Define the tunnel details
local_port = 1438
remote_host = 'localhost'
remote_port = 1433

## Create
with SSHTunnelForwarder(
    (ssh_host, ssh_port),
    ssh_username=ssh_username,
    ssh_password=ssh_password,
    remote_bind_address=(remote_host, remote_port),
    local_bind_address=('0.0.0.0', local_port)
) as tunnel:
    print("SSH tunnel is open")

    try:
        while True:
            time.sleep(100)
    except KeyboardInterrupt:
        pass


