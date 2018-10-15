Connect-AzureAD
Connect-MsolService
$x = Get-MsolUser -All

foreach ($i in $x)
    {
      $y = Get-Mailbox -Identity $i.UserPrincipalName
      $i | Add-Member -MemberType NoteProperty -Name IsMailboxEnabled -Value $y.IsMailboxEnabled

      $y = Get-CsOnlineUser -Identity $i.UserPrincipalName
      $i | Add-Member -MemberType NoteProperty -Name EnabledForSfB -Value $y.Enabled
    }

$x | Select DisplayName, IsLicensed, IsMailboxEnabled, EnabledforSfB | Export-Csv -Path "C:\Users\sergio.queiroz\Documents\O365Users.csv" -NoTypeInformation


$AllUsers = Get-MsolUser -All
foreach ($User in $AllUsers)
  {
    $AllLicenses=(Get-MsolUser -UserPrincipalName $User.UserPrincipalName).Licenses
    foreach($License in $AllLicenses)
      {
        $User | Add-Member -MemberType NoteProperty -Name AccountSkuId -Value $License.AccountSkuId
        $User | Add-Member -MemberType NoteProperty -Name ServiceStatus -Value $License.ServiceStatus

      }
  }
$AllUsers | Select DisplayName, UserPrincipalName, IsLicensed, AccountSkuId, ServiceStatus | Export-Csv -Path "C:\Users\sergio.queiroz\Documents\O365Users.csv" -NoTypeInformation


$AllUsers = Get-MsolUser -All
$AllUsers | Format-Table -Property DisplayName, UserPrincipalName, IsLicensed, Title, Department, StreetAddress, City, State, UsageLocation, WhenCreated, Licenses -AutoSize -Wrap | Export-Csv -Path "C:\Users\sergio.queiroz\Documents\O365Users.csv" -NoTypeInformation

$AllUsers | Select DisplayName, UserPrincipalName, IsLicensed, AccountSkuId, ServiceStatus | Export-Csv -Path "C:\Users\sergio.queiroz\Documents\O365Users.csv" -NoTypeInformation



$userAccountUPN="sergio.queiroz@hobrasil.com.br"
$AllLicenses=(Get-MsolUser -UserPrincipalName $userAccountUPN).Licenses
$licArray = @()
for($i = 0; $i -lt $AllLicenses.Count; $i++)
{
  $licArray += "License: " + $AllLicenses[$i].AccountSkuId
  $licArray +=  $AllLicenses[$i].ServiceStatus
  $licArray +=  ""
}
$licArray