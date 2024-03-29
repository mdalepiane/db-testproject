FROM mcr.microsoft.com/mssql/server AS builder

# Improve build time
# See http://donovanbrown.com/post/Stop-wasting-time-during-NET-Core-builds
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

USER root
RUN apt-get update
RUN apt-get install unzip dotnet-sdk-3.0 -y --no-install-recommends
RUN wget -q -O /var/opt/sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2108814
RUN unzip -qq /var/opt/sqlpackage.zip -d /var/opt/sqlpackage
RUN chmod +x /var/opt/sqlpackage/sqlpackage

ARG DACPAC_FILE
ARG TARGET_DB_NAME

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=@Pa55word

COPY $DACPAC_FILE /tmp/database.dacpac

RUN (/opt/mssql/bin/sqlservr --accept-eula &) | grep -q "Service Broker manager has started" \
    && /var/opt/sqlpackage/sqlpackage /SourceFile:/tmp/database.dacpac \
    /a:Script /TargetServerName:localhost /TargetDatabaseName:$TARGET_DB_NAME \
    /TargetUser:sa /TargetPassword:@Pa55word \
    /OutputPath:"/tmp/database.sql" \
    /p:ExcludeObjectTypes="Logins;Users;Permissions;ServerRoleMembership;ServerRoles;DatabaseRoles"


FROM mcr.microsoft.com/mssql/server AS final

ARG SA_PASSWORD=@Pa55word

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=$SA_PASSWORD

COPY --from=builder /tmp/database.sql .

RUN (/opt/mssql/bin/sqlservr --accept-eula &) | grep -q "Service Broker manager has started" \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -i database.sql \
    && /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -q SHUTDOWN -o /dev/null || true