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

# https://stackoverflow.com/a/21118566/4709762
Add-Type -AssemblyName Microsoft.VisualBasic
(".\Snippets.Secret\",".\Snippets\") | % {
    gci $_ -Filter *.sqlpromptsnippet | % {
        $exists = Test-Path "$rgSnipDir\$($_.Name)"
        #"$($_.Name) | $exists"
        if(-not $exists){
            "Deleting $($_.Name)"
            #Remove-ItemSafely $($_.FullName)
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($_.FullName,'OnlyErrorDialogs','SendToRecycleBin')
        }
    }
}
