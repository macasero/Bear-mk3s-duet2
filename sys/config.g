; =========================================================================================================
;
; Configuration file for Duet2WiFi-Ethernet (firmware version 3.4)
;
; for 1.8° motors on xye
;
; for Kapa Bear Duet2 Wifi - E3d Thermistor - SuperPINDA
;
; Based on CariboDuetConfiguration Release : "2.0.0"
; =========================================================================================================
;
; global variables
;
global IdleCounter = 0                                                 ; counts idle time
global ExtruderTempActive_Old = 0                                      ; stores extruder temperature for idle check
global BedTempActive_Old = 0                                           ; stores bed temperature for idle check
global OldStateStatus = 0                                              ; stores teh satus processing = 1
;
; general settings
;
M111 S0 					                                           ; debugging off
G21 					                                               ; work in millimetres



; =========================================================================================================
; Network settings
; =========================================================================================================
;
M550 P"Kapa-MK3S-Duet"                                 ; set printer name
;
M552 S1                                                ; enable network
M586 P0 S1                                             ; enable HTTP
M586 P1 S1                                             ; enable FTP
M586 P2 S0                                             ; disable Telnet
M575 P1 S1 B57600                                      ; enable support for PanelDue
;
; =========================================================================================================
; Drives
; =========================================================================================================
;
M569 P0 S1                                 					; X drive @0- inversed
M569 P1 S0                                					; Y drive @1- 
M569 P2 S1                              					; Z left drive @2- inversed
M569 P4 S1                               					; Z right drive  @4- inversed
M569 P3 S0                                 					; E drive @3

