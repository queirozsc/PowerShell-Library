<#
    .SYNOPSIS
    Relação de usuários ativos do Office 365. Exporta para CSV, opcionalmente

    .DESCRIPTION
    Relaciona os usuários ativos do Office 365

    .EXAMPLES
    Get-O365ActiveUsers -Domain "hobr.com.br"
    Get-O365ActiveUsers -Department "CENTRO DE SOLUÇÕES INTEGRADAS" -Export
    Get-O365ActiveUsers -City "JOINVILLE" -Export

    .AUTHOR
    Sergio Carvalho Queiroz (sergio.queiroz@hobrasil.com.br)
#>
function Get-O365ActiveUsers {
    Param 
    (
        [PSDefaultValue(Help = 'opty.com.br')]
        [String] $Domain = 'opty.com.br',
        [String] $Department = '',
        [String] $Title = '',
        [String] $City = '',
        [String] $State = '',
        [switch] $Export
    )
    $CSVFileName = "O365ActiveUsers-" + (Get-Date -Format "yyyyMMddhhmm") + ".csv"
    Connect-MsolService
    $Domain = "hobr.com.br"
    $Users = Get-MsolUser -DomainName $Domain -Department $Department -Title $Title -City $City -State $State -EnabledFilter EnabledOnly -All | `
        Select-Object DisplayName, UserPrincipalName, Department, Title, City, State | `
        Sort-Object -Property DisplayName
    If ($Export) {
        $Users | Export-Csv -Path $CSVFileName -Encoding UTF8 -Delimiter ";" -NoTypeInformation
    }
    return $Users
}