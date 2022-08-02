<#

Auteur    : Thomas FAGEOL
Date      : 01/08/2022
Version   : 1.0
Description : Sauvegarde des données utilisateur (c:\users\) vers E:\sauvegardes

#>
$user             = $env:USERNAME
$cheminsauvegarde = "\\SRVAXEPLANE01\Sauvegardes$\$user"

robocopy C:\users\$user\ $cheminsauvegarde /mir /v /XD "C:\users\$user\appdata" "C:\users\$user\Application Data" "C:\users\$user\Cookies" "C:\Users\$user\Music" "C:\Users\$user\Local Settings" "C:\Users\$user\Menu Démarrer" "C:\Users\$user\Mes documents" "C:\Users\$user\Modèles" "C:\Users\$user\OneDrive" "C:\Users\$user\Recent" "C:\Users\$user\Voisinage d'impression" "C:\Users\$user\Voisinage réseau" "C:\Users\$user\SendTo" "C:\Users\$user\start menu" "C:\Users\$user\modeles" /XF *.blf *.regtrans-ms ntuser.ini ntuser.dat /R:1 /W:1

