#4.14.2

$wazuh_version = $args[0]
$wazuh_agentgroup = $args[1]

if (($wazuh_version -eq $null) -or ($wazuh_agentgroup -eq $null)) {
    Write-Host "Fehlende Argumente... Beende.."
    exit 1001
}

$wazuh_manager = "wazuh.deinefirma.cloud"
$wazuh_agentname = "$($wazuh_agentgroup)_$($ENV:COMPUTERNAME)"
$wazuh_pwd = 'wazuh-1245'

$installed = Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$wazuh_installed = $installed | ? DisplayName -Match "wazuh"

$zert_url = "https://deinefirma.cloud/downloads/wazuh/zerts.zip"
$setup_folder = "C:\ProgramData\deineFirmaRMM\wazuh"
$zert_dl = "$($setup_folder)\zerts.zip"

$wazuh_url = "https://packages.wazuh.com/4.x/windows/wazuh-agent-$($wazuh_version)-1.msi" 
$wazuh_dl = "$($setup_folder)\wazuh-agent-$($wazuh_version)-1.msi"
$wazuh_log = "$($setup_folder)\wazuh-agent-install.log"

$wazuh_ca = "$($setup_folder)\rootCA.pem"
$wazuh_key = "$($setup_folder)\sslagent.key"
$wazuh_cert = "$($setup_folder)\sslagent.cert"


if (($wazuh_installed -ne $null) -and ($wazuh_installed.DisplayVersion -eq $wazuh_version)) {
    Write-Host "wazuh-Agent bereits installiert"
    exit 0
}

$psver = $PSVersionTable.PSVersion.Major

if ($psver -lt 7) {
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
    [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
    #[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}


if (!(Test-Path -Path $setup_folder)) {
    try {
        New-Item $setup_folder -ItemType Directory
    }
    catch {
        Write-Host "Konnte Ordner $($setup_folder) nicht erstellen. Beende."
        Write-Host $_
        exit 1001
    }
}

try {
    Invoke-WebRequest $zert_url -OutFile $zert_dl -UseBasicParsing
}
catch {
    Write-Host "Konnte zerts.zip nicht herunterladen. Beende."
    Write-Host $_
    exit 1002
}

try {
    Expand-Archive $zert_dl -DestinationPath $setup_folder -Force
}
catch {
    Write-Host "Konnte zerts.zip nicht entpacken. Beende."
    Write-Host $_
    exit 1003
}

try {
    Invoke-WebRequest -Uri $wazuh_url -OutFile $wazuh_dl -UseBasicParsing
}
catch {
    Write-Host "Konnte wazuh-agent nicht herunterladen. Beende."
    Write-Host $_
    exit 1004
}


# Installation
$msiargs = @(
    "/i"
    '"'+$wazuh_dl+'"'
    '/q'
    "WAZUH_MANAGER="+'"'+$wazuh_manager+'"'
    "WAZUH_REGISTRATION_SERVER="+'"'+$wazuh_manager+'"'
    "WAZUH_REGISTRATION_PASSWORD="+'"'+$wazuh_pwd+'"'
    "WAZUH_AGENT_GROUP="+'"'+$wazuh_agentgroup+'"'
    "WAZUH_AGENT_NAME="+'"'+$wazuh_agentname+'"'
    "WAZUH_REGISTRATION_CA="+'"'+$wazuh_ca+'"'
    "WAZUH_REGISTRATION_CERTIFICATE="+'"'+$wazuh_cert+'"'
    "WAZUH_REGISTRATION_KEY="+'"'+$wazuh_key+'"'
    "/l*v"
    '"'+$wazuh_log+'"'
)

Start-Process msiexec.exe -ArgumentList $msiargs -Wait -PassThru

Start-Sleep -Seconds 10

Start-Service -Name wazuh
