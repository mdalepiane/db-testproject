$mstest='C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe'
& $mstest .\db-testproject\db-testproject.sln /p:OutDir='db-artifacts'




docker build -t db-testproject .