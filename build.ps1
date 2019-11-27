$msbuild='C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe'
& $msbuild db-testproject\db-testproject.sln /p:OutDir='db-artifacts'

# This could be improved to automatically detect current container OS
$container_os="windows"
if ($1 -eq "linux")
{
    $container_os="linux"
}

$dacpac_file="db-testproject\db-testproject\db-artifacts\db-testproject.dacpac"
docker build -t db-testproject -f $container_os\Dockerfile --build-arg DACPAC_FILE=$dacpac_file --build-arg TARGET_DB_NAME="db-testproject" .