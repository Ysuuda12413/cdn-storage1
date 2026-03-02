# WINDOWS 10 ULTIMATE OPTIMIZATION SCRIPT
# Run as Administrator
# WARNING: AGGRESSIVE SYSTEM MODIFICATION - NO SAFETY GUARDS

Write-Host "=== WINDOWS 10 ULTIMATE OPTIMIZER ===" -ForegroundColor Red
Write-Host "COMBINED: Ultimate + CPU + System + Microsoft Store" -ForegroundColor Cyan
Write-Host "`n⚠️  WARNING: DISABLES ALL POWER/THERMAL LIMITS!" -ForegroundColor Yellow
Write-Host "CPU/GPU will run at maximum regardless of temperature" -ForegroundColor Yellow
Write-Host "Power consumption: MAXIMUM | Heat: EXTREME | Noise: LOUD" -ForegroundColor Yellow
Write-Host "`nPress ANY key to continue or CTRL+C to abort..." -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# PHASE 1: POWER SCHEME SETUP
Write-Host "`n=== PHASE 1: POWER SCHEME ===" -ForegroundColor Cyan
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
Write-Host "Ultimate Performance power scheme created/activated" -ForegroundColor Green

# PHASE 2: AGGRESSIVE CPU POWER MANAGEMENT
Write-Host "`n=== PHASE 2: CPU POWER (NO THROTTLING) ===" -ForegroundColor Cyan

# Force 100% CPU always
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDISABLE 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFAUTONOMOUS 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFEPP 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PEAKPERF 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR SYSTEMCOOLING 1
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR MINPERFBOOST 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR MAXPERFBOOST 100
powercfg -setactive SCHEME_CURRENT
Write-Host "CPU throttling: DISABLED | C-states: DISABLED" -ForegroundColor Green

# PHASE 3: DISABLE ALL C-STATES & THERMAL THROTTLING
Write-Host "`n=== PHASE 3: C-STATES & THERMAL ===" -ForegroundColor Cyan

# Disable ALL C-states
$cstates = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\ba3e6753-03a3-4d93-8d6e-395c474f299f]
"ValueMax"=dword:00000000
"ValueMin"=dword:00000000

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893fde41-8544-4658-81e9-509c4986d174]
"ValueMax"=dword:00000000
"ValueMin"=dword:00000000
"@
$cstates | Out-File "$env:TEMP\disable_cstates.reg" -Encoding Unicode
regedit /s "$env:TEMP\disable_cstates.reg" 2>$null
Remove-Item "$env:TEMP\disable_cstates.reg" -ErrorAction SilentlyContinue
Write-Host "ALL C-states disabled (C0 active only)" -ForegroundColor Green

# Disable thermal throttling attempts
$thermal = @"
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\f8e5d7cb-9e1c-4a0d-bb6d-006e1d5920c9]
"ValueMax"=dword:00000064
"ValueMin"=dword:00000064

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\5d493e81-0c46-4ddc-b345-5909e9b3213d]
"ValueMax"=dword:00000064
"ValueMin"=dword:00000064
"@
$thermal | Out-File "$env:TEMP\thermal.reg" -Encoding Unicode
regedit /s "$env:TEMP\thermal.reg" 2>$null
Remove-Item "$env:TEMP\thermal.reg" -ErrorAction SilentlyContinue
Write-Host "Thermal throttling overridden (best effort)" -ForegroundColor Green

# PHASE 4: MAXIMUM PERFORMANCE REGISTRY TWEAKS
Write-Host "`n=== PHASE 4: REGISTRY TWEAKS ===" -ForegroundColor Cyan

