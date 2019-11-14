#FROM alpine AS base
FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install unzip -y \
    && apt-get install wget -y \
    && wget -q -O /var/opt/sqlpackage.zip https://go.microsoft.com/fwlink/?linkid=2108814 \
    && unzip -qq /var/opt/sqlpackage.zip -d /var/opt/sqlpackage \
    && rm /var/opt/sqlpackage.zip \
    && chmod +x /var/opt/sqlpackage/sqlpackage \
    && wget -q -O /tmp/dotnet-install.sh https://dot.net/v1/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh

COPY ./db-testproject/db-testproject/db-artifacts/**dacpac /artifacts/

ARG database_name="db-testproject"
ARG sql_server="db-testproject"
ARG sql_user="sa"
ARG sql_password="@Pa55word"

RUN echo "/var/opt/sqlpackage/sqlpackage /SourceFile:/artifacts/*.dacpac \
    /a:Script /TargetServerName:$sql_server /TargetDatabaseName:$database_name \
    /TargetUser:$sql_user /TargetPassword:$sql_password /OutputPath:\"./$database_name.sql\" \
    /p:ExcludeObjectTypes=\"Logins;Users;Permissions;ServerRoleMembership;ServerRoles;DatabaseRoles\""

RUN /var/opt/sqlpackage/sqlpackage /SourceFile:/artifacts/*.dacpac \
    /a:Script /TargetServerName:$sql_server /TargetDatabaseName:$database_name \
    /TargetUser:$sql_user /TargetPassword:$sql_password /OutputPath:"./$database_name.sql" \
    /p:ExcludeObjectTypes="Logins;Users;Permissions;ServerRoleMembership;ServerRoles;DatabaseRoles"