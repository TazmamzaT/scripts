function Get-ML {
    param (
        [double]$gallon,
        [double]$oz
    )
    return ($gallon * 3785) + ($oz * 29.574)
}

$BoozePercent = .4
$BoozeAmmount = 750 * 2
$BoozeVolume = $BoozeAmmount * $BoozePercent

$Liquid = 0

$Liquid += Get-ML -oz 16 # Cranberry Juice
$Liquid += Get-ML -gallon .25 # Lemade
$Liquid += Get-ML -gallon .25 # OJ
$Liquid += Get-ML -gallon .25 # Fruit Punch
$Liquid += $BoozeAmmount

Write-Output "Liquid component is a lotal of $Liquid ML ($($Liquid/3785) gallons) and $($BoozeVolume/$Liquid)"