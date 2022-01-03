[MonthlySub[]]$MonthlySubs = @()
$csv = Import-Csv -Path .\MonthlySub.csv
foreach($line in $csv)
{
    $MonthlySubs += $line
}


$sum = 0

foreach($sub in $MonthlySubs)
{
    $sum += $sub.PricePerMonth
}

$run = [MonthlySubLog]::new((Get-Date), $sum)

Export-Csv -InputObject $run -Path .\MonthlySubLog.csv -Append

class MonthlySub
{
    [string]$ServiceName
    [double]$PricePerMonth
}

class MonthlySubLog
{
    [datetime]$DateRun
    [double]$Total

    MonthlySubLog(
        [datetime]$daterun,
        [double]$total
    )
    {
        $this.DateRun = $daterun
        $this.Total = $total
    }
}