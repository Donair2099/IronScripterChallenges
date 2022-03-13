Function Get-WindowsServerDownTime {
    [CmdletBinding()]
        Param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$ComputerName = "$env:computername",
        [Parameter()]
        [PSCredential]$Credentials
        # [PSCredential]$Credentials = [System.Management.Automation.PSCredential]::Empty
    )

    BEGIN
    {}

    PROCESS
    {
        if ([string]::IsNullOrEmpty($Credentials)){
            $CimData = (Get-CimInstance -ClassName win32_operatingsystem)
            $LogData = (Get-EventLog -LogName System |? {$_.EventID -eq 1074})[0]
        }
        else{
            $CimData = (Get-CimInstance -ClassName win32_operatingsystem -ComputerName $ComputerName -Credentials $Credentials)
            $LogData = (Get-EventLog -ComputerName $ComputerName -Credentials $Credentials -LogName System |? {$_.EventID -eq 1074})[0]
        }

        $MessageSplit = ($LogData.Message).Split(' ')
        $UserIndex = $MessageSplit.IndexOf('user') + 1
        $UpRange = $CimData.LocalDateTime - $CimData.LastBootUpTime
        $DownRange = ($CimData.LastBootUpTime) - ($LogData.TimeGenerated)

        $Data = [PSCustomObject]@{
            ComputerName = $ComputerName
            LastShutDown = $LogData.TimeGenerated
            LastShutDownBy = $MessageSplit[$UserIndex]
            LastStartUp = $CimData.LastBootUpTime
            DownTime = "{0:dd}d:{0:hh}h:{0:mm}m:{0:ss}s" -f $DownRange
            UpTime = "{0:dd}d:{0:hh}h:{0:mm}m:{0:ss}s" -f $UpRange
        }
        $Data
    }
    
    END
    {}
}
