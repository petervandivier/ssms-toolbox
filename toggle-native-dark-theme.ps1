#Requires -RunAsAdministrator

# https://www.sqlshack.com/setting-up-the-dark-theme-in-sql-server-management-studio/

[cmdletbinding()]Param(
    [switch]$disable
)

$SsmsInventory = Get-ChildItem -Recurse -ErrorAction SilentlyContinue -Path C:\ -Filter ssms.exe
$disable_line = "[`$RootKey`$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]"
$enable_line  = "// [`$RootKey`$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]"

foreach($install in $SsmsInventory){
    Write-Verbose "Updating install at $($install.DirectoryName)" -Verbose
    
    $file = Join-Path $install.DirectoryName "ssms.pkgundef"
    
    # take a backup first
    Copy-Item $file "$($install.DirectoryName)/ssms_$(Get-Date -Format FileDateTimeUniversal).pkgundef" 
    
    # default is "enable"
    if($disable){
        (Get-Content $file -Raw) -replace [Regex]::Escape($enable_line), $disable_line | Out-File -LiteralPath $file
    } else {
        (Get-Content $file -Raw) -replace [Regex]::Escape($disable_line), $enable_line | Out-File $file
    }
}
