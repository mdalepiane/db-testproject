FROM mcr.microsoft.com/mssql/server AS builder

USER root
RUN apt-get update
RUN apt-get install unzip dotnet-sdk-2.2 -y --no-install-recommends
RUN wget -q -O /var/opt/sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2069122
RUN unzip -qq /var/opt/sqlpackage.zip -d /var/opt/sqlpackage
RUN chmod +x /var/opt/sqlpackage/sqlpackage

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=@Pa55word

COPY ./db-testproject.dacpac /tmp/database.dacpac

RUN (/opt/mssql/bin/sqlservr --accept-eula &) | grep -q "Service Broker manager has started" \
    && /var/opt/sqlpackage/sqlpackage /SourceFile:/tmp/database.dacpac \
    /a:Script /TargetServerName:localhost /TargetDatabaseName:"db-testproject" \
    /TargetUser:sa /TargetPassword:@Pa55word \
    /OutputPath:"/tmp/database.sql" \
    /p:ExcludeObjectTypes="Logins;Users;Permissions;ServerRoleMembership;ServerRoles;DatabaseRoles"


FROM mcr.microsoft.com/mssql/server AS final

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=@Pa55word

COPY --from=builder /tmp/database.sql .

RUN (/opt/mssql/bin/sqlservr --accept-eula &) | grep -q "Service Broker manager has started" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P @Pa55word -i database.sql

#RUN /var/opt/sqlpacage/sqlpackage /a:Publish /tdn:<db_name> \
#         /pr:/var/opt/<project_dir>/docker.publish.xml /sf:/var/opt/<project_dir>/bin/Debug/<project-name>.dacpac \
#         /p:IncludeCompositeObjects=true /tu:sa /tp:$SA_PASSWORD \
#RUN sqlpackage


#FROM ubuntu AS builder

#RUN apt-get update
#RUN apt-get install wget unzip -y
#RUN wget -O /tmp/sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2069122
#RUN unzip -o /tmp/sqlpackage.zip -d /var/opt/sqlpackage
#RUN chmod +x /var/opt/sqlpackage/sqlpackage
#RUN ln -sf /var/opt/sqlpackage/sqlpackage /usr/bin/sqlpackage
#RUN echo '{"runtimeOptions": {"configProperties": {"System.Globalization.Invariant": true}}}' > /var/opt/sqlpackage/sqlpackage.runtimeconfig.json
#RUN sqlpackage
# This far I'm able to run sqlpackage


#FROM mcr.microsoft.com/mssql-tools AS runner

#RUN apt-get update
#RUN apt-get install wget -y
#RUN apt-get install gnupg -y
#RUN apt-get install software-properties-common -y
#RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#RUN add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"
#RUN apt-get update
#RUN apt-get install curl -y
#RUN apt-get install unzip -y
#RUN apt-get install mssql-tools unixodbc-dev -y
#RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
#RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
#RUN source ~/.bashrc
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