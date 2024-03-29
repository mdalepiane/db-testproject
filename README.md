# db-testproject

I've created this repo to learn how to build a docker image of a SQL Server database from a Visual Studio database project using Azure devops.

This project is currently able to:
- Build the docker image locally using `build.ps1`
- Build the docker image for any provided `.dacpac` file using `docker build -t db-testproject --build-arg DACPAC_FILE=$dacpac_file .`

Points to improve:
- MSBuild path is hard-coded in `build.ps1`

## Usage
### Build locally
```build.ps1```

There might be some setback since the MSBuild path is hard-coded in the script.

### Build docker from dacpac
````docker build --build-arg DACPAC_FILE=$dacpac_file --build-arg SA_PASSWORD=$password --build-arg TARGET_DB_NAME=$db_name.````

| Build argument | Description | Default value |
|----------------|-------------|---------------|
| DACPAC_FILE    | Relative path to the .dacpac file | *Mandatory** |
| TARGET_DB_NAME | Database name | *Mandatory** |
| SA_PASSWORD    | sa password for database image | `@Pa55word` |

\* *Mandatory* fields must always be provided through `--build-arg`