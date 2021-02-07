Function Convert-NumberToWords {
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True,Position=0)]
        [ValidateRange(-999999999999999,999999999999999)]
        [int64]$Number,
        [Parameter(Mandatory=$False)]
        [switch]$IncludeNumber = $False
    )
    Begin {
        # Lookup table for base values
        $BaseLookup = @{
            "0" = "Zero"
            "1" = "One"
            "2" = "Two"
            "3" = "Three"
            "4" = "Four"
            "5" = "Five"
            "6" = "Six"
            "7" = "Seven"
            "8" = "Eight"
            "9" = "Nine"
            "10" = "Ten"
            "11" = "Eleven"
            "12" = "Twelve"
            "13" = "Thirteen"
            "14" = "Fourteen"
            "15" = "Fifteen"
            "16" = "Sixteen"
            "17" = "Seventeen"
            "18" = "Eighteen"
            "19" = "Nineteen"
        }

        # Lookup table for multiples of ten
        $MultipleTenLookup = @{
            "2" = "Twenty"
            "3" = "Thirty"
            "4" = "Fourty"
            "5" = "Fifty"
            "6" = "Sixty"
            "7" = "Seventy"
            "8" = "Eighty"
            "9" = "Ninety"
        }

        # Function to determine word under a thousand
        Function Get-Word {
            Param($StrNumber)
            # Length 1 or under 20
            If (($StrNumber.Length -eq 1) -or (($StrNumber.Length -eq 2) -and ($StrNumber[0] -eq "1"))) {$ReturnWord = $BaseLookup["$StrNumber"]}
            # Length 2
            ElseIf ($StrNumber.Length -eq 2) {
                If ($StrNumber[1] -eq "0") {$ReturnWord = $MultipleTenLookup["$($StrNumber[0])"]}
                Else {$ReturnWord = "$($MultipleTenLookup["$($StrNumber[0])"])-$($BaseLookup["$($StrNumber[1])"])"}
            }
            # Length 3
            Else {
                If ($StrNumber -eq "000") {$ReturnWord = $Null}
                Else {
                    # Under 100
                    If ($StrNumber[0] -eq "0") {
                        If ($StrNumber[1] -eq "0") {$ReturnWord = $BaseLookup["$($StrNumber[2])"]}
                        ElseIf ($StrNumber[1] -eq "1") {$ReturnWord = $BaseLookup[("$($StrNumber[1])" + "$($StrNumber[2])")]}
                        ElseIf ($StrNumber[2] -eq "0") {$ReturnWord = $MultipleTenLookup["$($StrNumber[1])"]}
                        Else {$ReturnWord = "$($MultipleTenLookup["$($StrNumber[1])"])-$($BaseLookup["$($StrNumber[2])"])"}
                    }
                    # Over or equal to 100
                    Else {
                        $HundredWord = $BaseLookup["$($StrNumber[0])"] + " Hundred"
                        If (($StrNumber[1] -eq "0") -and ($StrNumber[2] -eq "0")) {$ReturnWord = $HundredWord}
                        ElseIf ($StrNumber[1] -eq "0") {$ReturnWord = "$HundredWord And $($BaseLookup["$($StrNumber[2])"])"}
                        ElseIf ($StrNumber[1] -eq "1") {$ReturnWord = "$HundredWord And $($BaseLookup[("$($StrNumber[1])" + "$($StrNumber[2])")])"}
                        ElseIf ($StrNumber[2] -eq "0") {$ReturnWord = "$HundredWord And $($MultipleTenLookup["$($StrNumber[1])"])"}
                        Else {$ReturnWord = "$HundredWord And $($MultipleTenLookup["$($StrNumber[1])"])-$($BaseLookup["$($StrNumber[2])"])"}
                    }
                }
            }
            Return $ReturnWord
        }
    }
    Process {
        # Negative number flag
        $Negative = $False

        # Format to string with thousand seperator and split by comma
        If ($Number.ToString() -match "^\-") {
            $Negative = $True
            $MainArray = $Number.ToString('N0') -replace "^\-" -split ","
        }
        Else {$MainArray = $Number.ToString('N0') -split ","}

        # Count number of thousandths
        $ArrayCount = ($MainArray | Measure-Object).Count

        # One thousand or greater
        If ($ArrayCount -gt 1) {
            
            # Reverse array so that each thousandth falls to the same index
            [array]::Reverse($MainArray)

            # Array to add words into
            $FinalWordArray = @()

            # Get words for each thousandth
            Switch ($ArrayCount) {
                {$_ -gt 4} {
                    $TrillionWord = Get-Word -StrNumber $MainArray[4]
                    $FinalWordArray += "$TrillionWord Trillion"
                }
                {$_ -gt 3} {
                    If ($MainArray[3] -ne "000") {
                        $BillionWord = Get-Word -StrNumber $MainArray[3]
                        $FinalWordArray += "$BillionWord Billion"
                    }
                }
                {$_ -gt 2} {
                    If ($MainArray[2] -ne "000") {
                        $MillionWord = Get-Word -StrNumber $MainArray[2]
                        $FinalWordArray += "$MillionWord Million"
                    }
                }
                {$_ -gt 1} {
                    If ($MainArray[1] -ne "000") {
                        $ThousandWord = Get-Word -StrNumber $MainArray[1]
                        $FinalWordArray += "$ThousandWord Thousand"
                    }
                }
                {$True} {
                    If ($MainArray[0] -ne "000") {

                        $InitialWord = Get-Word -StrNumber $MainArray[0]

                        If ($MainArray[0][0] -eq "0") {$SuffixWord = "And $InitialWord"}
                        Else {$SuffixWord = $InitialWord}

                        $FinalWordArray += "$SuffixWord"
                    }            
                }
            }

            # Join by whitespace to final word
            $FinalWord = $FinalWordArray -join " "
        }
        # Under one thousand so just lookup full value
        Else {$FinalWord = Get-Word -StrNumber $MainArray[0]}

        # Append prefix 'minus' if a negative number was supplied and its not zero
        If ($Negative -and ($Number -ne 0)) {$FinalWord = "Minus $FinalWord"}

        # Return a psobject of both number and word if switch param used
        If ($IncludeNumber) {
            $FinalObject = [pscustomobject]@{
                Number = $Number
                Word = $FinalWord
            }
            Return $FinalObject
        }
        Else {Return $FinalWord}
    }
}
