# db-testproject

I've created this repo to learn how to build a docker image of a SQL Server database from a Visual Studio database project using Azure devops.

This project is currently able to:
- Build the docker image locally using `build.ps1`
- Build the docker image for any provided `.dacpac` file using `docker build -t db-testproject --build-arg DACPAC_FILE=$dacpac_file .`

Points to improve:
- MSBuild path is hard-coded in `build.ps1`
- Add an `azure-pipelines.yml`