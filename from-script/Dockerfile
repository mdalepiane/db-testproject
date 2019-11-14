FROM ubuntu AS builder

RUN apt-get update
RUN apt-get install wget unzip -y
RUN wget -O /tmp/sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2069122
RUN unzip -o /tmp/sqlpackage.zip -d /var/opt/sqlpackage
RUN chmod +x /var/opt/sqlpackage/sqlpackage
RUN ln -sf /var/opt/sqlpackage/sqlpackage /usr/bin/sqlpackage
RUN echo '{"runtimeOptions": {"configProperties": {"System.Globalization.Invariant": true}}}' > /var/opt/sqlpackage/sqlpackage.runtimeconfig.json
RUN sqlpackage
# This far I'm able to run sqlpackage

FROM mcr.microsoft.com/mssql-tools AS runner

RUN apt-get update
RUN apt-get install wget -y
RUN apt-get install gnupg -y
RUN apt-get install software-properties-common -y
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"
RUN apt-get update
RUN apt-get install curl -y
RUN apt-get install unzip -y
RUN apt-get install mssql-tools unixodbc-dev -y
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
RUN source ~/.bashrc
#FROM mcr.microsoft.com/mssql/server AS base

#ARG database_name="db-testproject"
#ARG sql_server="db-testproject"
#ARG sql_user="sa"
#ARG sql_password="@Pa55word"

#COPY ./**.sql /scripts/


#sudo wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"

#sudo apt-get update 
#sudo apt-get install mssql-tools unixodbc-dev -y

#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
#source ~/.bashrc

#RUN sqlcmd -S $database_name -d master -U $sql_user -P $sql_password -i /scripts/*.sql