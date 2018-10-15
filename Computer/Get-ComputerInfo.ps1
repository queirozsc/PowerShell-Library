Import-Module .\Get-TeamViewerID.ps1 -Force
Get-TeamViewerID -Hostname SERGIO -Copy $true
$computador = 'SERGIO'

# Informações da BIOS
$Win32_BIOS = Get-CimInstance -ClassName Win32_BIOS -ComputerName $computador
$Win32_ComputerSystem = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $computador

# Informações do processador
$Win32_Processor = Get-CimInstance -ClassName Win32_Processor -ComputerName $computador

# Hotfixes instalados
$hotfixes = Get-CimInstance -ClassName Win32_QuickFixEngineering -ComputerName $computador | `
    Select-Object HotFixID, Description, @{Name = 'InstalledOn'; Expression = {Get-Date ($_.InstalledOn) -Format 'dd/MM/yyyy'}} | `
    Sort-Object -Property InstalledOn

$resultado = @{
    Computador  = $Win32_BIOS.PSComputerName ;
    Fabricante  = $Win32_BIOS.Manufacturer ;
    Modelo      = $Win32_ComputerSystem.Model ;
    Tag         = $Win32_BIOS.SerialNumber ;
    Processador = $Win32_Processor.Name ;
    Hotfixes    = $hotfixes
} 

$resultado | ConvertTo-Json



#Listar os hotfixes instalados

#Listar informações de versão do sistema operacional
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computador | Select-Object -Property BuildNumber, BuildType, OSType, ServicePackMajorVersion, ServicePackMinorVersion
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computador | Select-Object -Property Build*, OSType, ServicePack*

#Listar proprietário e usuários locais
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computador | Select-Object -Property NumberOfLicensedUsers, NumberOfUsers, RegisteredUser
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName CN04 | Select-Object -Property *user*

#Obter o espaço em disco disponível
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $computador
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $computador | Measure-Object -Property FreeSpace, Size -Sum | Select-Object -Property Property, Sum

#Obter informações de sessão de logon
Get-CimInstance -ClassName Win32_LogonSession -ComputerName $computador

#Obter o usuário conectado a um computador
Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName -ComputerName $computador

#Obter a hora local de um computador
Get-CimInstance -ClassName Win32_LocalTime -ComputerName $computador

#Exibir o status do serviço
Get-CimInstance -ClassName Win32_Service -ComputerName $computador | Format-Table -Property Status, Name, DisplayName -AutoSize -Wrap
Get-WmiObject -Class Win32_SystemDriver -ComputerName CN04 | Where-Object -FilterScript {$_.State -eq "Running"} | Where-Object -FilterScript {$_.StartMode -eq "Auto"} | Format-Table -Property Name, DisplayName
Get-WmiObject -Class Win32_SystemDriver -ComputerName CN04 | Where-Object -FilterScript { ($_.State -eq 'Running') -and ($_.StartMode -eq 'Manual') } | Format-Table -Property Name, DisplayName

#Espaço em disco do computador
Get-PSDrive -PSProvider FileSystem
[System.IO.DriveInfo]::GetDrives() | Format-Table

#Obter endereço IP do computador
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName CN04 | Format-Table -Property IPAddress

#Obter informações da placa de rede
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName CN04
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true -ComputerName CN04 | Select-Object -Property [a-z]* -ExcludeProperty IPX*, WINS*

#Executando ping
Get-WmiObject -Class Win32_PingStatus -Filter "Address='csi.requestia'" -ComputerName CN04 | Format-Table -Property Address, ResponseTime, StatusCode -Autosize
'8.8.8.8', 'csi.requestia.com', 'office.com' | ForEach-Object -Process {Get-WmiObject -Class Win32_PingStatus -Filter ("Address='" + $_ + "'") -ComputerName .} | Select-Object -Property Address, ResponseTime, StatusCode
1..254| ForEach-Object -Process {Get-WmiObject -Class Win32_PingStatus -Filter ("Address='10.0.0." + $_ + "'") -ComputerName .} | Select-Object -Property Address, ResponseTime, StatusCode

#Listando as impressoras instaladas no computador
Get-WmiObject -Class Win32_Printer -ComputerName .

#Verificando porta aberta
Test-NetConnection -ComputerName TESOURARIA03 -Port 80

Resolve-DnsName -Name hobrasil.com.br -Type A
Resolve-DnsName -Name hobrasil.com.br -Type MX

#Listando grupos do AD aos quais o usuário pertence
Get-ADPrincipalGroupMembership "sergio.queiroz" | Select Name
Get-ADGroupMember "Domain Admins" | Select Name
Get-ADUser "sergio.queiroz" -Properties MemberOf | Select -ExpandProperty MemberOf


#Executando o PowerShell como administrador
Start-Process powershell -Verb runAs

#Status do servico Windows Remote Management
Get-Service WinRM

#Habilitando acesso remoto no Firewall
Enable-PSRemoting -Force

# Listando hosts confiáveis
Get-Item WSMan:\localhost\Client\TrustedHosts

#Adicionando computador à lista de hosts confiáveis
winrm s winrm/config/client '@{TrustedHosts="RemoteComputer"}'
#ou
Set-Item WSMan:\localhost\Client\TrustedHosts -value SERGIO.hobrasil


#Efetuar conexão PowerShell remota (Ctrl + Shift + R)
Enter-PSSession -ComputerName ANA -Credential sergio.queiroz

#Reiniciando serviço do WinRM
Restart-Service WinRM

