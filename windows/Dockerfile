FROM microsoft/mssql-server-windows-developer AS builder

# Improve build time
# See http://donovanbrown.com/post/Stop-wasting-time-during-NET-Core-builds
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1

RUN mkdir 'C:\temp'; \
    Set-DnsClientServerAddress -InterfaceAlias ('Ethernet 2') -ServerAddresses ('8.8.8.8'); \
    Start-BitsTransfer -Source 'https://go.microsoft.com/fwlink/?linkid=2109019' -Destination 'C:\temp\sqlpackage.zip'
RUN Add-Type -AssemblyName System.IO.Compression.FileSystem; \
    [System.IO.Compression.ZipFile]::ExtractToDirectory('C:\temp\sqlpackage.zip', 'C:\tools\sqlpackage');

ARG DACPAC_FILE
ARG TARGET_DB_NAME

COPY $DACPAC_FILE temp/database.dacpac
RUN Start-Job { C:\start.ps1 -sa_password '@Pa55word' -ACCEPT_EULA Y -Verbose }; \
    Do { Write-Host 'Waiting for SQL Server ...'; sqlcmd -S localhost -U sa -P '@Pa55word' -l 1 -o NUL -q exit; Start-Sleep -s 1 } While ($lastexitcode -eq 1); \
    C:\tools\sqlpackage\sqlpackage.exe \
    /SourceFile:temp/database.dacpac \
    /a:Script /TargetServerName:localhost /TargetDatabaseName:$env:TARGET_DB_NAME \
    /TargetUser:sa /TargetPassword:@Pa55word \
    /OutputPath:'C:\temp\database.sql' \
    /p:ExcludeObjectTypes='Logins;Users;Permissions;ServerRoleMembership;ServerRoles;DatabaseRoles'; \
    Remove-Job -Id 1 -Force

FROM microsoft/mssql-server-windows-developer AS final

ARG SA_PASSWORD="@Pa55word"

COPY --from=builder \\temp\\database.sql .
RUN Start-Job { C:\start.ps1 -sa_password '@Pa55word' -ACCEPT_EULA Y -Verbose }; \
    Do { Write-Host 'Waiting for SQL Server ...'; sqlcmd -S localhost -U sa -P '@Pa55word' -l 1 -o NUL -q exit; Start-Sleep -s 1 } While ($lastexitcode -eq 1); \
    sqlcmd -S localhost -U sa -P '@Pa55word' -i database.sql; \
    Stop-Job -Id 1
