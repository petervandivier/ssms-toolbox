# SSMS Manual Config

The following options are client config I do not currently know how to set from either registry or `.vssettings`. Set them from the GUI for a new SSMS client config.

## Retain CR/LF

Tools > Options | Query Results > SQL Server > Results to Grid | :heavy_check_mark: "Retain CR/LF on copy of save"

## Include column header

Tools > Options | Query Results > SQL Server > Results to Grid | :heavy_check_mark: "Include column headers when copying or saving the results"

## Lower case auto-complete

Tools > Options | Text Editor > Transact-SQL > Intellisense | Casing for built-in function names: > Lower case

## Line Numbers

Tools > Options | Text Editor > Transact-SQL > General | :heavy_check_mark: "Line Numbers

## Empty environment on launch

Tools > Options | Environment > Startup | At startup: > Open empty environment

HT https://stackoverflow.com/a/16581591/4709762 

Connection dialogue is blocking & will prevent RedGate SQL Prompt session reconnection in some circumstances AFAICT
