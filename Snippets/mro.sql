/*
Retrieve 20 most recently created objects
*/

SELECT TOP 20 [name], [type], crdate
FROM sysobjects
ORDER BY crdate DESC
