$adapters = Get-NetAdapter -Physical | ? Status -eq "Up" # nur die aktiven Netzwerkkarten auslesen
$errors = $false

foreach ($adapter in $adapters) {

    $speed = $adapter.LinkSpeed

    if ($speed -eq "1 Gbps") {
        Write-Host "LAN Geschwindigkeit:" $speed
    } else {
        Write-Host "FEHLER! LAN Geschwindigkeit: $speed ($($adapter.InterfaceAlias) / $($adapter.InterfaceDescription))"
        $errors = $true
    }

}

if ($errors) {
    exit 1001
} else {
    exit 0
}