<#

Auteur    : Thomas FAGEOL
Date      : 01/08/2022
Version   : 1.0
Description : Sauvegarde des données utilisateur (c:\users\) vers E:\sauvegardes

#>
$user             = $env:USERNAME
$cheminsauvegarde = "\\SRVAXEPLANE01\Sauvegardes$\$user"

robocopy C:\users\$user\ $cheminsauvegarde /mir /v /XD "C:\users\$user\appdata" "C:\users\$user\Application Data" "C:\users\$user\Cookies" "C:\Users\$user\Music" /XF *.blf *.regtrans-ms ntuser.ini ntuser.dat /R:1 /W:1

