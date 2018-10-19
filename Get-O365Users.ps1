Connect-MsolService
Get-MsolUser -EnabledFilter EnabledOnly -Department "CENTRO DE SOLUÇÕES INTEGRADAS" | `
    Select-Object DisplayName, UserPrincipalName | `
    Sort-Object -Property DisplayName | `
    Export-Csv -Path "Listagem Emails CSI.csv" -Encoding UTF8 -Delimiter ";"