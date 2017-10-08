
# Source this file to be able to call its functions
# E.g.:
# $ . .\utils.ps1

# Reads comma seperated values from a given XML value in a given file and returns them
# 
# Note: This doesn't consider if the line is commented out. The first matching line gets used. Beware of that when modifying the file.
function Read-CsvFromXmlVal
{
    Param ($pathToXml, $xmlValueName)

    # Example line: <RuntimeIdentifiers>win-x64;linux-x64</RuntimeIdentifiers>
    $xmlValueLine = Get-Content $pathToXml | Select-String -Pattern "<${xmlValueName}>.*</${xmlValueName}>"
    $xmlValueLine = (($xmlValueLine -Replace " ", "") -Replace "<${xmlValueName}>", "") -Replace "</${xmlValueName}>", ""
    $xmlValues = $xmlValueLine -Split ";"
    return $xmlValues
}
