#Requires -RunAsAdministrator

# https://www.sqlshack.com/setting-up-the-dark-theme-in-sql-server-management-studio/

[cmdletbinding()]Param(
    [switch]$disable
)

$file    = "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\ssms.pkgundef"
$disable_line = "[`$RootKey`$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]"
$enable_line  = "// [`$RootKey`$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]"


if(Test-Path $file){
    # take a backup first
    Copy-Item $file "~/Desktop/ssms_$(Get-Date -Format "yyyy-MM-ddThh.mm.ss").pkgundef" 
    
    # default is "enable"
    if($disable){
        (Get-Content $file -Raw) -replace [Regex]::Escape($enable_line), $disable_line | Out-File -LiteralPath $file
    } else {
        (Get-Content $file -Raw) -replace [Regex]::Escape($disable_line), $enable_line | Out-File $file
    }
} else {
    Write-Error "Config file not found at '$file'"
}
