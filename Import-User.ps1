<#

Auteur    : Thomas FAGEOL
Date      : 22/05/2022
Version   : 1.1
R�visions : 
  - 1.0 : Cr�ation
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
    # R�cup�ration du Pr�nom
    $givenName = $User.givenName

    # R�cup�ration du Nom
    $Name = $User.Nom
    
    # R�cup�ration du nom d�ouverture de session de l�utilisateur
	$sAMAccountName = $User.sAMAccountName
	
    # R�cup�ration du nom d�ouverture de session de l�utilisateur � concat�n� au nom du domaine
    $userPrincipalName = $User.sAMAccountName+$Domain

    # R�cup�ration du mail
    $userMail = $User.Mail

    # R�cup�ration de la fonction
    $userTitle = $User.Fonction

    # R�cup�ration du service
    $userDepartment = $User.Service

    # Cr�ation de l'utilisateur
	New-ADUser -Name $Name -GivenName $givenName -SamAccountName $sAMAccountName -mail $userMail -Title $userTitle -Department $userDepartment -SearchBase $UserOu -Path "OU=Utilisateurs,OU=$NewClient,$OUBase" -Enabled $True
    
    # Ajout de l'utilisateur dans le groupe de son service
    Add-ADGroupMember -Identity $userDepartment -User $sAMAccountName

    # Ajout de l'utilisateur dans le groupe pour acc�s au fichier de son service
    $groupeFichier = "GG_"+$userDepartment
    Add-ADGroupMember -Identity $groupeFichier -User $sAMAccountName
}                                            