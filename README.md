# AutoIt-Scripts
A collection of scripts used for automating or simplifying certain tasks with library software/tools using the [AutoIt Scripting language and compiler](https://www.autoitscript.com/site/).

1. [IconMap.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/IconMap.au3>)  
   This tool allows the saving and restoring of icon positioning on the Windows Desktop. It's much easier and faster than manually clicking, dragging, and reordering of icons to match a particular layout scheme. Note: _IconMap is a command line tool._  
   
   **Save a layout:** (the filename and extension are irrelevant)  
   `iconmap.exe /save layout.ini`  
   **Restore a layout:**  
   `iconmap.exe /restore layout.ini`  
   
   IconMap also supports an `/install` and `/uninstall` method if its desirable to offer a context menu for saving and/or restoring from (specifically) a `*.icn` filetype. Neither of these methods are required to use the script. See the code for more.

2. [cellphone_splash.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/cellphone_splash.au3>)  
   On its own it will currently display a fullscreen kiosk-style message for a predetermined amount of time, using an image file upon run. This script is currently used in combination with `run_on_window.au3` to instantiate itself once a particular application is detected. To use it without `run_on_window.au3` as standalone, uncomment lines 25-27 and set the target application's window title in line 12 (`$window_title`), or in a `settings.ini` file.

3. [chat_config_install.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/chat_config_install.au3>)  
   This is a fairly specific tool intended to be used for providing a custom, silent background install of Pidgin, a multi-protocol chat client (intended for use with LibraryH3lp). As of yet this purpose has not been realized (we're not currently using Pidgin or LibraryH3lp) and may contain bugs. This script must be modified for the particular file locations and permissions within your organization, a `settings.ini` file is not provided as it could cause unwanted modifications.  
   
   Necessary modifications:
   - Line 73: The full network share path to the Pidgin MSI file
   - Line 81: The full network share path to a [customized default configuration](<https://developer.pidgin.im/wiki/ConfigurationFiles>) of Pidgin

   The compiled executable of the script can be provided (via network share) along with a provided username and password as created within LibraryH3lp by an administrator. The end-user will prompted for three (3) values: username, password, domain -- the first two values are required, the domain is optional and dependent upon your organization's setup. Once provided, the script will install a customized Pidgin pre-configured for that user.  
   
   Note: Error checking for the username and password fields cannot be done prior to install with this script as-is.

4. [countdown_timer-old.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/countdown_timer-old.au3>)  
   Although succeeded by the updated and current `countdown_timer.au3` for its specifically intended purpose, this version still can prove useful for other purposes if modified (namely line 11, or create and set the value in a `settings.ini` file).

5. [countdown_timer.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/countdown_timer.au3>)  
   This countdown timer was purposefully and specifically built for a unique purpose - to set, hook to a window, display and animate a countdown timer on Librarica's Cassie (PC Reservation System) print release station PC's patron dialog interface window. When a patron goes to an unmanaged print release/management station to make a payment (if attached to a coinbox) and to release their print jobs, their account window never closes automatically. Originally we used a simple countdown timer (above) that would simply close the window after a set period of time. There was no feedback. Customers complained. We eventually built this tool to provide visual feedback on exactly _when_ the window would close -- closing the window was important: without closing the window, other patrons could potentially access private and otherwise secure documents of another patron's account. Although this script is configurable, its purpose is highly tied to being used in this unique scenario and would likely be useless in any other application.  
   
   ![screenshot of countdown timer atop Cassie's Print Release window](./../screenshots/countdown-timer.jpg?raw=true "Countdown Timer")  
   The area encircled with red is the `countdown_timer` script's GUI. The top and bottom text, font, and font size, are all configurable. The starting countdown time is configurable, as well as its font and font size, and two optional values can be set to change the countdown timer's text color are specified (remaining) seconds. An alarm can also be configured to sound at the last remaining countdown time. The window closes after displaying 0 (zero). 

6. [desktop_icons_toggle.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/desktop_icons_toggle.au3>)  
   When a slower PC first boots up, desktop icons are some of the first objects to load up. Unfortunately other processes that we want to run or start up _prior_ to the user having access to an interface have not yet loaded. By initially hiding the icons, then both after our desired applications run and before a restart we run this script to toggle the icon visibility, those problems are solved. Alternatively, maybe you just want a taskbar button to make your desktop look cleaner on request. This'll do that for you.
   
7. [kiosk_on_timer.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/kiosk_on_timer.au3>)  
   Another script for a specifically unique purpose (tied to Cassie): Alerting users on the computer, using a kiosk-style display, of remaining time (default: 10 minutes) before their session will end. Patrons often ignore the built-in alert, then complain when their work was lost. This kiosk display provides a button to bypass it, otherwise will (by default) display for 20 seconds (configurable in the `settings.ini` file). By providing a button, it forces the user to interact with it and therefore, theoretically, confirm and agree to taking note of their remaining time.

8. [msra_gui.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/msra_gui.au3>)  
   A technician help tool _helper_. **MSRA** is the Microsoft (MS) Remote (R) Assistance (A) tool. This particular version of it has been bundled with Microsoft Windows since _Windows 7_ and is still available as of _Windows 10_. MSRA has a command line, and GUI version of its tool. The GUI version's process begins with the end-user seeking help from another user. The command line version can forcibly attempt to start a remote assistance session with an end-user who might be less technically inclined to start such a tool on their own. This script provides a GUI to make it easier to provide the command line's functionality for support staff by supplying a computer name. It queries the current Active Directory to retrieve all computer names on the network in a dropdown input box with type-hinting, and a BIG hard-to-miss button to begin the remote assistance handshake process. This script has its [own repository](<https://github.com/BrendonKoz/msra_gui>) as well.  

   ![screenshot of MSRA_GUI after typing a partial PC name from the dropdown input box](./../screenshots/msra.png?raw=true "MSRA GUI")  

9. [myfiles.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/myfiles.au3>)  
   In our organization, full-time employees have their own computers and log in to them with their user account. Service desk computers (those serving the public and shared amongst many staff members throughout the day) make use of an autologin user account. All staff members also have a folder redirection set on their **Documents** folder that points to a private folder on the server share, accessible only to them. This script provides a GUI to generate a temporary mapped drive to their Documents folder from any computer on the same network, allowing them access to their own files when they'd otherwise have none. A default domain name, server name (for the share), server IP address, redirect folder path, and settings for the share drive are all configurable.  
   
   ![screenshot of myfiles authentication window](./../screenshots/myfiles.png?raw=true "My Files")

10. [prevent_sleep.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/prevent_sleep.au3>)  
    Running this script will prevent a machine from going to sleep. Monitors may still sleep, but the computer should not. As ironic as it is, Windows Update, during its updating process, does not prevent a computer from entering sleep/hibernate modes. Supposedly Windows 10 has a fix for this in an upcoming build, but as of right now - while we enable sleep mode building-wide for electricity savings, we needed to come up with a way to also allow Windows Update to function alongside sleep/hibernate without corrupting the OS. This was our solution - though it is scripted into our update process, so pseudo-manually. This script was essentially taken from the [AutoIt Forums](<https://www.autoitscript.com/forum/topic/152381-screensaver-sleep-lock-and-power-save-disabling/>).

11. [run_on_window.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/run_on_window.au3>)  
    A command line script that can run another command once an application window is detected to either open, or close. For instance: Open Notepad 3 seconds after Microsoft Paint is closed. Window title names uses "fuzzy" partial matching. Running the script without any parameters will display a GUI help menu. Multiple delays and executable programs may be passed as arguments after the targetted window name (being opened or closed).
    
    ![screenshot of run_on_window's help dialog](./../screenshots/run_on_window.png?raw=true "run_on_window help")
    
    Example Usage:  
    `run_on_window.exe -c Paint 3 mspaint.exe`

12. [service_monitor.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/service_monitor.au3>)  
    This script will watch for a particular service (services.msc) that is running on a Windows OS, and if it is not running attempt to restart it. If it is unable to restart the service it will forcibly restart the computer. The service name, error message, and delay of time before the restart are all configurable in a `settings.ini` file.

13. [set_resolution.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/set_resolution.au3>)  
    When run, this script will attempt to set the local computer's resolution to whatever value is set in its `settings.ini` file for the `width` and `height` values. Default in the script is set to 1280x720 (standard widescreen 720p), similar to the older 1024x768 resolutions. Our PCs are imaged at native resolutions, this script is run using run_on_window after a patron logs in (usage policy window is closed) and then the resolution changes to something more readable for those who have poorer eyesight. A kiosk message (all black background) is also shown at the same time so that the screen flickering isn't really noticeable.

14. [share_permissions.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/share_permissions.au3>)  
    Similarly to the **`myfiles.au3`** script above, this application accesses our entire organization's share drive (a pre-mapped drive letter linking to a server's file store), but does so using the priviledges of the user logging in with this script instead of those of the currently logged in user (typically if a service desk autologin account doesn't have access to view/access hidden files on the network share). The same configuration values for `myfiles` apply here as well.
    
    ![screenshot of share_permissions authentication window](./../screenshots/share_permissions.png?raw=true "Share Permissions")

15. [startup_kiosk_splash.au3](<https://github.com/SaratogaLibrary/AutoIT-Scripts/blob/master/startup_kiosk_splash.au3>)  
    On run, will wait to detect a window being closed, once closed it will display a kiosk-style informational interface to the user using an image. Configurable values include the time to display, name of application to wait for, image filename, background color of the kiosk interface, and the image's width and height (to be able to center it on the screen; by default it expects the image to be the full size of the resolution).
