<#

Auteur    : Thomas FAGEOL
Date      : 01/08/2022
Version   : 1.0
Description : Sauvegarde des données utilisateur (c:\users\) vers E:\sauvegardes

#>
$user             = $env:USERNAME
$cheminsauvegarde = "\\SRVAXEPLANE01\Sauvegardes$\$user"

robocopy C:\users\$user\ $cheminsauvegarde /mir /v

