# Creates the Play upload key and android/key.properties.
#
# Run once, from the project folder:
#   powershell -ExecutionPolicy Bypass -File tool\make_upload_key.ps1
#
# You type the password yourself; it is stored only in android/key.properties
# on this PC (git-ignored). Back up BOTH files somewhere safe (e.g. a password
# manager): without them you cannot publish updates to the same Play listing
# unless you ask Google to reset the upload key.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$android = Join-Path $root 'android'
$keystore = Join-Path $android 'upload-keystore.jks'
$props = Join-Path $android 'key.properties'

if (Test-Path $keystore) {
    Write-Host "An upload key already exists at $keystore - not overwriting it." -ForegroundColor Yellow
    exit 1
}

$keytool = Get-Command keytool -ErrorAction SilentlyContinue
if (-not $keytool) {
    $jdk = 'C:\dev\jdk-17\bin\keytool.exe'
    if (Test-Path $jdk) { $keytool = $jdk } else { throw 'keytool not found (install a JDK).' }
} else { $keytool = $keytool.Source }

$pw = Read-Host 'Choose a password for the upload key (at least 6 characters)' -AsSecureString
$pw2 = Read-Host 'Type it again' -AsSecureString
$plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw))
$plain2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pw2))
if ($plain -ne $plain2) { throw 'The passwords did not match.' }
if ($plain.Length -lt 6) { throw 'Use at least 6 characters.' }

& $keytool -genkeypair -v -keystore $keystore -storetype JKS -keyalg RSA -keysize 2048 `
    -validity 10000 -alias upload -storepass $plain -keypass $plain `
    -dname 'CN=Prashant Keshri, O=dhurta.Inc, C=IN'
if ($LASTEXITCODE -ne 0) { throw 'keytool failed.' }

@"
storePassword=$plain
keyPassword=$plain
keyAlias=upload
storeFile=upload-keystore.jks
"@ | Set-Content -Path $props -Encoding ascii
$plain = $null; $plain2 = $null

Write-Host "Created $keystore and $props." -ForegroundColor Green
Write-Host 'Back up both files now. Then build with: flutter build appbundle --release'
