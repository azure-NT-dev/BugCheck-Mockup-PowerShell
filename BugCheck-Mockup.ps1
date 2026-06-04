Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$stopCodes = @(
    @{ Code = "DRIVER_IRQL_NOT_LESS_OR_EQUAL"; Failed = "myfault.sys" },
    @{ Code = "IRQL_NOT_LESS_OR_EQUAL"; Failed = "ntoskrnl.exe" },
    @{ Code = "PAGE_FAULT_IN_NONPAGED_AREA"; Failed = "ntoskrnl.exe" },
    @{ Code = "CRITICAL_PROCESS_DIED"; Failed = "" },
    @{ Code = "SYSTEM_SERVICE_EXCEPTION"; Failed = "win32kfull.sys" },
    @{ Code = "KMODE_EXCEPTION_NOT_HANDLED"; Failed = "wdf01000.sys" },
    @{ Code = "DPC_WATCHDOG_VIOLATION"; Failed = "nvlddmkm.sys" },
    @{ Code = "WHEA_UNCORRECTABLE_ERROR"; Failed = "hal.dll" },
    @{ Code = "MEMORY_MANAGEMENT"; Failed = "" },
    @{ Code = "KERNEL_DATA_INPAGE_ERROR"; Failed = "disk.sys" },
    @{ Code = "BAD_POOL_CALLER"; Failed = "ntfs.sys" },
    @{ Code = "MACHINE_CHECK_EXCEPTION"; Failed = "" },
    @{ Code = "VIDEO_TDR_FAILURE"; Failed = "nvlddmkm.sys" },
    @{ Code = "ATTEMPTED_WRITE_TO_READONLY_MEMORY"; Failed = "ntoskrnl.exe" },
    @{ Code = "SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"; Failed = "dxgkrnl.sys" },
    @{ Code = "KERNEL_SECURITY_CHECK_FAILURE"; Failed = "" },
    @{ Code = "DRIVER_IRQL_NOT_LESS_OR_EQUAL"; Failed = "ndis.sys" },
    @{ Code = "INACCESSIBLE_BOOT_DEVICE"; Failed = "storport.sys" },
    @{ Code = "NTFS_FILE_SYSTEM"; Failed = "ntfs.sys" },
    @{ Code = "KERNEL_MODE_HEAP_CORRUPTION"; Failed = "ntoskrnl.exe" },
    @{ Code = "POOL_CORRUPTION_IN_FILE_AREA"; Failed = "ntfs.sys" },
    @{ Code = "IRQL_GT_ZERO_AT_SYSTEM_SERVICE"; Failed = "ntoskrnl.exe" },
    @{ Code = "WORKER_INVALID"; Failed = "ntoskrnl.exe" },
    @{ Code = "APC_INDEX_MISMATCH"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_OVERRAN_STACK_BUFFER"; Failed = "ntoskrnl.exe" },
    @{ Code = "BUGCODE_USB_DRIVER"; Failed = "usbhub.sys" },
    @{ Code = "UNEXPECTED_STORE_EXCEPTION"; Failed = "" },
    @{ Code = "CRITICAL_STRUCTURE_CORRUPTION"; Failed = "ntoskrnl.exe" },
    @{ Code = "CLOCK_WATCHDOG_TIMEOUT"; Failed = "intelppm.sys" },
    @{ Code = "PFN_LIST_CORRUPT"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_POWER_STATE_FAILURE"; Failed = "ntoskrnl.exe" },
    @{ Code = "THREAD_STUCK_IN_DEVICE_DRIVER"; Failed = "dxgkrnl.sys" },
    @{ Code = "REGISTRY_ERROR"; Failed = "" },
    @{ Code = "STATUS_SYSTEM_PROCESS_TERMINATED"; Failed = "ntdll.dll" },
    @{ Code = "HAL_INITIALIZATION_FAILED"; Failed = "hal.dll" },
    @{ Code = "VIDEO_TDR_TIMEOUT_DETECTED"; Failed = "nvlddmkm.sys" },
    @{ Code = "MANUALLY_INITIATED_CRASH"; Failed = "kbdclass.sys" },
    @{ Code = "FAT_FILE_SYSTEM"; Failed = "fastfat.sys" },
    @{ Code = "DRIVER_VERIFIER_DETECTED_VIOLATION"; Failed = "verifier.sys" },
    @{ Code = "BUGCODE_NDIS_DRIVER"; Failed = "ndis.sys" },
    @{ Code = "ACPI_BIOS_ERROR"; Failed = "acpi.sys" },
    @{ Code = "FLTMGR_FILE_SYSTEM"; Failed = "fltmgr.sys" },
    @{ Code = "PCI_BUS_DRIVER_INTERNAL"; Failed = "pci.sys" },
    @{ Code = "WDF_VIOLATION"; Failed = "Wdf01000.sys" },
    @{ Code = "NMI_HARDWARE_FAILURE"; Failed = "" },
    @{ Code = "REFS_FILE_SYSTEM"; Failed = "ReFS.sys" },
    @{ Code = "KERNEL_AUTO_BOOST_LOCK_ACQUISITION_WITH_RAISED_IRQL"; Failed = "ntoskrnl.exe" },
    @{ Code = "UDFS_FILE_SYSTEM"; Failed = "udfs.sys" },
    @{ Code = "VIDEO_ENGINE_TIMEOUT_DETECTED"; Failed = "watchdog.sys" },
    @{ Code = "NDIS_INTERNAL_ERROR"; Failed = "ndis.sys" },
    @{ Code = "PAGE_FAULT_IN_FREED_SPECIAL_POOL"; Failed = "ntoskrnl.exe" },
    @{ Code = "KERNEL_AUTO_BOOST_INVALID_LOCK_RELEASE"; Failed = "ntoskrnl.exe" },
    @{ Code = "UNHANDLED_EXCEPTION_CONTEXT"; Failed = "" },
    @{ Code = "EXFAT_FILE_SYSTEM"; Failed = "exfat.sys" },
    @{ Code = "KERNEL_STACK_INPAGE_ERROR"; Failed = "ntoskrnl.exe" },
    @{ Code = "DATA_BUS_ERROR"; Failed = "" },
    @{ Code = "NO_MORE_SYSTEM_PTES"; Failed = "" },
    @{ Code = "TARGET_MDL_TOO_SMALL"; Failed = "" },
    @{ Code = "MUST_SUCCEED_POOL_EMPTY"; Failed = "" },
    @{ Code = "ATTEMPTED_SWITCH_FROM_DPC"; Failed = "ntoskrnl.exe" },
    @{ Code = "MUTUALLY_EXCLUSIVE_RESOURCE_MUST_BE_LONG_TERM"; Failed = "" },
    @{ Code = "DRIVER_LEFT_LOCKED_PAGES_IN_PROCESS"; Failed = "" },
    @{ Code = "TERMINAL_SERVER_DRIVER_MADE_INCORRECT_MEMORY_REFERENCE"; Failed = "rdpdr.sys" },
    @{ Code = "DRIVER_UNLOADED_WITHOUT_CANCELLING_PENDING_OPERATIONS"; Failed = "" },
    @{ Code = "SYSTEM_SCAN_AT_RAISED_IRQL_CAUGHT_IMPROPER_DRIVER_UNLOAD"; Failed = "" },
    @{ Code = "DRIVER_PORTION_MUST_BE_NONPAGED"; Failed = "" },
    @{ Code = "VIDEO_DRIVER_INIT_FAILURE"; Failed = "vgapnp.sys" },
    @{ Code = "BOOTLOG_FILE_SYSTEM"; Failed = "" },
    @{ Code = "AGP_INVALID_ACCESS"; Failed = "videoprt.sys" },
    @{ Code = "AGP_GART_CORRUPTION"; Failed = "videoprt.sys" },
    @{ Code = "AGP_ILLEGAL_GART_ACCESS"; Failed = "videoprt.sys" },
    @{ Code = "FTDISK_INTERNAL_ERROR"; Failed = "ftdisk.sys" },
    @{ Code = "PINBALL_FILE_SYSTEM"; Failed = "pinball.sys" },
    @{ Code = "CRITICAL_SERVICE_FAILED"; Failed = "" },
    @{ Code = "SET_ENV_VAR_FAILED"; Failed = "" },
    @{ Code = "IO1_INITIALIZATION_FAILED"; Failed = "" },
    @{ Code = "PROCESS1_INITIALIZATION_FAILED"; Failed = "" },
    @{ Code = "REF_LM_DEBUG_STRING"; Failed = "" },
    @{ Code = "SESSION3_INITIALIZATION_FAILED"; Failed = "smss.exe" },
    @{ Code = "CONFIG_INITIALIZATION_FAILED"; Failed = "" },
    @{ Code = "CONFIG_LIST_FAILED"; Failed = "" },
    @{ Code = "BAD_SYSTEM_CONFIG_INFO"; Failed = "" },
    @{ Code = "CANNOT_WRITE_CONFIGURATION"; Failed = "" },
    @{ Code = "PROCESS_HAS_LOCKED_PAGES"; Failed = "" },
    @{ Code = "PHASE0_EXCEPTION"; Failed = "" },
    @{ Code = "MISMATCHED_HAL"; Failed = "hal.dll" },
    @{ Code = "INSTALL_MORE_MEMORY"; Failed = "" },
    @{ Code = "SYSTEM_EXIT_OWNED_MUTEX"; Failed = "" },
    @{ Code = "MULTIPROCESSOR_CONFIGURATION_NOT_SUPPORTED"; Failed = "" },
    @{ Code = "UNEXPECTED_KERNEL_MODE_TRAP"; Failed = "ntoskrnl.exe" },
    @{ Code = "NDISTEST_INTERNAL_ERROR"; Failed = "ndis.sys" },
    @{ Code = "SPECIAL_POOL_DETECTED_MEMORY_CORRUPTION"; Failed = "ntoskrnl.exe" },
    @{ Code = "DRIVER_CORRUPTED_EXPOOL"; Failed = "" },
    @{ Code = "DRIVER_CORRUPTED_MMPOOL"; Failed = "" },
    @{ Code = "DRIVER_USED_EXCESSIVE_PTES"; Failed = "" },
    @{ Code = "DRIVER_INVALID_STACK_ACCESS"; Failed = "" },
    @{ Code = "CHR_INTERNAL_ERROR"; Failed = "" },
    @{ Code = "RESOURCE_NOT_OWNED"; Failed = "" },
    @{ Code = "CANCEL_STATE_IN_COMPLETED_IRP"; Failed = "" },
    @{ Code = "SYSTEM_THREAD_NOT_GRANTED_ACCESS"; Failed = "" },
    @{ Code = "DRIVER_RETURNED_STATUS_REPARSE_FOR_VOLUME_OPEN"; Failed = "" },
    @{ Code = "HTTP_DRIVER_CORRUPTED"; Failed = "http.sys" },
    @{ Code = "SECURE_KERNEL_ERROR"; Failed = "securekernel.exe" },
    @{ Code = "HYPERVISOR_ERROR"; Failed = "hvix64.sys" },
    @{ Code = "WINLOGON_FATAL_ERROR"; Failed = "winlogon.exe" },
    @{ Code = "DRIVER_RETURNED_HOLDING_LOCK"; Failed = "" },
    @{ Code = "KERNEL_THREAD_PRIORITY_FLOOR_VIOLATION"; Failed = "ntoskrnl.exe" },
    @{ Code = "VIDEO_SCHEDULER_INTERNAL_ERROR"; Failed = "dxgmms2.sys" },
    @{ Code = "ATTEMPTED_EXECUTE_OF_NOEXECUTE_MEMORY"; Failed = "ntoskrnl.exe" }
)
$errorChoice = $stopCodes | Get-Random
$StopCode = $errorChoice.Code
$WhatFailed = $errorChoice.Failed

$form = [System.Windows.Forms.Form]::new()
$form.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.TopMost = $true
$form.Cursor = [System.Windows.Forms.Cursors]::Hide

$form.Add_KeyDown({ if ($_.KeyCode -eq 'Escape') { Stop-Process -Id $PID -Force } })

[int]$w = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
[int]$h = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
if ($w -eq 0) { $w = 1920 }; if ($h -eq 0) { $h = 1080 }
$scaleX = $w / 1920
$scaleY = $h / 1080

$leftMargin = [int](230 * $scaleX)
$frownFontSize = [int](150 * $scaleY)
$mainFontSize = [int](28 * $scaleY)
$textYStart = [int](420 * $scaleY)

$lblSad = [System.Windows.Forms.Label]::new()
$lblSad.Text = ":("
$lblSad.Font = [System.Drawing.Font]::new("Segoe UI Light", $frownFontSize)
$lblSad.ForeColor = [System.Drawing.Color]::White
$lblSad.AutoSize = $true
$lblSad.Location = [System.Drawing.Point]::new($leftMargin, [int](140 * $scaleY))
$form.Controls.Add($lblSad)

$lblMain = [System.Windows.Forms.Label]::new()
$lblMain.Text = "Your device ran into a problem and needs to restart. We're just collecting some error info, and then we'll restart for you."
$lblMain.Font = [System.Drawing.Font]::new("Segoe UI", $mainFontSize)
$lblMain.ForeColor = [System.Drawing.Color]::White
$lblMain.AutoSize = $true
$lblMain.MaximumSize = [System.Drawing.Size]::new([int](1400 * $scaleX), 0)
$lblMain.Location = [System.Drawing.Point]::new($leftMargin, $textYStart)
$form.Controls.Add($lblMain)

$lblPct = [System.Windows.Forms.Label]::new()
$lblPct.Text = "0% complete"
$lblPct.Font = [System.Drawing.Font]::new("Segoe UI", [int](24 * $scaleY))
$lblPct.ForeColor = [System.Drawing.Color]::White
$lblPct.AutoSize = $true
$lblPct.Location = [System.Drawing.Point]::new($leftMargin, [int](590 * $scaleY))
$form.Controls.Add($lblPct)

$bottomPanel = [System.Windows.Forms.Panel]::new()
$bottomPanel.Location = [System.Drawing.Point]::new($leftMargin, [int](680 * $scaleY))
$bottomPanel.Size = [System.Drawing.Size]::new([int](1400 * $scaleX), [int](320 * $scaleY))
$form.Controls.Add($bottomPanel)

$qr = [System.Windows.Forms.PictureBox]::new()
$qr.Size = [System.Drawing.Size]::new([int](140 * $scaleY), [int](140 * $scaleY))
$qr.SizeMode = 'StretchImage'
$bottomPanel.Controls.Add($qr)

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wc = [System.Net.WebClient]::new()
    $qrData = $wc.DownloadData("https://api.qrserver.com/v1/create-qr-code/?size=140x140&data=https://www.windows.com/stopcode")
    $qr.Image = [System.Drawing.Image]::FromStream([System.IO.MemoryStream]::new($qrData))
} catch {
    $qr.BackColor = [System.Drawing.Color]::White
}

$lblSupport = [System.Windows.Forms.Label]::new()
$lblSupport.Font = [System.Drawing.Font]::new("Segoe UI", [int](13 * $scaleY))
$lblSupport.ForeColor = [System.Drawing.Color]::White
$lblSupport.AutoSize = $true
$lblSupport.Location = [System.Drawing.Point]::new([int](170 * $scaleX), 0)
$supportText = "For more information about this issue and possible fixes, visit https://www.windows.com/stopcode`r`nIf you call a support person, give them this info:`r`nStop code: $StopCode"
if ($WhatFailed) { $supportText += "`r`nWhat failed: $WhatFailed" }
$lblSupport.Text = $supportText
$bottomPanel.Controls.Add($lblSupport)

$timer = [System.Windows.Forms.Timer]::new()
$timer.Interval = 1500
$script:pct = 0
$timer.Add_Tick({
    $script:pct += (Get-Random -Min 8 -Max 22)
    if ($script:pct -ge 100) { 
        $script:pct = 100
        $lblPct.Text = "100% complete"
        $timer.Stop()
        
        $form.Controls.Clear()
        $form.BackColor = [System.Drawing.Color]::Black
        $form.Refresh()
        
        Start-Sleep -Seconds 5
        Stop-Process -Id $PID -Force
    } else {
        $lblPct.Text = "$script:pct% complete"
    }
})

$timer.Start()
[void]$form.ShowDialog()
