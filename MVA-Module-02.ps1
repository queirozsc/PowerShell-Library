# $location = Get-Location
# $location | Get-Member
# $location.Drive

# $version = New-Object System.Version
# $version

# $version = New-Object System.Version 3, 6
# $version

# [System.Version]::New()

# [System.Version]::New(3,6)

# $version.ToString()

# [Int] 1.7

# [System.Version] "2.0.1.3"

class MyVersion {
    [Int]$Major
    [Int]$Minor
    [Int]$Build
    [Int]$Rev

    MyVersion() {
        $this.Major, $this.Minor, $this.Build, $this.Rev = 0
    }

    MyVersion($Major, $Minor, $Build, $Rev) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Build = $Build
        $this.Rev = $Rev
    }

    [String]ToString() {
        Return ($this.Major, $this.Minor, $this.Build, $this.Rev) -join "."
    }

    [System.Version]Convert() {
        Return [System.Version]$this.ToString()
    }
}

$myVersionA = New-Object MyVersion
$myVersionB = New-Object MyVersion 1, 2, 3, 4
$myVersionA.Minor
$myVersionB.ToString()