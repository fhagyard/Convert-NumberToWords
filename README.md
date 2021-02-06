# Convert-NumberToWords

SYNOPSIS
--------
Converts numbers to the equivalent english language words

DESCRIPTION
-----------
The Convert-NumberToWords function can be used to convert numbers to the equivalent words used in
english language. Specify a number upto +/- 999,999,999,999,999. The IncludeNumber switch parameter
can be used to return a custom object containing both the supplied number and converted word(s).

SYNTAX
------
    Convert-NumberToWords [-Number] <long> [-IncludeNumber]

PARAMETERS
----------
-Number (Int64)

The number to convert. This parameter is required.

-IncludeNumber (Switch)

Returns an object containing both the supplied number and converted word(s).

INPUTS
------
System.Int64

You can pipe a 64-bit integer to this function to convert it.

OUTPUTS
-------
System.String, System.Management.Automation.PSCustomObject

By default this function returns a string of the converted number. You can specify 
IncludeNumber to return a PSCustomObject instead.

EXAMPLES
--------

- Convert 1534 to words:

      Convert-NumberToWords -Number 1534

      One Thousand Five Hundred And Thirty-Four

- Convert several numbers to words via pipeline:

      0,-13,501,-4096,286790 | Convert-NumberToWords

      Zero
      Minus Thirteen
      Five Hundred And One
      Minus Four Thousand And Ninety-Six
      Two Hundred And Eighty-Six Thousand Seven Hundred And Ninety

- Convert number and return an PSCustomObject with both the number and converted words

      Convert-NumberToWords -Number 212 -IncludeNumber

      Number Word                  
      ------ ----                  
         212 Two Hundred And Twelve

NOTES
-----
Release Date: 2021-02-06

Author: Francis Hagyard
