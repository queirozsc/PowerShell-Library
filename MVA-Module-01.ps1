# $var = 20

# if ($var -gt 25) {
#     Write-Host "$var is greather than 25"
# }
# else {
#     Write-Host "$var is not greater than 25"
# }

# switch ($var) {
#     7 { Write-Host "Value is 7" }
#     42 {Write-Host "Value is 42"; break}
#     {$_ -gt 25} {Write-Host "Value is greater than 25"}
#     Default {Write-Host "Value is anything else"}
# }

for ($i = 1; $i -le 5; $i++) {
    $i
}

$numbers = @("one", "two", "three", "four", "five")
foreach ($number in $numbers) {
    $number
}

$x = 0
while ($x -lt 3) {
    $x++
    Write-Host "Hello world"
}