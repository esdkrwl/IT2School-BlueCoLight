$prog &HFF , &HC4 , &HD9 , &HFF                             ' generated. Take care that the chip supports all fuse bytes.
$regfile = "m8adef.dat"
$crystal = 2000000
$baud = 9600
$hwstack = 32
$swstack = 24
$framesize = 24


Taster1 Alias Pind.6
Taster2 Alias Pind.7
Taster3 Alias Pinb.0
Taster4 Alias Pinb.1

Rot Alias Compare1a
Gruen Alias Compare1b
Blau Alias Compare2
Motor Alias Portc.5


Config Portb.1 = Output
Config Portb.2 = Output
Config PORTB.3 = Output
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


'PWM Einstellen
Config Timer1 = Pwm , Pwm = 8 , Compare A Pwm = Clear Up , Compare B Pwm = Clear Up , Prescale = 1
Config Timer2 = Pwm , Pwm = ON , Compare Pwm = Clear Up , Prescale = 1


Rot = 255
Waitms 200
Rot = 0
Gruen = 255
Waitms 200
Gruen = 0
Blau = 255
Waitms 200
Blau = 0



Readisprogrammed = Isprogrammed

If Readisprogrammed = 255 Then
      Dim Y As Word
      Dim ___rseed As Word
      Blau = 100
      Rot = 100
      Gruen = 100
      Motor = 1
      Config Adc = Single , Prescaler = Auto

        ___rseed = Getadc(0)
       If ___rseed < 20 Then ___rseed = Getadc(1)
       If ___rseed = 0 Then ___rseed = Getadc(2)
      Wait 3

      Do                                                    ''Puffer leeren
        Waitms 2
        If Ischarwaiting() = 1 Then
           A = Inkey()
           Text = Text + Chr(a)
        End If
        Waitms 2
      Loop Until Ischarwaiting() = 0


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
      Waitms 750
      Print ""
      Text = ""
      Do
        Waitms 2
        If Ischarwaiting() = 1 Then
           A = Inkey()
           Text = Text + Chr(a)
        End If
        Waitms 2
      Loop Until Ischarwaiting() = 0
      If Text <> "OKsetPIN" Then Error = 1
        Waitms 500
         Print "AT+NAMEBlueCoLight-" ; Zeichenkette;
         Waitms 750
         Text = ""
         Do
           Waitms 2
           If Ischarwaiting() = 1 Then
              A = Inkey()
              Text = Text + Chr(a)
           End If
           Waitms 2
         Loop Until Ischarwaiting() = 0
         If Text <> "OKsetname" Then Error = 1

      For N = 1 To 10
        If Error = 0 Then
           Toggle Gruen
           Waitms 250
        Else
           Toggle Rot
           Waitms 250
        End If
      Next N
      If Error = 0 Then
         Readisprogrammed = 1
         Isprogrammed = Readisprogrammed
      End If
End If

If Taster1 = 0 And Taster4 = 0 Then
      Blau = 100
      Rot = 100
      Gruen = 100
      Motor = 1
      Wait 1
      Do

       X = Rnd(26)
      Loop Until Taster1 = 1
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
      Wait 3                                                'Zeit für das Bluetoothmodul zum starten

      Do
        Waitms 2
        If Ischarwaiting() = 1 Then
           A = Inkey()
           Text = Text + Chr(a)
        End If
        Waitms 2
      Loop Until Ischarwaiting() = 0

      Print "AT+PIN1234";
      Waitms 750
      Text = ""
      Do
        Waitms 2
        If Ischarwaiting() = 1 Then
           A = Inkey()
           Text = Text + Chr(a)
        End If
        Waitms 2
      Loop Until Ischarwaiting() = 0
      If Text <> "OKsetPIN" Then Error = 1

      Print "AT+NAMEBlueCoLight-" ; Zeichenkette;
      Waitms 750
      Text = ""
      Do
        Waitms 1
        If Ischarwaiting() = 1 Then
           A = Inkey()
           Text = Text + Chr(a)
        End If
        Waitms 1
      Loop Until Ischarwaiting() = 0
      If Text <> "OKsetname" Then Error = 1
      For N = 1 To 10
        If Error = 0 Then
           Toggle Gruen
           Waitms 250
        Else
           Toggle Rot
           Waitms 250
        End If
      Next N
End If



Dim Motor_wert As Byte

Motor_wert = 0

Do
  If Taster1 = 0 Then
     If Rot < 124 Then Rot = 255 Else Rot = 0
     Waitms 200
  End If
  If Taster2 = 0 Then
     If Gruen < 124 Then Gruen = 255 Else Gruen = 0
     Waitms 200
  End If
  If Taster3 = 0 Then
     If Blau < 124 Then Blau = 255 Else Blau = 0
     Waitms 200
  End If
  If Taster4 = 0 Then
     If Motor_wert < 124 Then Motor_wert = 128 Else Motor_wert = 0
     Waitms 200
  End If
  If X < 255 Then Incr X Else X = 0
  If X < Motor_wert Then Motor = 1 Else Motor = 0
Loop


Serial0charmatch:
     Text = ""
     While Ischarwaiting() = 1
           A = Inkey()
           If A <> "#" Then Text = Text + Chr(a)
     Wend
     If Left(text , 1) = "R" Then
         Delchars Text , "R"
         Delchars Text , "#"
         Rot = Val(text)

     End If
     If Left(text , 1) = "G" Then
         Delchars Text , "G"
         Delchars Text , "#"
         Gruen = Val(text)

     End If
     If Left(text , 1) = "B" Then
         Delchars Text , "B"
         Delchars Text , "#"
         Blau = Val(text)

     End If
     If Left(text , 1) = "M" Then
         Delchars Text , "M"
         Delchars Text , "#"
         Motor_wert = Val(text)

     End If
Return



End