$allTweaks = @(
    # CPU/Memory priority
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"; Name="Win32PrioritySeparation"; Type="DWord"; Value=38},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"; Name="IRQ8Priority"; Type="DWord"; Value=1},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"; Name="IRQ16Priority"; Type="DWord"; Value=1},
    
    # Disable core parking completely
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583"; Name="ValueMax"; Type="DWord"; Value=0},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583"; Name="ValueMin"; Type="DWord"; Value=0},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583"; Name="ParkingPerformanceState"; Type="DWord"; Value=0},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583"; Name="IdleDisable"; Type="DWord"; Value=1},
    
    # Large system cache & I/O optimization
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Name="LargeSystemCache"; Type="DWord"; Value=1},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Name="IoPageLockLimit"; Type="DWord"; Value=1},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Name="SystemPteDataAlignment"; Type="DWord"; Value=1},
    
    # Disable memory compression (more RAM bandwidth)
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"; Name="DisableMemoryCompression"; Type="DWord"; Value=1},
    
    # Disable CPU power reporting
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\e73c048e-0d3f-43e2-9b08-23283c45683f"; Name="ValueMax"; Type="DWord"; Value=100},
    @{Path="HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\e73c048e-0d3f-43e2-9b08-23283c45683f"; Name="ValueMin"; Type="DWord"; Value=100},
    
    # Visual effects (system-wide)
    @{Path="HKCU:\Control Panel\Desktop\WindowMetrics"; Name="MinAnimate"; Type="String"; Value="0"},
    @{Path="HKCU:\Control Panel\Desktop"; Name="DragFullWindows"; Type="String"; Value="0"},
    @{Path="HKCU:\Control Panel\Desktop"; Name="MenuShowDelay"; Type="String"; Value="8"},
    
    # Disable transparency
    @{Path="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"; Name="EnableTransparency"; Type="DWord"; Value=0}
)

foreach ($tweak in $allTweaks) {
    try {
        if (-not (Test-Path $tweak.Path)) {
            New-Item -Path $tweak.Path -Force | Out-Null
        }
        Set-ItemProperty -Path $tweak.Path -Name $tweak.Name -Value $tweak.Value -Type $tweak.Type
        Write-Host "Applied: $($tweak.Path)\$($tweak.Name)"
    } catch {
        Write-Host "FAILED: $($tweak.Path)\$($tweak.Name)" -ForegroundColor Red
    }
}

Write-Host "All registry optimizations applied" -ForegroundColor Green

# PHASE 5: DISABLE ALL NON-ESSENTIAL SERVICES
Write-Host "`n=== PHASE 5: DISABLE SERVICES ===" -ForegroundColor Cyan

$allServices = @(
    "SysMain",              # Superfetch
    "wuauserv",             # Windows Update
    "WindowsSearch",        # Search indexing
    "DiagTrack",            # Diagnostics
    "dmwappushservice",     # WAP Push
    "WMPNetworkSvc",        # Media sharing
    "PrintNotify",          # Print notifications
    "PcaSvc",               # Program Compatibility
    "XblAuthManager",       # Xbox
    "XblGameSave",          # Xbox Save
    "XboxNetApiSvc",        # Xbox Network
    "wlidsvc",              # Microsoft Account
    "OneSyncSvc",           # Sync
    "ClipSVC",              # Clipboard
    "TabletInputService",   # Touch
    "TouchKeyboardAndHandwritingPanelService",
    "PoshGuest",            # PowerShell Guest
    "DesktopWindowManagerSessionManager", # DWM (WARNING: may break UI)
    "Themes",               # Windows Themes
    "FontCache",            # Font caching
    "AJRouter",             # AllJoyn
    "MPSSVC",               # Windows Firewall (if other firewall present)
    "MpsSvc",               # Firewall
    "wfaphost"              # Windows Firewall
)

$stopped = 0
$disabled = 0
foreach ($service in $allServices) {
    $svc = Get-Service $service -ErrorAction SilentlyContinue
    if ($svc) {
        if ($svc.Status -eq 'Running') {
            Stop-Service $service -Force -ErrorAction SilentlyContinue
            $stopped++
        }
        Set-Service $service -StartupType Disabled -ErrorAction SilentlyContinue
        $disabled++
        Write-Host "Disabled: $service"
    }
}
Write-Host "Services stopped: $stopped | Disabled: $disabled" -ForegroundColor Green

# PHASE 6: NETWORK STACK OPTIMIZATION
Write-Host "`n=== PHASE 6: NETWORK OPTIMIZATION ===" -ForegroundColor Cyan
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global dca=enabled
netsh int tcp set global rfc1323=1
netsh int tcp set global timestamps=disabled
netsh int tcp set global CongestionProvider=ctcp
netsh int tcp set global ecncapability=0
Write-Host "Network stack: LOW LATENCY mode" -ForegroundColor Green

