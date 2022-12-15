# SHA256
$hash = "73F7E0ECB4E5DF5244BF1A99A3745544BA5CE9341FD4F8CA4251C434BB095BB4"
$dll = "C:\Program Files\LAPS\CSE\AdmPwd.dll"
$regpath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\GPExtensions\{D76B9641-3288-4f75-942D-087DE603E3EA}"

$reg = Get-ItemProperty $regpath -ErrorAction SilentlyContinue
$laps = $false

if (($reg -ne $null) -and ($reg.DllName -eq $dll)) {
    #Write-Host "LAPS: GPO Extension in Registry vorhanden"
    $laps = $true

} else {
    Write-Host "LAPS: Fehler - GPO-Extension nicht gefunden!"
    exit 1001

}


if (!(Test-Path -Path $dll)) {
        Write-Host "LAPS: Fehler - AdmPwd.dll nicht gefunden!"
        exit 1002

} else {

    $compareHash = (Get-Item $dll | Get-FileHash -Algorithm SHA256).Hash

    if ($hash -ne $compareHash) {
        Write-Host "LAPS: AdmPwd.dll vorhanden, Hashwert falsch - Achtung!"        
        exit 1003

    } else {
        #Write-Host "LAPS: AdmPwd.dll vorhanden"
        
        if ($laps) {
            Write-Host "LAPS: installiert"
            exit 0
        } else {
            Write-Host "LAPS: Fehler - bitte pruefen"
            exit 1004
        }

    }

}

