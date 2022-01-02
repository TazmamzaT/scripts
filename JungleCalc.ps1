function Get-ML
{
    param (
        [double]$gallon,
        [double]$oz
    )
    return ($gallon * 3785) + ($oz * 29.574)
}

$AbvFormat = '{0:#0.0% ABV}'
$GallonFormat = '{0:#,##0.0 gallon(s)}'

$Juice = [Juice]::new()
$Juice.Components += [Component]::new('Cranberry Juice', (Get-ML -oz 16))
$Juice.Components += [Component]::new('Lemonade', (Get-ML -gallon .25))
$Juice.Components += [Component]::new('OJ', (Get-ML -gallon .25))
$Juice.Components += [Component]::new('Fruit Punch', (Get-ML -gallon .25))

$Juice.Components += [BoozeComponent]::new('Vodka', 750, 80)
$Juice.Components += [BoozeComponent]::new('Rum', 750, 80)

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
        [string]$name,
        [double]$volume
    )
    {
        $this.Name = $name
        $this.VolumeML = $volume
    }
    [string]$Name
    [double]$VolumeML
}

class BoozeComponent : Component
{
    BoozeComponent(
        [string]$name,
        [double]$volume,
        [double]$proof
    ) : base($name, $volume)
    {
        $this.Proof = $proof
    }

    [double]$Proof

    [double]GetAlcoholML()
    {
        return (($this.Proof / 200) * $this.VolumeML)
    }
}