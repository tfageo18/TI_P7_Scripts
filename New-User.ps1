<#

Auteur    : Thomas FAGEOL
Date      : 01/08/202
Version   : 1.0
Description : Création d'un utilisateur sur l'ad

#>
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
If ($osInfo.ProductType -eq 1) { $debug = 1}
If ($osInfo.ProductType -eq 2) { $debug = 0}

# Modules
If ($debug -eq 0) { Import-Module ActiveDirectory }

# Variables
$services           = @('Direction','RH','Finance','Commercial','Logistique','Marketing','Stagiaire','Informatique') # Liste des services
$domaineemail       = 'axeplane.loc' # Domaine
$ous                = 'OU=Utilisateurs,OU=_AXEPLANE,DC=axeplane,DC=loc' # OU des utilisateurs
$ougroupe           = 'OU=Droits fichiers,OU=Groupes,OU=_AXEPLANE,DC=axeplane,DC=loc' # OU des groupes
$chemindossierperso = 'E:\Utilisateurs\' # Chemin dossier perso pour la création
$cheminpartage      = '\\SRVAXEPLANE01\Utilisateurs$\' # Chemin du partage pour le HomePath
$lettrepartage      = 'Z:' # Lettre réseau
# Liste des droits d'accès pour les fichiers
If ($debug -eq 0) { 
  $groupesfichiers = @()
  $groupes = Get-ADGroup -SearchBase $ougroupe -Filter * | select Name 

  ForEach ($groupe in $groupes) { $groupesfichiers += $groupe.Name }
}

# Saisie de l'utilisateur
$nom          = (Read-Host "Saisir le nom").ToUpper()
$prenom       = Read-Host "Saisir le prenom"
$fonction     = Read-Host "Saisir la fonction"
$gestionnaire = Read-Host "Saisir le(a) gestionnaire"

# Passe la première lettre du prénom en Majuscule
$prenom = $prenom.substring(0,1).toupper()+$prenom.substring(1).tolower()

# Passe la première lettre de la fonction en Majuscule
$fonction = $fonction.substring(0,1).toupper()+$fonction.substring(1).tolower()

# Concaténation du Prénom et du nom pour le champ Nam de l'ad
$nomcomplet = $prenom+' '+$nom

# Génération du login (1ère lettre du prénom + . + nom de famille)
$login = $prenom.substring(0, 1).ToLower()+'.'+$nom.ToLower()

# Génération du HomeDirectory 
$cheminpartage = $cheminpartage+'\'+$login+'$'  

# Choix du service depuis la liste
For($i = 0; $i -lt $services.count; $i++){
  Write-Host "$($i): $($services[$i])"
}
$nbService = Read-Host "Choisir le numero du service"
$service   = $services[$nbService]

# Concaténation du login + du domaine pour générer l'email
$email = $login+'@'+$domaineemail

# Récapitulatif des informations
Write-Host "Nom            : $nom"
Write-Host "Prenom         : $prenom"
Write-Host "Login          : $login"
Write-Host "Fonction       : $fonction"
Write-Host "Gestionnaire   : $gestionnaire"
Write-Host "Service        : $service"
Write-Host "Email          : $email"
Write-Host "Chemin partage : $cheminpartage"

# Création de l'utilisateur
If ($debug -eq 0) {
  New-ADUser -Name $nomcomplet -GivenName $prenom `
  -Surname $nom `
  -SamAccountName $login `
  -UserPrincipalName $email `
  -EmailAddress $email `
  -Manager $gestionnaire `
  -Deparment $service `
  -Company 'Axeplane' `
  -Path $ous `
  -AccountPassword(Read-Host -AsSecureString "Input Password") `
  -Enabled $true `
  -PasswordNeverExpire $false `
  -HomeDirectory $cheminpartage `
  -HomeDrive $lettrepartage `
}

# Ajout du groupe du service à l'utilisateur
If ($debug -eq 0) { Add-ADGroupMember -Identity $service -Members $login }

# Ajout du groupe pour l'accès aux fichiers de son service
If ($debug -eq 0) { 
  $nomgroupe = 'GG_'+$service
  Add-ADGroupMember -Identity $nomgroupe -Members $login
}

# Ajout des groupes pour l'accès au fichiers des autres services
If ($debug -eq 0) { 
  $continue = $true
  while ($continue){
    For($i = 0; $i -lt $groupesfichiers.count; $i++){
      Write-Host "$($i): $($groupesfichiers[$i])"
    }
    $nbgroupesfichiers = Read-Host "Choisir le numero du groupe"
    Add-ADGroupMember -Identity $groupesfichiers[$nbgroupesfichiers] -Members $login
    
    $confirmation = Read-Host "Voulez-vous ajouter d'autres groupes(o/n) ?"
    If ($confirmation -ne 'o') { $continue = $false }
  }
}

# Création du dossier perso
$chemindossierperso = $chemindossierperso+'\'+$login
mkdir $chemindossierperso

# Partage dossier perso
New-SmbShare -Name $login -Path $chemindossierperso -FullAccess "Administrateurs","Admins du domaine",$login