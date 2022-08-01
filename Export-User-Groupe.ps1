<#

Auteur    : Thomas FAGEOL
Date      : 01/08/2022
Version   : 1.0
Description : Afficher/exporter la liste des groupes AD d'un utilisateur

#>

$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
If ($osInfo.ProductType -eq 1) { $debug = 1}
If ($osInfo.ProductType -eq 2) { $debug = 0}

If ($debug -eq 0) { Import-Module ActiveDirectory }

# Choix du groupe
$ou = 'OU=Utilisateurs,OU=_AXEPLANE,DC=axeplane,DC=loc' # OU des groupes
# Liste des droits d'accès pour les fichiers
If ($debug -eq 0) { 
  $utilAD = @()
  $utils  = Get-ADUser -SearchBase $ou -Filter * | Sort-Object | Select-Object SamAccountName 

  ForEach ($util in $utils) { $utilAD += $util.SamAccountName }
}

# Export
$question = Read-Host "Voulez-vous un export CSV (o/n) ?"

If ($debug -eq 0) { 
  For($i = 0; $i -lt $utilAD.count; $i++){
    Write-Host "$($i): $($utilAD[$i])"
  }
  $nbutilAD = Read-Host "Choisir le numero de l'utilsateur"

  $nomUtil  = $utilAD[$nbutilAD]

  If ($question -eq 'o') {
    If(Test-Path("C:\ADUserGroup-$nomUtil.csv")) { Remove-Item C:\ADUserGroup-$nomUtil.csv }
    (Get-ADuser -Identity $nomUtil -Properties memberof).memberof | Get-ADGroup | Select-Object Name | Sort-Object Name | Export-CSV C:\ADUserGroup-$nomUtil.csv
  }
  If ($question -eq 'n') {
    Write-Host "Liste des groupe de l'utilisateur $nomUtil : " -ForegroundColor Yellow
    (Get-ADuser -Identity $nomUtil -Properties memberof).memberof | Get-ADGroup | Select-Object Name | Sort-Object Name
  }
  
}