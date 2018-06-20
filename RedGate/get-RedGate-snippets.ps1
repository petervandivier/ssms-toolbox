#Requires -RunAsAdministrator

cd ~/git/toolbox/Redgate
$rgSnipDir = (gc .\RedGate.config.json | ConvertFrom-Json)."Snippet Folder"

(gci -LiteralPath $rgSnipDir) | % {
    $snip = gc -LiteralPath "$($_.FullName)"
    $xml = [xml]$snip
    Write-Host $_
    if($xml.CodeSnippets.CodeSnippet.Header.Description.EndsWith("SECRET")){
        Copy-Item -LiteralPath $_.FullName -Destination .\Snippets.Secret\$_
    }else{
        Copy-Item -LiteralPath $_.FullName -Destination .\Snippets\$_
    }
}