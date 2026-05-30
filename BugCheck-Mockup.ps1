Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$stopCodes = @(
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
    @{ Code = "BUGCODE_USB_DRIVER"; Failed = "usbhub.sys" }
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
