$prog &HFF , &HC4 , &HD9 , &HFF                             ' generated. Take care that the chip supports all fuse bytes.
$regfile = "m8adef.dat"
$crystal = 8000000
$baud = 9450
$hwstack = 32
$swstack = 24
$framesize = 24

Gruen Alias Portd.4
Rot Alias Portb.7
Blau Alias Portd.3
Motor Alias Portc.5
Taster1 Alias Pind.6
Taster2 Alias Pind.7
Taster3 Alias Pinb.0
Taster4 Alias Pinb.1

Config Rot = Output
Config Gruen = Output
Config Blau = Output
Config Motor = Output
Config Taster1 = Input
Config Taster2 = Input
Config Taster3 = Input
Config Taster4 = Input

Portd.6 = 1
Portd.7 = 1
Portb.0 = 1
Portb.1 = 1


'wird aufgerufen wenn # empfangen wird
Config Serialin = Buffered , Size = 10 , Bytematch = 35
Config Serialout = Buffered , Size = 100
'Wird von Serialin/out benötigt
Enable Interrupts

'Initialisierung
Dim X As Byte
Dim N As Byte
Dim Error As Bit
Dim Text As String * 22
Dim Zeichenkette As String * 4
Dim A As Byte
Dim Readisprogrammed As Byte
Dim Isprogrammed As Eram Byte
Dim Y As Word
Dim ___rseed As Word

Declare Sub Rename()

Error = 0

Print "Nelli ist mein Fisch";

Rot = 1
Waitms 200
Rot = 0
Gruen = 1
Waitms 200
Gruen = 0
Blau = 1
Waitms 200
Blau = 0
Waitms 200

Do              ''Puffer leeren
Loop Until Ischarwaiting() = 0


Readisprogrammed = Isprogrammed


If Taster1 = 0 AND Taster4 = 0 Then
   Call Rename
End If


If Readisprogrammed = 255 Then
   Call Rename

   If Error = 0 Then
      Readisprogrammed = 1
      Isprogrammed = Readisprogrammed
   End If

End If


'Programmbeginn
Config Timer0 = Timer , Prescale = 1
On Timer0 Regeln
Enable Timer0
Timer0 = 100

Dim Rot_wert As Byte
Dim Gruen_wert As Byte
Dim Blau_wert As Byte
Dim Motor_wert As Byte

Rot_wert = 0
Gruen_wert = 0
Blau_wert = 0
Motor_wert = 0

Do
   If Taster1 = 0 Then
      If Rot_wert < 100 Then Rot_wert = 255 Else Rot_wert = 0
      Waitms 200
   End If
   If Taster2 = 0 Then
      If Gruen_wert < 100 Then Gruen_wert = 255 Else Gruen_wert = 0
      Waitms 200
   End If
   If Taster3 = 0 Then
      If Blau_wert < 100 Then Blau_wert = 255 Else Blau_wert = 0
      Waitms 200
   End If
   If Taster4 = 0 Then
      If Motor_wert < 100 Then Motor_wert = 255 Else Motor_wert = 0
      Waitms 200
   End If
Loop

Regeln:
   If X < 255 Then Incr X Else X = 0
   If X < Rot_wert Then Rot = 1 Else Rot = 0
   If X < Gruen_wert Then Gruen = 1 Else Gruen = 0
   If X < Blau_wert Then Blau = 1 Else Blau = 0
   If X < Motor_wert Then Motor = 1 Else Motor = 0
   Timer0 = 100
Return

Serial0charmatch:
   Stop Timer0
   Text = ""
   While Ischarwaiting() = 1
      A = Inkey()
      If A <> "#" Then Text = Text + Chr(a)
   Wend
   If Left(text , 1) = "R" Then
      Delchars Text , "R"
      Delchars Text , "#"
      Rot_wert = Val(text)
   End If
   If Left(text , 1) = "G" Then
      Delchars Text , "G"
      Delchars Text , "#"
      Gruen_wert = Val(text)
   End If
   If Left(text , 1) = "B" Then
      Delchars Text , "B"
      Delchars Text , "#"
      Blau_wert = Val(text)
   End If
   If Left(text , 1) = "M" Then
      Delchars Text , "M"
      Delchars Text , "#"
      Motor_wert = Val(text)
   End If
   Start Timer0
Return


Sub Rename

   Blau = 1
   Rot = 1
   Gruen = 1
   Motor = 1
   Config Adc = Single , Prescaler = Auto
   Wait 1

   ___rseed = Getadc(0)
   If ___rseed < 20 Then ___rseed = Getadc(1)
   If ___rseed = 0 Then ___rseed = Getadc(2)


   Blau = 0
   Rot = 0
   Gruen = 0
   Motor = 0

   Zeichenkette = ""
   For N = 1 To 3
      X = Rnd(26)
      X = X + 65
      Zeichenkette = Zeichenkette + Chr(x)               '65-90
   Next N

   Print "AT+PIN1234";
   Waitms 250

   Text = ""

   Do
   Loop Until Ischarwaiting() = 1

   Do
        ''If Ischarwaiting() = 1 Then
      A = Inkey()
      Text = Text + Chr(a)
        ''End If
      Waitms 10
   Loop Until Ischarwaiting() = 0

   If Text <> "OKsetPIN" Then Error = 1

   Print "AT+NAMEBlueCoLight-" ; Zeichenkette;
   Waitms 250


      ''Warte auf neue Daten
   Do
   Loop Until Ischarwaiting() = 1


   Text = ""
   Do
      A = Inkey()
      Text = Text + Chr(a)
      Waitms 10
   Loop Until Ischarwaiting() = 0

   If Text <> "OKsetname" Then Error = 1

   For N = 1 To 5
      If Error = 0 Then
         Toggle Gruen
         Waitms 250
      Else
         Toggle Rot
         Waitms 250
      End If
   Next N

End Sub



End