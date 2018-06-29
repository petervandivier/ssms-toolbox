#Requires -RunAsAdministrator

cd ~/git/toolbox/Redgate
$rgSnipDir = (gc .\RedGate.config.json | ConvertFrom-Json)."Snippet Folder"

if(-not (Test-Path ".\Snippets.Secret\")){New-Item -ItemType Directory -Path ".\Snippets.Secret\"}

(gci -LiteralPath $rgSnipDir) | % {
    $snip = gc -LiteralPath "$($_.FullName)"
    $xml = [xml]$snip
    Write-Verbose $_
    if($xml.CodeSnippets.CodeSnippet.Header.Description.EndsWith("SECRET")){
        Copy-Item -LiteralPath $_.FullName -Destination .\Snippets.Secret\$_
    }else{
        Copy-Item -LiteralPath $_.FullName -Destination .\Snippets\$_
    }
}

# https://stackoverflow.com/a/21118566/4709762
Add-Type -AssemblyName Microsoft.VisualBasic
(".\Snippets.Secret\",".\Snippets\") | % {
    gci $_ -Filter *.sqlpromptsnippet | % {
        $exists = Test-Path "$rgSnipDir\$($_.Name)"
        #"$($_.Name) | $exists"
        if(-not $exists){
            Write-Warning "Deleting $($_.Name)"
            #Remove-Item $($_.FullName)
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($_.FullName,'OnlyErrorDialogs','SendToRecycleBin')
        }
    }
}
