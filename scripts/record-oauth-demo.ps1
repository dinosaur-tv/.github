<#
.SYNOPSIS
Records the screen for the Google OAuth verification demo video.

.DESCRIPTION
Google reviews this video by eye. It has to show, in one take: the verified
domain in the address bar, the consent screen with our client_id visible, the
scopes being granted, the data actually in use, and how a user revokes access.

Recording goes to Matroska, which survives an abrupt stop, and is remuxed to
MP4 on stop because YouTube prefers it. No re-encode, so stopping is instant.

Running your own server: change the two addresses in the shot list below to
your own domain and bot.

.EXAMPLE
  .\record-oauth-demo.ps1              # prints the shot list, counts down, records
  .\record-oauth-demo.ps1 -Stop        # stops and writes the .mp4
  .\record-oauth-demo.ps1 -ListMics    # microphone device names for -Mic
  .\record-oauth-demo.ps1 -Mic "Микрофон (Realtek Audio)"
#>
[CmdletBinding()]
param(
    [switch]$Stop,
    [switch]$ListMics,
    # gdigrab binds the window once at start, so a page title changing later is fine.
    [string]$Window,
    [string]$Mic,
    [int]$Fps = 15,
    [int]$MaxMinutes = 10,
    [string]$OutDir = "$env:USERPROFILE\Videos\dino-oauth-demo"
)

$ErrorActionPreference = "Stop"

function Get-Ffmpeg {
    $cmd = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $guess = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Recurse -Filter ffmpeg.exe -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($guess) { return $guess.FullName }
    throw "ffmpeg not found. Install it: winget install Gyan.FFmpeg (then reopen the terminal)."
}

$ffmpeg = Get-Ffmpeg

if ($ListMics) {
    # ffmpeg prints the device list to stderr and exits non-zero by design.
    & $ffmpeg -hide_banner -list_devices true -f dshow -i dummy 2>&1 | Select-String "DirectShow audio|Alternative name"
    return
}

$raw = Join-Path $OutDir "demo.mkv"
$mp4 = Join-Path $OutDir "dino-oauth-demo.mp4"

if ($Stop) {
    $proc = Get-Process ffmpeg -ErrorAction SilentlyContinue
    if (-not $proc) { Write-Output "Recording is not running."; return }
    $proc | Stop-Process
    Start-Sleep -Seconds 2
    if (-not (Test-Path $raw)) { throw "No recording at $raw" }
    & $ffmpeg -hide_banner -loglevel error -y -i $raw -c copy -movflags +faststart $mp4
    $size = [math]::Round((Get-Item $mp4).Length / 1MB, 1)
    Write-Output ""
    Write-Output "Ready: $mp4  ($size MB)"
    Write-Output "Upload to YouTube as Unlisted, then paste the link into the verification form."
    return
}

if (Get-Process ffmpeg -ErrorAction SilentlyContinue) {
    throw "ffmpeg is already running. Stop it first: .\record-oauth-demo.ps1 -Stop"
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
if (Test-Path $raw) { Remove-Item $raw -Force }

$shots = @(
    "1. https://api.dym-dino.ru/ - show the Privacy and Terms links. Keep the address bar in frame.",
    "2. Telegram -> @dino_server_bot -> Open Dino TV.",
    "3. More -> Calendars -> Connect.",
    "4. STOP on the consent URL for ~5 seconds. The client_id must be readable.",
    "5. The consent screen in full, with the scope list. Press Allow.",
    "6. Back in the app: pick the calendars, then show the TV screen with the schedule.",
    "7. Press Disconnect and say it deletes the stored token and the cached events."
)

Write-Output ""
Write-Output "Shot list - speak English or add captions on YouTube afterwards:"
Write-Output ""
$shots | ForEach-Object { Write-Output "   $_" }
Write-Output ""
Write-Output "Before you start: switch the television on, and close anything private -"
Write-Output "the whole screen is captured unless you pass -Window."
Write-Output ""

$source = if ($Window) { "title=$Window" } else { "desktop" }
$ffArgs = @(
    "-hide_banner", "-loglevel", "error", "-y",
    "-f", "gdigrab", "-framerate", $Fps, "-i", $source
)
if ($Mic) { $ffArgs += @("-f", "dshow", "-i", "audio=$Mic", "-c:a", "aac", "-b:a", "128k") }
$ffArgs += @(
    "-c:v", "libx264", "-preset", "veryfast", "-crf", "23", "-pix_fmt", "yuv420p",
    "-t", ($MaxMinutes * 60), $raw
)

foreach ($n in 5..1) { Write-Output "Recording starts in $n..."; Start-Sleep -Seconds 1 }
Start-Process -FilePath $ffmpeg -ArgumentList $ffArgs -WindowStyle Hidden
Start-Sleep -Seconds 2
if (-not (Get-Process ffmpeg -ErrorAction SilentlyContinue)) { throw "ffmpeg failed to start." }

Write-Output ""
Write-Output "RECORDING. Go through the shots in Chrome."
Write-Output "When you are done, run:  .\record-oauth-demo.ps1 -Stop"
Write-Output "(it stops on its own after $MaxMinutes minutes)"
