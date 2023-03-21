; =========================================================================================================
;
; called when a print is paused. Moves extruder to front position.
; If z position is below 80mm it will lift the z axis to enable a clean filament
; change.
;
; =========================================================================================================
;
if heat.heaters[1].current > heat.coldExtrudeTemperature               ; check extrude temperature
    M83                                                                ; relative extruder moves
    G1 E-2 F3600                                                       ; retract 1mm of filament
;
set global.zLiftDistance = 5                                           ; set distance to lift
M98 P"0:/sys/00-Functions/zLift"                                       ; call macro to lift z
;
if {move.axes[2].machinePosition < 80}                                 ; if z position is below 80mm
    G1 X125 Y-7 Z80 F6000                                              ; go to the parking position
else
    G1 X125 Y-7 F6000                                                  ; go to the parking position
;
; =========================================================================================================
;