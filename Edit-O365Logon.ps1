<#
    .SYNOPSIS
    Altera o email principal do usuario no Office 365

    .DESCRIPTION
    Altera o dominio do email principal dos usuarios do Office 365

    .EXAMPLES
    Edit-O365Logon -Department "CENTRO DE SOLUÇÕES INTEGRADAS"
    Edit-O365Logon -Department "CENTRO DE SOLUÇÕES INTEGRADAS" -Domain "hobrasil.com.br"
    Edit-O365Logon -Department "CENTRO DE SOLUÇÕES INTEGRADAS" -Update

    .AUTHOR
    Sergio Carvalho Queiroz (sergio.queiroz@hobrasil.com.br)
#>
function Edit-O365Logon {
    Param 
    (
        [String] $Department,
        [PSDefaultValue(Help = 'opty.com.br')]
        [String] $NewDomain = 'opty.com.br',
        [switch] $Update
    )

    Connect-MsolService
    $users = Get-MsolUser -EnabledFilter EnabledOnly -Department $Department | `
        #$users = Get-MsolUser -UserPrincipalName "sergio.queiroz@hobrasil.com.br" | `
    Select-Object DisplayName, UserPrincipalName | `
        Sort-Object -Property DisplayName

    $users | ForEach-Object -Begin {"Início do processamento: " + (Get-Date)} -Process {
        $NewMail = $_.UserPrincipalName.Split("@")[0] + "@$NewDomain"
        Write-Host "Alterando " $_.UserPrincipalName " para $NewMail"
        If ($Update) {
            Set-MsolUserPrincipalName -UserPrincipalName $_.UserPrincipalName -NewUserPrincipalName $NewMail
        }
    } -End {"Fim do processamento: " + (Get-Date)}
}

Edit-O365Logon -Department "CENTRO DE SOLUÇÕES INTEGRADAS" -Update