<#

Auteur    : Thomas FAGEOL
Date      : 22/05/2022
Version   : 1.0

Description : Afficher/exporter la liste des membres d'un groupe AD

#>
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
If ($osInfo.ProductType -eq 1) { $debug = 1}
If ($osInfo.ProductType -eq 2) { $debug = 0}

If ($debug -eq 0) { Import-Module ActiveDirectory }

# Saisi du groupe
$groupe = Read-Host "Saisir le nom du groupe AD"

$continue = $true
while ($continue){
  write-host "---------------------- Afficher / Exporter -----------------------”
  write-host "1. Afficher”
  write-host "2. Exporter"
  write-host "x. exit"
  write-host "--------------------------------------------------------"
  $choix = read-host "Faire un choix "
  switch ($choix){
    1{
      
    }
    2{

    }
    'x' {$continue = $false}
    default {Write-Host "Choix invalide"-ForegroundColor Red}
  }
}