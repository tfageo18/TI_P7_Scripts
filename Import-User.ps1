<#

Auteur    : Thomas FAGEOL
Date      : 22/05/2022
Version   : 1.1
Révisions : 
  - 1.0 : Création
  - 1.1 : Base du script
Description : Import des utilisateurs dans l'ad depuis un fichier CSV

#>

# Import du module active directory
Import-Module ActiveDirectory

# Nom du domaine
$Domain       = "@axeplane.loc"
# OU des utilisateurs
$UserOu       = "OU=_AXEPLANE,OU=Utilisateurs,DC=axeplane,DC=loc"
# Fichiers CSV
$NewUsersList = Import-CSV ".\userstobeimported.csv"

# Parcours du fichier CSV
ForEach ($User in $NewUsersList) {
    # Récupération du Prénom
    $givenName = $User.givenName

    # Récupération du Nom
    $Name = $User.Nom
    
    # Récupération du nom déouverture de session de léutilisateur
	$sAMAccountName = $User.sAMAccountName
	
    # Récupération du nom déouverture de session de léutilisateur é concaténé au nom du domaine
    $userPrincipalName = $User.sAMAccountName+$Domain

    # Récupération du mail
    $userMail = $User.Mail

    # Récupération de la fonction
    $userTitle = $User.Fonction

    # Récupération du service
    $userDepartment = $User.Service

    # Création de l'utilisateur
	New-ADUser -Name $Name -GivenName $givenName -SamAccountName $sAMAccountName -mail $userMail -Title $userTitle -Department $userDepartment -SearchBase $UserOu -Path "OU=Utilisateurs,OU=$NewClient,$OUBase" -Enabled $True
    
    # Ajout de l'utilisateur dans le groupe de son service
    Add-ADGroupMember -Identity $userDepartment -User $sAMAccountName

    # Ajout de l'utilisateur dans le groupe pour accés au fichier de son service
    $groupeFichier = "GG_"+$userDepartment
    Add-ADGroupMember -Identity $groupeFichier -User $sAMAccountName
}                                            