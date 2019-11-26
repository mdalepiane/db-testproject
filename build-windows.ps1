$msbuild='C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe'
& $msbuild .\db-testproject\db-testproject.sln /p:OutDir='db-artifacts'

$dacpac_file="db-testproject/db-testproject/db-artifacts/db-testproject.dacpac"
docker build -f .\Dockerfile-windows -t db-testproject --build-arg TARGET_DB_NAME="db-testproject" --build-arg DACPAC_FILE=$dacpac_file .