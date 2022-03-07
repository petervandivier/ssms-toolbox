
Push-Location $PSScriptRoot

$config = Get-Content .\RedGate.config.json | ConvertFrom-Json
$PublicSnippetFolder = Invoke-Expression "Resolve-Path `"$($config.SnippetFolder)`""
$PrivateSnippetRepo = Invoke-Expression "Resolve-Path `"$($config.HiddenSnippets.StashFolder)`""
$PrivateSnippetSlug = $config.HiddenSnippets.FilterSlug

Get-ChildItem -LiteralPath $PublicSnippetFolder -File | ForEach-Object {
    $snip = Get-Content -LiteralPath "$($_.FullName)" | ConvertFrom-Json
    Write-Verbose $_
    if($snip.description.EndsWith($PrivateSnippetSlug)){
        Copy-Item -LiteralPath "$($_.FullName)"  -Destination "$PrivateSnippetRepo/$($_.Name)"
    }else{
        Copy-Item -LiteralPath "$($_.FullName)"  -Destination "./10/Snippets/$($_.Name)"
        Set-Content ../Snippets/$($snip.prefix).sql "/*$([Environment]::NewLine)$($snip.description)$([Environment]::NewLine)*/$([Environment]::NewLine)"
        Add-Content ../Snippets/$($snip.prefix).sql $snip.body 
    }
}

# https://stackoverflow.com/a/21118566/4709762
Add-Type -AssemblyName Microsoft.VisualBasic

($PrivateSnippetRepo,"./10/Snippets/") | ForEach-Object {
    Get-ChildItem -LiteralPath "$_" -Filter *.json | ForEach-Object {
        $exists = Test-Path "$PublicSnippetFolder\$($_.Name)"
        if(-not $exists){
            Write-Warning "Deleting $($_.Name)"
            [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($_.FullName,'OnlyErrorDialogs','SendToRecycleBin')
        }
    }
}

Pop-Location
