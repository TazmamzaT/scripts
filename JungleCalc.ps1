function Get-ML
{
    param (
        [double] $gallon,
        [double] $oz
    )
    return ($gallon * 3785) + ($oz * 29.574)
}

function New-Component
{
    param (
        [string] $Name,
        [double] $Gallon,
        [double] $Ounce,
        [double] $Milliliter,
        [double] $Proof
    )

    $Milliliter += Get-ML -gallon $Gallon -oz $Ounce

    if ($null -ne $Proof)
    {
        return [BoozeComponent]::new($Name, $Milliliter, $Proof)
    }
    else
    {
        return [Component]::new($Name, $Milliliter)
    }
}

$AbvFormat = '{0:#0.0% ABV}'
$GallonFormat = '{0:#,##0.0 gallon(s)}'

$Juice = [Juice]::new()
$Juice.Components += New-Component -Name 'Cranberry Juice' -Ounce 16
$Juice.Components += New-Component -Name 'Lemonade' -Gallon .25
$Juice.Components += New-Component -Name 'OJ' -Gallon .25
$Juice.Components += New-Component -Name 'Fruit Punch' -Gallon .25

$Juice.Components += New-Component -Name 'Vodka' -Milliliter 750 -Proof 80
$Juice.Components += New-Component -Name 'Rum' -Milliliter 750 -Proof 80

Write-Output $Juice.Components | Format-Table
Write-Output "$($AbvFormat -f $Juice.GetAbv()); $($GallonFormat -f $Juice.GetTotalLiquidGallons())`n"

# Classes
class Juice
{
    [Component[]] $Components

    [double] GetTotalLiquidML()
    {
        $totalliquid = 0
        foreach ($liquid in $this.Components)
        {
            $totalliquid += $liquid.VolumeML
        }
        return $totalliquid
    }

    [double] GetTotalLiquidGallons()
    {
        return $this.GetTotalLiquidML() / 3785
    }

    [double] GetAbv()
    {
        $totalbooze = 0

        foreach ($liquid in $this.Components)
        {
            if ($liquid.GetType() -eq [BoozeComponent])
            {
                $totalbooze += $liquid.GetAlcoholML()
            }
        }
        return $totalbooze / $this.GetTotalLiquidML()
    }
}

class Component
{
    Component(
        [string] $name,
        [double] $volume
    )
    {
        $this.Name = $name
        $this.VolumeML = $volume
    }

    [string] $Name
    [double] $VolumeML
}

class BoozeComponent : Component
{
    BoozeComponent(
        [string] $name,
        [double] $volume,
        [double] $proof
    ) : base($name, $volume)
    {
        $this.Proof = $proof
    }

    [double] $Proof

    [double] GetAlcoholML()
    {
        return (($this.Proof / 200) * $this.VolumeML)
    }
}