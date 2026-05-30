# BugCheck-Mockup-PowerShell

This project simulates a kernel-level failure from the Windows NT kernel.  
It provides a user‑mode (ring 3) overlay that reproduces the appearance of a Windows 10/11 BugCheck screen.  
The intent is to demonstrate the visual behavior of a system crash without interacting with or destabilizing the actual operating system kernel.

---

## Features
- Overlay rendering of the Windows BugCheck (BSOD) screen
- Randomized real stop codes for authenticity
- Real‑time percentage progress indicator
- QR code display consistent with modern BSODs
- Black screen transition (~5 seconds) before exit
- Automatic termination of PowerShell and child process

---

## Important Note
This project does not crash or interact with the actual Windows kernel.  
All functionality is implemented in user‑mode (ring 3) and is non‑destructive.  
It is intended for demonstration, testing, or educational purposes only.

---

## Usage
1. Clone the repository:
   ```powershell
   git clone https://github.com/azure-NT-dev/BugCheck-Mockup-PowerShell.git

2. Navigate to the directory: cd BugCheck-Mockup-PowerShell

3. Run the script: .\BugCheck-Mockup.ps1

4.  After the script runs it'll immediately show the Blue Screen of Death.


