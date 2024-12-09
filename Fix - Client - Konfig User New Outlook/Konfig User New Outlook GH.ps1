$folder_rmm = "$($Env:ProgramData)\EUREFIRMARMM"
$folder_tools = "$($folder_rmm)\tools"
$folder_fixes = "$($folder_rmm)\fixes"

$tool_lgpo = "$($folder_tools)\LGPO.exe"
$fixname = "Konfig-User-New-Outlook"
$fix = "$($folder_fixes)\konfig-user-new-outlook.registry.pol"

$download_lgpo = "https://eurefirma.de/downloads/rmm/tools/LGPO.exe"
$download_fix = "https://eurefirma.de/downloads/rmm/fixes/konfig-user-new-outlook.registry.pol"


if (!(Test-Path -Path $tool_lgpo)) {
    try {
        if (!(Test-Path -Path $folder_tools)) {
            New-Item -Path $folder_tools -ItemType Directory -Force
        }

        Invoke-WebRequest -Uri $download_lgpo -OutFile $tool_lgpo
    }
    catch {
        Write-Host "Download $download_lgpo fehlgeschlagen. Beende."
        Write-Host $_
        exit 1001
    }
}

if (!(Test-Path -Path $fix)) {
    try {
        if (!(Test-Path -Path $folder_fixes)) {
            New-Item -Path $folder_fixes -ItemType Directory -Force
        }

        Invoke-WebRequest -Uri $download_fix -OutFile $fix
    }
    catch {
        Write-Host "Download $download_fix fehlgeschlagen. Beende."
        Write-Host $_
        exit 1002
    }
}

$proc_args = @(
    "/u"
    '"'+$($fix)+'"'
)

$proc = Start-Process $tool_lgpo -ArgumentList $proc_args -Wait -PassThru -NoNewWindow -RedirectStandardError ($($folder_fixes)+'\lgpo.'+$($fixname)+'.err.txt') -RedirectStandardOutput ($($folder_fixes)+'\lgpo.'+$($fixname)+'.out.txt')

if ($proc.ExitCode -eq 0) {
    Write-Host "Fix '$($fixname)' angewendet"
    exit 0
} else {
    Write-Host "Fehler Fix '$($fixname) - Exitcode: $($proc.ExitCode)"
    Get-Content ($($folder_fixes)+'\lgpo.'+$($fixname)+'.err.txt') | Out-Host
    exit 1003
}