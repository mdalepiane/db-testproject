error=1
while [ $error -eq 1 ]
do
    echo  "Waiting for SQL Server ..."
    sqlcmd -S localhost,31433 -U sa -P @Pa55word -l 1 -o /dev/null -q exit
    error=$?
done