<?php
// connect to the database
// create a connection using mysqli_connect(host,user,password,database)
$connection = mysqli_connect('db','mariadb','mariadb','RCTI');
// if not successful
if( !$connection ) {
    echo "database connection failed";
}
?>