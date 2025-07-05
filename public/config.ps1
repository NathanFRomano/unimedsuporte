[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

Write-Host "`n[INFO] Verificando se Java esta instalado..."

$javaFound = $false

# ---------------------------
# 1. Verificacao Java via Win32_Product
# ---------------------------
Write-Host "[CHECK] Procurando Java via Win32_Product..."

$javaWMI = Get-WmiObject -Class Win32_Product | Where-Object {
    $_.Name -like "*Java*" -or $_.Name -like "*Zulu*" -or $_.Name -like "*JDK*" -or $_.Name -like "*JRE*"
}

if ($javaWMI) {
    foreach ($j in $javaWMI) {
        Write-Host "`n[ENCONTRADO] $($j.Name)"
        $resposta = Read-Host "Deseja desinstalar essa versao? (S/N)"
        if ($resposta -match "^[sS]") {
            Write-Host "[INFO] Desinstalando $($j.Name)..."
            try {
                $j.Uninstall()
                Write-Host "[OK] Java desinstalado com sucesso."
                $javaFound = $true
            } catch {
                Write-Host "[ERRO] Falha na desinstalacao do Java: $_"
            }
        } else {
            Write-Host "[INFO] Pulando $($j.Name)."
        }
    }
} else {
    Write-Host "[OK] Nenhuma instalacao Java encontrada via WMI."
}

# ---------------------------
# 2. Verificacao Java via Registro (JavaSoft)
# ---------------------------
Write-Host "`n[CHECK] Procurando Java via Registro (JavaSoft)..."

$javaRegPath = "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment"
$javaReg = Get-ItemProperty -Path $javaRegPath -ErrorAction SilentlyContinue

if ($javaReg) {
    $currentVersion = $javaReg."CurrentVersion"
    $versionInfo = Get-ItemProperty -Path "$javaRegPath\$currentVersion"
    Write-Host "`n[ENCONTRADO] JavaSoft no registro:"
    Write-Host "Versao atual: $currentVersion"
    Write-Host "Path: $($versionInfo.JavaHome)"
    Write-Host "`nATENCAO: Essa instalacao nao pode ser desinstalada automaticamente por script."
    $javaFound = $true
} else {
    Write-Host "[OK] Nenhuma entrada JavaSoft encontrada no registro."
}

if (-not $javaFound) {
    Write-Host "`n[OK] Nenhuma versao do Java foi encontrada neste sistema."
}

# ---------------------------
# 3. Verificacao Firefox via Registro
# ---------------------------
Write-Host "`n[INFO] Verificando se o Firefox esta instalado via registro..."

$firefoxFound = $false
$firefoxPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($path in $firefoxPaths) {
    $firefoxEntries = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue | Where-Object {
        $_.DisplayName -like "*Mozilla Firefox*"
    }

    foreach ($entry in $firefoxEntries) {
        Write-Host "`n[ENCONTRADO] $($entry.DisplayName)"
        $resposta = Read-Host "Deseja desinstalar o Firefox? (S/N)"
        if ($resposta -match "^[sS]") {
            if ($entry.UninstallString) {
                Write-Host "[INFO] Desinstalando Firefox..."
                try {
                    Start-Process -FilePath $entry.UninstallString -Wait
                    Write-Host "[OK] Firefox desinstalado com sucesso."
                    $firefoxFound = $true
                } catch {
                    Write-Host "[ERRO] Falha ao desinstalar o Firefox: $_"
                }
            } else {
                Write-Host "[ERRO] Caminho de desinstalacao nao encontrado."
            }
        } else {
            Write-Host "[INFO] Pulando $($entry.DisplayName)."
            $firefoxFound = $true
        }
    }
}

if (-not $firefoxFound) {
    Write-Host "[OK] Nenhuma instalacao do Firefox encontrada."
}

# ---------------------------
# 4. Download com Progresso
# ---------------------------
Write-Host "`n[INFO] Preparando para baixar instaladores..."

$tempFolder = "$env:TEMP\installers"
New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null

$firefoxUrl = "https://suporteunimed.vercel.app/docs/Firefox47.exe"
$firefoxInstaller = "$tempFolder\firefox_installer.exe"

$javaUrl = ""  # Insira aqui a URL do Java, se quiser
$javaInstaller = "$tempFolder\java_installer.exe"

function Download-ComProgresso {
    param (
        [string]$url,
        [string]$destino
    )

    Write-Host "`n[INFO] Baixando: $url"
    try {
        Invoke-WebRequest -Uri $url -OutFile $destino -UseBasicParsing -Verbose:$false
        Write-Progress -Activity "Download completo" -Status "100%" -PercentComplete 100
        Write-Host "[OK] Download concluido: $destino"
    } catch {
        Write-Host "[ERRO] Falha ao baixar o arquivo: $_"
    }
}

Download-ComProgresso -url $firefoxUrl -destino $firefoxInstaller

if ($javaUrl -ne "") {
    Download-ComProgresso -url $javaUrl -destino $javaInstaller
} else {
    Write-Host "`n[INFO] Link do instalador do Java ainda nao definido. Pulando download do Java."
}

# ---------------------------
# 5. Instalar com pausas entre etapas
# ---------------------------
Write-Host "`n[INFO] Instalacao manual com pausas entre etapas..."

if (Test-Path $firefoxInstaller) {
    $resp = Read-Host "Deseja instalar o Firefox agora? (S/N)"
    if ($resp -match "^[sS]") {
        Start-Process -FilePath $firefoxInstaller
        Read-Host "[PAUSA] Pressione ENTER apos concluir a instalacao do Firefox..."
    } else {
        Write-Host "[INFO] Instalacao do Firefox pulada."
    }
}

if ((Test-Path $javaInstaller) -and ($javaUrl -ne "")) {
    $resp2 = Read-Host "Deseja instalar o Java agora? (S/N)"
    if ($resp2 -match "^[sS]") {
        Start-Process -FilePath $javaInstaller
        Read-Host "[PAUSA] Pressione ENTER apos concluir a instalacao do Java..."
    } else {
        Write-Host "[INFO] Instalacao do Java pulada."
    }
}

# ---------------------------
# 6. Configurar prefs.js do Firefox
# ---------------------------
Write-Host "`n[INFO] Configurando prefs.js do Firefox..."

$profilePath = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" | Where-Object { $_.Name -like "*.default-release" } | Select-Object -First 1

if (-not $profilePath) {
    Write-Host "[ERRO] Perfil do Firefox nao encontrado."
    pause
    exit
}

$prefsFile = Join-Path $profilePath.FullName "prefs.js"

if (-not (Test-Path $prefsFile)) {
    Write-Host "[ERRO] prefs.js nao encontrado."
    pause
    exit
}

Write-Host "[INFO] Editando prefs.js em $prefsFile"
attrib -R $prefsFile

$content = Get-Content -Raw $prefsFile
$prefs = @(
    'user_pref("app.update.enabled", false);'
    'user_pref("app.update.auto", false);'
    'user_pref("app.update.silent", false);'
    'user_pref("app.update.auto.migrated", false);'
    'user_pref("browser.startup.homepage", "https://autorizador.unimedcuritiba.com.br/");'
    'user_pref("browser.startup.page", 1);'
)

foreach ($pref in $prefs) {
    $key = [regex]::Escape(($pref -split ',')[0])
    if ($content -match $key) {
        $content = [regex]::Replace($content, "$key.*?;", $pref)
    } else {
        $content += "`r`n$pref"
    }
}

Set-Content -Path $prefsFile -Value $content -Encoding ASCII
attrib +R $prefsFile

Write-Host "[SUCESSO] prefs.js configurado com sucesso!"
pause