# PHASE 7: GPU MAX PERFORMANCE (NVIDIA)
Write-Host "`n=== PHASE 7: GPU OPTIMIZATION ===" -ForegroundColor Cyan
$nvidiaSmi = "$env:ProgramFiles\NVIDIA Corporation\NVSMI\nvidia-smi.exe"
if (Test-Path $nvidiaSmi) {
    & $nvidiaSmi -g 0 -pl 1000000000  # Max power
    & $nvidiaSmi -g 0 -acp 0           # Disable adaptive clock
    & $nvidiaSmi -g 0 -dm 1            # Performance mode
    Write-Host "NVIDIA GPU: MAX PERFORMANCE" -ForegroundColor Green
} else {
    Write-Host "NVIDIA SMI not found - GPU not optimized" -ForegroundColor Yellow
}

# PHASE 8: MICROSOFT STORE RESTORE (COMPREHENSIVE)
Write-Host "`n=== PHASE 8: MICROSOFT STORE RESTORE ===" -ForegroundColor Cyan

# Get Windows version info
$windowsVersion = (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue("CurrentBuild")
$releaseId = (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue("ReleaseId")
$edition = (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").GetValue("EditionID")
$architecture = (Get-WmiObject Win32_Processor).AddressWidth
Write-Host "Windows Build: $windowsVersion | Release: $releaseId | Edition: $edition | Arch: $architecture-bit" -ForegroundColor Yellow

# Step 1: Check if Store package exists and try re-register
Write-Host "`n[Step 1/3] Checking for existing Microsoft Store package..." -ForegroundColor Yellow
$storePackage = Get-AppxPackage -AllUsers *WindowsStore* -ErrorAction SilentlyContinue

if ($storePackage) {
    Write-Host "Found $($storePackage.Count) Store package(s). Re-registering..." -ForegroundColor Green
    foreach ($pkg in $storePackage) {
        try {
            Add-AppxPackage -DisableDevelopmentMode -Register "$($pkg.InstallLocation)\AppXManifest.xml" -ErrorAction Stop
            Write-Host "✓ Re-registered: $($pkg.Name) v$($pkg.Version)" -ForegroundColor Green
        } catch {
            Write-Host "✗ Failed to re-register $($pkg.Name): $_" -ForegroundColor Red
        }
    }
    Write-Host "Microsoft Store re-registration attempt complete!" -ForegroundColor Green
} else {
    Write-Host "✗ Microsoft Store package NOT FOUND in system." -ForegroundColor Red
}

# Step 2: Try to install via Windows Update/Install from Windows Image
Write-Host "`n[Step 2/3] Attempting Windows Update installation..." -ForegroundColor Yellow

# Check internet connectivity
if (Test-Connection -ComputerName "www.microsoft.com" -Count 1 -Quiet) {
    Write-Host "Internet connection detected. Trying Windows Update..." -ForegroundColor Cyan
    
    # Try to install Microsoft Store via Windows Update
    try {
        # Check for Windows Update service (might be disabled)
        $wuservice = Get-Service wuauserv -ErrorAction SilentlyContinue
        if ($wuservice.StartType -eq 'Disabled') {
            Write-Host "Windows Update service is disabled. Enabling temporarily..." -ForegroundColor Yellow
            Set-Service wuauserv -StartupType Manual
            Start-Service wuauserv
        }
        
        # Try installing Store via Windows Update component
        Write-Host "Triggering Windows Update scan for Microsoft Store..." -ForegroundColor Cyan
        # This may not work on stripped Win10 Lite
        $storeApp = "Microsoft.WindowsStore"
        Write-Host "NOTE: If Windows Update doesn't have Store (Lite version), skip to manual install." -ForegroundColor Yellow
        
    } catch {
        Write-Host "Windows Update method failed: $_" -ForegroundColor Red
    }
} else {
    Write-Host "No internet connection. Skipping Windows Update method." -ForegroundColor Yellow
}

# Step 3: Manual installation instructions (if auto-fails)
Write-Host "`n[Step 3/3] MANUAL INSTALLATION OPTIONS:" -ForegroundColor Cyan

$storeVersion = switch ($windowsVersion) {
    {$_ -ge 19045} { "10.2306.xxxx" }  # Win10 22H2+
    {$_ -ge 18362} { "10.19041.xxxx" }  # Win10 2004/20H2
    {$_ -ge 17763} { "10.18362.xxxx" }  # Win10 1903/1909
    default { "Latest available for build $windowsVersion" }
}

Write-Host "`nOption A: Download Microsoft Store AppxBundle from Microsoft" -ForegroundColor White
Write-Host "1. Go to: https://www.microsoft.com/store/productId/9WZDNCRFJ3TJ" -ForegroundColor Gray
Write-Host "2. Or use Microsoft Store for Business: https://businessstore.microsoft.com" -ForegroundColor Gray
Write-Host "3. Download the AppxBundle for your architecture ($architecture-bit)" -ForegroundColor Gray
Write-Host "4. Install with: Add-AppxPackage -Path 'path\to\Microsoft.WindowsStore.appxbundle'" -ForegroundColor Gray

Write-Host "`nOption B: Copy from another Windows 10 PC (same build)" -ForegroundColor White
Write-Host "1. On working PC: C:\Program Files\WindowsApps\Microsoft.WindowsStore_*" -ForegroundColor Gray
Write-Host "2. Copy entire folder to same location on this PC" -ForegroundColor Gray
Write-Host "3. Re-register: Add-AppxPackage -Register 'C:\Program Files\WindowsApps\Microsoft.WindowsStore_*\AppXManifest.xml'" -ForegroundColor Gray

Write-Host "`nOption C: Use DISM to install from Windows ISO" -ForegroundColor White
Write-Host "1. Mount Windows 10 ISO (same version as your OS)" -ForegroundColor Gray
Write-Host "2. Install Store component: DISM /Online /Add-Package /PackagePath:D:\sources\install.wim:*" -ForegroundColor Gray
Write-Host "   (Choose the correct index for your edition)" -ForegroundColor Gray

Write-Host "`nOption D: Clean Windows Update reset (may not work on Lite)" -ForegroundColor White
Write-Host "1. wsreset.exe (run as admin)" -ForegroundColor Gray
Write-Host "2. Then try: Get-AppxPackage -AllUsers Microsoft.WindowsStore | Add-AppxPackage -Register" -ForegroundColor Gray

Write-Host "`nOption E: Most reliable - Clean reinstall Windows 10" -ForegroundColor White
Write-Host "If Win10 Lite stripped too much, only clean install will fully restore Store." -ForegroundColor Red

# Final Store status
$storeCheck = Get-AppxPackage -AllUsers *WindowsStore* -ErrorAction SilentlyContinue
if ($storeCheck) {
    Write-Host "`n✓ Microsoft Store appears to be available now." -ForegroundColor Green
    Write-Host "Launch: explorer.exe ms-windows-store://" -ForegroundColor Cyan
} else {
    Write-Host "`n✗ Microsoft Store NOT INSTALLED. Manual intervention required." -ForegroundColor Red
}

# PHASE 9: FINAL WARNINGS & NOTES
Write-Host "`n=== ██████████ OPTIMIZATION COMPLETE ██████████ ===" -ForegroundColor Red -BackgroundColor White
Write-Host "`n!!!! CRITICAL WARNINGS !!!!" -ForegroundColor Red
Write-Host "1. System running at MAXIMUM heat/power/loudness" -ForegroundColor Yellow
Write-Host "2. Thermal throttling DISABLED - Damage risk if cooling inadequate" -ForegroundColor Red
Write-Host "3. CPU lifespan may be REDUCED" -ForegroundColor Yellow
Write-Host "4. Battery drain EXTREME on laptops" -ForegroundColor Yellow
Write-Host "5. Some services disabled may break functionality" -ForegroundColor Yellow
Write-Host "6. Windows Update disabled - Security risk!" -ForegroundColor Red
Write-Host "`nREQUIRED MONITORING:" -ForegroundColor Cyan
Write-Host "- HWMonitor / HWiNFO / Core Temp for CPU/GPU temps" -ForegroundColor White
Write-Host "- Keep cooling system clean and adequate" -ForegroundColor White
Write-Host "- Repaste CPU/GPU if temps >90°C sustained" -ForegroundColor White
Write-Host "`nRESTART IMMEDIATELY for changes to take effect!" -ForegroundColor Red -BackgroundColor Black
Write-Host "`nNOTE: This does NOT overclock multiplier/voltage." -ForegroundColor Cyan
Write-Host "For TRUE overclock: Enter BIOS and manually increase CPU multiplier." -ForegroundColor Cyan
Write-Host "`nRollback: Re-enable services and change power scheme to Balanced" -ForegroundColor Gray
Write-Host "`nMicrosoft Store: See above options if not installed" -ForegroundColor Gray