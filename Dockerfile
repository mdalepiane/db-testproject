FROM mcr.microsoft.com/mssql/server AS builder

USER root
RUN apt-get update
RUN apt-get install unzip dotnet-sdk-2.2 -y --no-install-recommends
RUN wget -q -O /var/opt/sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2069122
RUN unzip -qq /var/opt/sqlpackage.zip -d /var/opt/sqlpackage
RUN chmod +x /var/opt/sqlpackage/sqlpackage

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=@Pa55word

COPY ./drop/db-testproject.dacpac /tmp/database.dacpac

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