Add-WindowsFeature Web-Server
Set-Content -Path "C:\inetpub\wwwroot\Videos\Default.html" -Value "This message is coming from server $($env:computername) !"