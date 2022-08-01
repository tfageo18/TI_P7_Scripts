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

# Choix du groupe
$ou = 'OU=Groupes,OU=_AXEPLANE,DC=axeplane,DC=loc' # OU des groupes
# Liste des droits d'accès pour les fichiers
If ($debug -eq 0) { 
  $groupesAD = @()
  $groupes = Get-ADGroup -SearchBase $ou -Filter * | Sort-Object | select Name 

  ForEach ($groupe in $groupes) { $groupesAD += $groupe.Name }
}

# Export
$question = Read-Host "Voulez-vous un export CSV (o/n) ?"

# Affichage des utilisateurs
If ($debug -eq 0) { 
  For($i = 0; $i -lt $groupesAD.count; $i++){
    Write-Host "$($i): $($groupesAD[$i])"
  }
  $nbgroupesAD = Read-Host "Choisir le numero du groupe"

  $nomGroupe  = $groupesAD[$nbgroupesAD]
  $nbuser     = (Get-ADGroup -Identity $groupesAD[$nbgroupesAD] -Properties *).Member.Count
  Write-Host "Nombre d'utilisateur du groupe $nomGroupe : $nbuser" -ForegroundColor Green
  If ($nbuser -gt 0) {
    
    If ($question -eq 'o') { 
      Remove-Item C:\ADGroupMember-$nomGroupe.csv
      Get-ADGroupMember -Identity $groupesAD[$nbgroupesAD] | Select Name | Export-CSV C:\ADGroupMember-$nomGroupe.csv 
    }
    If ($question -eq 'n') { 
      Write-Host "Liste des utilisateurs : " -ForegroundColor Yellow
      Get-ADGroupMember -Identity $groupesAD[$nbgroupesAD] | Select Name 
    }
  }
}