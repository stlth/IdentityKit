<#
.Synopsis
   Convert a GUID to an ImmutableID
.DESCRIPTION
   Converts a Globally Unique Identifier (GUID) into an ImmutableID value.
   This is useful to identify a value to hard link against.
.PARAMETER Value
   A Globally Unique Identifier (GUID).
.EXAMPLE
   PS> $aUserGuid = (Get-ADUser -Identity 'SamAccountName' -Domain 'DOMAIN' -Properties ObjectGUID).ObjectGUID
   PS> ConvertTo-ImmutableID -Value $aUserGuid
.NOTES
   2017-02-17: Initial version.
.LINK
   https://blogs.technet.microsoft.com/praveenkumar/2014/04/11/how-to-do-hard-match-in-dirsync/
   https://blogs.technet.microsoft.com/praveenkumar/2014/08/10/how-to-do-hard-match-part-2/
   https://gallery.technet.microsoft.com/office/Covert-DirSyncMS-Online-5f3563b1
#>
function ConvertTo-ImmutableID
{
    [CmdletBinding(ConfirmImpact='Low')]
    [Alias()]
    [OutputType([PSObject])]
    Param
    (
        # Globally Unique Identifier (GUID) to convert into an ImmutableID
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript(
        {
            try
            {
                [void][System.Guid]::Parse($PSItem)
                $true
            }
            catch
            {
                $false
            }
        })]
        [Alias('GUID')]
        [string[]]
        $Value
    )

    Begin
    {
    }
    Process
    {
        foreach ($v in $Value)
        {
            $guid = [System.Guid]$v
            $bytearray = $guid.ToByteArray()
            $immutableID = [System.Convert]::ToBase64String($bytearray)
            $outputObject = [PSCustomObject]@{
                'GUID'= $v
                'ImmutableID'= $immutableID
            }
            Write-Output -InputObject $outputObject
        }
    }
    End
    {
    }
}
<#
.Synopsis
   Convert an ImmutableID to a GUID
.DESCRIPTION
   Converts an ImmutableID into an a Globally Unique Identifier (GUID) value.
   This is useful to identify a value to hard link against.
.PARAMETER Value
   A Base64 Encoded string.
.EXAMPLE
   PS> ConvertFrom-ImmutableID -Value 'sEBleMrg1US6gM/Q7AeX1w==' 
.NOTES
   2017-02-17: Initial version.
.LINK
   https://blogs.technet.microsoft.com/praveenkumar/2014/04/11/how-to-do-hard-match-in-dirsync/
   https://blogs.technet.microsoft.com/praveenkumar/2014/08/10/how-to-do-hard-match-part-2/
   https://gallery.technet.microsoft.com/office/Covert-DirSyncMS-Online-5f3563b1
#>
function ConvertFrom-ImmutableID
{
    [CmdletBinding(ConfirmImpact='Low')]
    [Alias()]
    [OutputType([PSObject])]
    Param
    (
        # ImmutableID to convert into a Globally Unique Identifier (GUID) 
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true, 
                   Position=0)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript(
        {
            try
            {
                [void][System.Convert]::FromBase64String($PSItem)
                $true
            }
            catch
            {
                $false
            }

        })]
        [Alias('ImmutableID')]
        [string[]]
        $Value
    )

    Begin
    {
    }
    Process
    {
        foreach ($v in $Value)
        {
            $decoded = [System.Convert]::FromBase64String($v)
            $guid = [System.Guid]$decoded
            $outputObject = [PSCustomObject]@{
                'ImmutableID'= $v
                'GUID'= $guid
            }
            Write-Output -InputObject $outputObject
        }
    }
    End
    {
    }
}