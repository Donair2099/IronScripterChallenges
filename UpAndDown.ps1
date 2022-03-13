Function Get-WindowsServerDownTime {
    [CmdletBinding()]
        Param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$ComputerName,
        [Parameter()]
        [PSCredential]$Credentials
    )

    BEGIN
    {}

    PROCESS
    {
        $CimArgs = @{}
        $CimArgs.Add('ClassName','win32_operatingsystem')

        $LogArgs = @{}
        $LogArgs.Add('LogName','System')

        if ($ComputerName){
            $CimArgs.Add('ComputerName',$ComputerName)
            $LogArgs.Add('ComputerName',$ComputerName)
        }
        else {
            $ComputerName = "$env:computername"
        }

        if ($Credentials){
            $CimArgs.Add('Credentials',$Credentials)
            $LogArgs.Add('Credentials',$Credentials)
        }

        $CimData = (Get-CimInstance @CimArgs)
        $LogData = (Get-EventLog @LogArgs | where {$_.EventID -eq 1074})[0]

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
