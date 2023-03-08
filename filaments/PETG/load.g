; =========================================================================================================
;
;  Prepare to load PETG at 230°C
;
; =========================================================================================================
;
M291 P"Prepare for filament loading. Please wait while the nozzle is being heated up. Press OK to continue or CANCEL to abort." R"Loading PETG at 230°C" S3
;
M291 P"Please wait while the nozzle is being heated up" R"Heating: 230°C" S1 T5; display message
;
T0                                                                     ; select tool 0
G91                                                                    ; relative positioning
G1 Z20 F6000 H2                                                        ; lift Z relative to current position
M568 P0 S230 A2                                                        ; set current tool temperature to filament 230°C
M116                                                                   ; wait for the temperatures to be reached
;
M98 P"0:/macros/01-Filament_Handling/00-Load_Filament"                 ; execute macro to load and purge filament
;
; =========================================================================================================
;