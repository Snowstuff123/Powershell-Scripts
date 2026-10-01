function Set-UserExpiration {
    <#
        .Synopsis
        Sets the AD Account expiration date of provided user.

        .Description
        Sets the AD Account expiration date of provided user. Will cap at 90 days.

        .Parameter Identity
        The samaccount name of the AD Account to be set to expire. ValueFromPipeline=$true.

        .Parameter Date
        Manually provided expiration date. Not mandatory; will default to 90 days if not provided and will cap to 90 days if set greater.

        .Example
        # Set JHeisler to expire in 90 days.
        Set-UserExpiration -Identity JHeisler

        .Example
        # Set JHeisler to expire on 10/23/23.
        Set-UserExpiration -Identity JHeisler -Date 10/23/23

    #>
    [CmdletBinding(SupportsShouldProcess)]

    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string[]]$Identity,

        [datetime]$Date,

        [string] $Server
    )
    begin{
        $Today = Get-Date
        $MaxDate = $Today.AddDays(90)
        if (
            $PSBoundParameters.ContainsKey('Date') -and $Date -lt $Today
        )
        {
            throw "Expiration date cannot be in the past."
        }
        $DefaultExpirationDate = $MaxDate
    }
    process {
        foreach ($User in $Identity) {
            try {
                $ADUser = Get-ADUser -Identity:$User -Server:$Server -ErrorAction:Stop

                $ExpirationDate = if ($PSBoundParameters.ContainsKey('Date')) {
                    if ($Date -gt $MaxDate.date) {
                        $MaxDate
                    }
                    else {
                        $Date
                    }
                }
                else {
                    $DefaultExpirationDate
                }
                
                if ($PSCmdlet.ShouldProcess(
                    $ADUser.SamAccountName,
                    "Set expiration date to $ExpirationDate"
                )) {
                    Set-ADAccountExpiration -Identity:$ADUser -DateTime:$ExpirationDate -Server:$Server
                }
            [PSCustomObject]@{
                SamAccountName = $ADUser.SamAccountName
                Name           = $ADUser.Name
                ExpirationDate = $ExpirationDate
                Success        = $true
            }
            }
            catch {
                Write-Error "Failed to set expiration for '$User'. $($_.Exception.Message)"
                [PSCustomObject]@{
                    SamAccountName = $User
                    Name           = $null
                    ExpirationDate = $null
                    Success        = $false
                }
            }

        }
    }
}
