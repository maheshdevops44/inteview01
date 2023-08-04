
# PowerShell version
$PSVersionTable
$PSVersionTable.PSVersion

# The Get-Command cmdlet returns a list of all available commands that are installed on your system.

Get-Command

#You can filter the output of Get-Command, using different parameters.

Get-Command -Name '*Process'

Get-Command -Name 'Get*'

Get-Verb
# Filter on verb.
Get-Command -Verb 'Start' 

# Filter on Noun.
Get-Command -Noun U* 

#combine the two parameters 
Get-Command -Verb Get -Noun U*

# Get Help about any command
Get-Help about
Get-Help about_az
Get-Help about_az | more

# Pipelining connects commands with a pipe | character. The output of one command is the input for the next, read left to right.

Get-Command | Select-Object -First 3

Get-Process | Where-Object {$_.ProcessName -like "p*"}  # $_ denotes the current object on which the filtering will be done

Get-Process | Where-Object {$_.ProcessName -like "p*"} | Format-List ProcessName

Get-Service | Where-Object {$_.Status -eq "Running"}

#Find all procesesses that use more than 1000 MB of memory, and kill them
Get-Process | Where-Object{$_.WS -gt 1000MB} | Stop-Process


# Varaible 
$var = "this is sampple string"
Write-Output $var

Write-Output $var.Length

# Array

$dayarray = "Sun", "Mon", "Tue", "Wed"

foreach($col in $dayarray)
{
    Write-Output $col    
}

# Function
function AddValue {
    param (
        $val1, $val2
    )
    Write-Output ($val1 + $val2)
    
}

AddValue 3 4

# List all files/directories in the current directory
Get-ChildItem
dir
ls
gci

# Read the content of file
Get-Content StorageAccount.ps1


# Take content in to variable
$filecontent = Get-Content .\StorageAccount.ps1
Write $filecontent

#############################################################################################################################
# Using .Net Objects
<#     
PowerShell treats everything as an object. Even a straightforward string like "name" is a System object. String.
Any object can be piped to Get-Member to display its type name, along with its properties and methods.
#>

$var = "Hello World"
$var | Get-Member

$var.Length
$var.ToLower()
$var.ToUpper()

$var1 = "This is Var 1"
$var2 = "This is Var 1"
$varcompare = $var1.CompareTo($var2)
Write-Output $varcompare

# "::" operator is used to call the static members
$var1 = "This is Var 1"
$var2 = "This is Var 2"
[string]::Compare($var1, $var2, $true)

[diagnostics.process]::GetProcesses()