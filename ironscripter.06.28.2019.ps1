

function Check-String() {
    [CmdletBinding()]
	Param (
        [Parameter()]
        [String]$Stringy,
        [Parameter()]
        [int]$FirstValue,
        [Parameter()]
        [int]$SecondValue
        
    )

    $CleanString = $Stringy.Replace(" ","")
    $CleanString = $CleanString.Replace("`n","")
    $Message = ''

        $Length = ($CleanString.Length)
        $LetterIndexArray = @()
        $First = ($FirstValue - 1)
        $Second = $SecondValue
        
        while (($First -lt $Length) -or ($Second -lt $Length)){
            $LetterIndexArray += $First
            $LetterIndexArray += $Second
            $First = ($FirstValue + $Second)
            $Second = ($First + $SecondValue)
        }

        foreach($LetterIndex in $LetterIndexArray){
            $Message += $CleanString[$LetterIndex]
        }

    "$Message - $FirstValue, $SecondValue" | Write-Output
}


$crypto1 = @"
g - 2 5 R e t o p c 7 -
h v 1 Q n e l b e d E p
"@


$crypto2 = @"
P k T r 2 s z 2 * c F -
r a z 7 G u D 4 w 6 U #
g c t K 3 E @ B t 1 a Y
Q P i c % 7 0 5 Z v A e
W 6 j e P R f p m I ) H
y ^ L o o w C n b J d O
S i 9 M b e r # ) i e U
* f 2 Z 6 M S h 7 V u D
5 a ( h s v 8 e l 1 o W
Z O 7 l p K y J l D z $
- j I @ t T 2 3 R a i k
q = F & w B 6 c % H l y
"@


$Outer = @(1..12)
$Inner = @(1..12)

foreach($OuterIndex in $Outer){
    foreach($InnerIndex in $Inner){
        Check-String -Stringy $crypto1 -FirstValue $OuterIndex -SecondValue $InnerIndex
    }
}


foreach($OuterIndex in $Outer){
    foreach($InnerIndex in $Inner){
        Check-String -Stringy $crypto2 -FirstValue $OuterIndex -SecondValue $InnerIndex
    }
}
