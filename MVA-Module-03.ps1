# 'You', 'Me' | ForEach-Object { "Say $_" }

# 'You', 'Me' | Where-Object { $_ -match 'u' }

# "Sergio CA"

# Get-ComputerInfo
# (Get-ComputerInfo).BiosSeralNumber
# (Get-ComputerInfo).CsChassisSKUNumber
# (Get-ComputerInfo).CsUserName
# Get-ComputerInfo | Select-Object -ExpandProperty BiosSeralNumber
# Get-ComputerInfo | Select-Object -ExpandProperty CsCaption

# 'I like tea' -replace 'tea', 'coffee'
# 'I like tea' -replace '\s', '_'
# '127', '0', '0', '1' -join '.'

param {
    $ShowBuild
}