$url = "https://check.labs.greynoise.io"

try {
    $response = Invoke-RestMethod -Uri $url -Headers @{ 'User-Agent' = 'curl/7.79.1' }
} catch {
    Write-Host "$($url) konnte nicht aufgerufen werden. Beende..."
    Write-Host $_
    exit 1002
}

if ($response.status -eq "not_found") {
    Write-Host "OK: IP $($response.ip) nicht betroffen"
    exit 0
} else {
    Write-Host "Warnung: $($response.ip) betroffen! Classification: $($response.classification)"
    exit 1001
}

# ich konnte bisher kein Beispiel einer "infizierten" IP finden, ich gehe davon aus, dass "classification" dann einen Wert enthält
