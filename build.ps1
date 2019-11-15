$mstest='C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe'
& $mstest .\db-testproject\db-testproject.sln /p:OutDir='db-artifacts'

$dacpac_file="db-testproject/db-testproject/db-artifacts/db-testproject.dacpac"
docker build -t db-testproject --build-arg DACPAC_FILE=$dacpac_file .