;
; Motor Configuration
;
M584 X0 Y1 Z2:4 E3                     								; set drive mapping
;M671 X-37:287 Y0:0 S10                                     			; define dual driven z-axis 
M671 X-36.5:293.5 Y0:0 S1.00                               			; define dual driven z-axis 
;
; set Microsteps and steps / mm
;
M350 X16 Y16 Z16 E16 I1                                ; configure microstepping with interpolation
M92 X100.00 Y100.00 Z400.00 E140.00                    ; set steps per mm
;
; set motor currents
;
M906 X1600 Y1600 Z650 E800 I40                         ; set motor currents (mA) and motor idle factor in per cent
M84 S60                                                ; Set idle timeout
;
; set speeds
;
M201 X500.00 Y500.00 Z100.00 E500.00                                   ; set accelerations (mm/s^2)
M203 X12000.00 Y12000.00 Z1000.00 E3600.00                             ; set maximum speeds (mm/min)
M204 P500.0 T500.0                                                     ; set print and travel accelerations (mm(s^2)
M566 X480.00 Y480.00 Z48.00 E300.00                                    ; set maximum instantaneous speed changes (mm/min)
;
;
; Speed tests more aressive
;M201 X1500.00 Y1500.00 Z100.00 E500.00                   ; set accelerations (mm/s^2)
;M203 X9000.00 Y9000.00 Z1000.00 E3600.00               ; set maximum speeds (mm/min)
;M204 P1200.0 T5000.0                                     ; set print and travel accelerations (mm(s^2)
;M566 E400						;300	  ; Set maximum instantaneous speed changes (JERKS) (mm/min) ONLY EXTRUDER
;;M566 X480.00 Y480.00 Z48.00                     ; set maximum instantaneous speed changes (mm/min)
;M205 X8 Y8 Z8							; Set maximum instantaneous speed changes (JERKS) (mm/seg) XYZ . USE this for Marlin COMPATIBILITY
;
M564 H0                                                ; allow unhomed movement
;
; =========================================================================================================
; Axis Limits
; =========================================================================================================
;
M208 X-0.1 Y-4.5 Z-2 S1                                   ; set axis minima
M208 X252.6 Y211.5 Z216.900 S0                            ; set axis maxima
;
; =========================================================================================================
; Endstops
; =========================================================================================================
;
M574 X1 S3                                             ; configure sensorless endstop for low end on X
M574 Y1 S3                                             ; configure sensorless endstop for low end on Y
M574 Z1 S2                                             ; configure Z-probe endstop for low end on Z
M574 Z2 S3                                             ; configure sensorless endstop for high end on Z
;
; =========================================================================================================
;
; SuperPINDA 
;
M558 P5 C"zstop" H2 F600 T8000 A3 S0.03              ; set z probe to SuperPINDA H1.5
G31 K0 P1000 X23 Y5 Z2.05
;M557 X23:235 Y5:186 S30.25:30                               ; define mesh grid
M557 X23:225 Y3.5:210 P6; P4                              ; define mesh grid (P4 for nylock mod mesh)
;
; =========================================================================================================
;
; Stallguard Sensitivy
;
M915 X S3 F0 H200 R0                                   ; set X axis Sensitivity
M915 Y S3 F0 H200 R0                                   ; set Y axis Sensitivity
M915 Z S0 F0 H200 R0                                   ; set Z axis Sensitivity
;
; =========================================================================================================
; Heater & Fans
; =========================================================================================================
;
; heated bed
; =========================================================================================================
;
M308 S0 P"bedtemp" Y"thermistor" T100000 B4138 R4700 A"Bed"  ; configure sensor 0 as thermistor on pin bedtemp
M950 H0 C"bedheat" Q50 T0                                    ; create bed heater output on bedheat and map it to sensor 0
M140 H0                                                      ; map heated bed to heater 0
M143 H0 P0 S120 A2                                      ; disable temporarily H0 if temp exceeds 120C
M143 H0 P0 S130 A0                                      ; heater fault H0 if temp exceeds 130C
M307 H0 B0 S1.00                                     ; disable bang-bang mode for the bed heater and set PWM limit
M570 H0 P60 T15                                      ; heater fault for 60seg of 15ºC excursion
M307 H0 R0.283 K0.295:0.000 D9.35 E1.35 S1.00 B00      ; PID backup
;
; extruder
; =========================================================================================================
;
; Hotend (V6 with E3d Thermistor) 
;
M308 S1 P"e0temp" Y"thermistor" T100000 B4725 C7.060000e-8 A"Nozzle E1"  ; E3d configure sensor 0 as thermistor on pin e0temp
M950 H1 C"e0heat" T1                                        ; create nozzle heater output on e0heat and map it to sensor 2
M143 H1 S285 A2                                         ; disable temporarily H1 if temp exceeds 285C
M143 H1 S295 A0                                         ; heater fault H1 if temp exceeds 295C
M307 H1 B0 S1.00                                        ; disable bang-bang mode for heater  and set PWM limit
M570 H1 P10 T30                                      ; heater fault for 10 seg of 30ºC excursion
M307 H1 R2.995 K0.283:0.203 D7.86 E1.35 S1.00 B0 V24.0      ; PID backup
;
; =========================================================================================================
; Fans
; =========================================================================================================
; Fan0 = Part Coooling
M950 F0 C"fan0" Q160								; Define Fan0 for Part Cooling (2x Delta BFB0412HHA-A), 500Hz PWM
M106 P0 S0 H-1									; Set Fan0 to default off, manual control

; Fan2 = Hotend
M950 F1 C"fan1" Q500								; Define Fan1 for Hotend cooling, 500Hz PWM
M106 P1 S1 H1 T50								; Set Fan1 to Thermostatic control, max RPM at 45C
;
; =========================================================================================================
;
; Drivers and MCU temp sensors and electronic fan
;----MCU & DRIVERS sensors------
M308 S3 Y"mcu-temp"	A"MCU"								; create sensor for MCU temp M308 S3 Y"mcutemp"
M308 S4 Y"drivers"	A"Drivers"							; create sensor for drivers temp M308 S4 Y"drivers"
M912 P0 S-0.8                                           ; Calibrate MCU temp
;M950 F2 C"fan2" Q500									; create fan 2 on pin out4 - alternative with tacho M950 F2 C"!fan2+^pb6"
;M106 P2 H3:4 L.3 B.5 X1 T40:65 					; Set fan 2 PWR fan. Turns on when MCU temperature, hits 45C and full when the MCU temperature reaches 65C or any TMC2660 alarms

;
; =========================================================================================================
;
; ========================================================================================================
; Tools
; =========================================================================================================
;
M200 D1.75
M563 P0 D0 H1 F0 S"T0"                                       ; define tool 0
G10 P0 X0 Y0 Z0                                        ; set tool 0 axis offsets
G10 P0 S-274 R-274                                     ; turn on tool 0, set active and standby temperature to 0K
M302 S180 R180                                         ; allow extrusion starting from 180°C and retractions already from 180°C
;
; =========================================================================================================
; other settings
; =========================================================================================================
;
M18 XY                                                 ; release / unlock X, Y
M501                                                   ; use config-override (for Thermistor Parameters and other settings)
G90                                                    ; send absolute coordinates...
M83                                                    ; ... but relative extruder moves
T0                                                     ; Select first tool (Extruder 0)
M911 S23 R24 P"M913 X0 Y0 G91 M83 G1 Z3 E-5 F1000"      ; set voltage thresholds and actions to run on power loss
;M579 X1.005 Y1.005                                      ; Scale Cartesian axe
;
; =========================================================================================================
;  filament handling
; =========================================================================================================
; firmware retraction
;
M207 S0.85 R0 F2400 Z0								; Firmware retraction
;
; execute macros that has the status of the filament sensor
;
M98 P"0:/sys/00-Functions/FilamentsensorStatus"
M572 D0 S0.04                       ; set pressure advance in case not loaded on M703 Filament
M404 N1.75									; Define filament diameter for print monitor
;
; =========================================================================================================
;
; =========================================================================================================
;
; Offsets - place off-sets for x and y here. z-offsets are handled in the print sheet macros
;
G31 P1000 X23 Y5
;
; =========================================================================================================
;
; =========================================================================================================
;
; global varibales
;
global IdleCounter = 0
global ExtruderTempActive_Old = 0
global BedTempActive_Old = 0
;
; =========================================================================================================
;
