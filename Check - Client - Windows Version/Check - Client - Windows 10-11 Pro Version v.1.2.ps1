$supportended = $false
$supportEndWarning = 60 # Wie viele Tage vor Ablauf soll gewarnt werden

$productName = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name ProductName).ProductName
$currentBuild = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name CurrentBuild).CurrentBuild
$UBR = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name UBR).UBR #Update Build Revision

$win1011 = $false


# Windows 7
if ($productName -match "Windows 7") {
    $supportended = $true
}

# Windows 8 / 8.1
if ($productName -match "Windows 8") {
    $supportended = $true
}

# Windows 10
if ($productName -match "Windows 10") {
    $win = ""
    $win1011 = $true
    [datetime]$supportEndDate = "2019-12-31" 
    
    switch ($currentBuild) {
        "22621" {[datetime]$supportEndDate = "2024-10-14"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "22H2 ($dateFormatted)"; $productName = "Windows 11 Pro"; break}
        "22000" {[datetime]$supportEndDate = "2023-10-10"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "21H2 ($dateFormatted)"; $productName = "Windows 11 Pro"; break}
        "19045" {[datetime]$supportEndDate = "2023-10-10"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "22H2 ($dateFormatted)"; break}
        "19044" {[datetime]$supportEndDate = "2023-06-13"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "21H2 ($dateFormatted)"; break}
        "19043" {[datetime]$supportEndDate = "2022-12-13"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "21H1 ($dateFormatted)"; break}
        "19042" {[datetime]$supportEndDate = "2022-05-22"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "20H2 ($dateFormatted)"; break}
        "19041" {[datetime]$supportEndDate = "2021-12-14"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "2004 ($dateFormatted)"; break}
        "18363" {[datetime]$supportEndDate = "2021-05-11"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "1909 ($dateFormatted)"; break}
        "18362" {[datetime]$supportEndDate = "2020-12-08"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "1903 ($dateFormatted)"; break}
        "17763" {[datetime]$supportEndDate = "2020-05-12"; $dateFormatted = ("{0:yyyy-MM-dd}" -f $supportEndDate); $win = "1809 ($dateFormatted)"; break}
        "17134" {$win = "1803 (Serviceende)"; $supportended = $true; break}
        "16299" {$win = "1709 (Serviceende)"; $supportended = $true; break}
        "15063" {$win = "1703 (Serviceende)"; $supportended = $true; break}
        "14393" {$win = "1607 (Serviceende)"; $supportended = $true; break}
        "10586" {$win = "1511 (Serviceende)"; $supportended = $true; break}
        default {$win = "nicht gefunden!"; $supportended = $true; break}
    }

    $win = " | Version: $win"

}

if ($win1011) {
    [datetime]$now = Get-Date
    $timeToSupportEnd = New-TimeSpan -Start $now -End $supportEndDate
    $daysToSupportEnd = $timeToSupportEnd.days
}

$OSVersion = $productName +" - Build " + $currentBuild + "." + $UBR + $win

if ($supportended) {
	write-host "$OSVersion | ERROR: Support abgelaufen."
    #exit 1001

} elseif ($daysToSupportEnd -lt 1) {
	write-host "$OSVersion | ERROR: Support seit $(-$daysToSupportEnd) Tagen abgelaufen."
	#exit 1002
    
} elseif ($daysToSupportEnd -lt $supportEndWarning) {
	write-host "$OSVersion | WARNUNG: Support endet in $daysToSupportEnd Tagen."
	#exit 1003

} else {
	write-host "$OSVersion | INFO: Support endet in $daysToSupportEnd Tagen"
    #exit 0
}