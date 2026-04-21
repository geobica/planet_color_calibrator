function read_uvvs_surf_hdr, theUnit
; v1.0      7/24/13     mrl     New. Initialize a data structure and read a MASCS UVVS surface
;                               DDR record from a file. Return the populated structure.

init_mascs_ddr_templates

theData = {uvvs_surf_header}

; Can't read from a file directly into a structure element.
; So, introduce some temp variables and use them...
temp2 = uint(0)
temp4 = ulong(0)
templ = long(0)
tempf = float(0)
tempd = double(0)
temp5d = dblarr(5)
temp25d = dblarr(25)


readu, theUnit, temp4
theData.SC_TIME = temp4

readu, theUnit, temp2
theData.PACKET_SUBSECONDS = temp2

readu, theUnit, temp2
theData.START_POS = temp2

readu, theUnit, temp2
theData.STEP_COUNT = temp2

readu, theUnit, temp2
theData.INT_TIME = temp2

readu, theUnit, temp2
theData.STEP_TIME = temp2

readu, theUnit, temp2
theData.PHASE_OFFSET = temp2

readu, theUnit, temp2
theData.SCAN_CYCLES = temp2

readu, theUnit, temp2
theData.ZIGZAG = temp2

readu, theUnit, temp2
theData.COMPRESSION = temp2

readu, theUnit, temp2
theData.SLIT_MASK_POS = temp2

readu, theUnit, temp2
theData.GD_SETTLE_CTR = temp2

readu, theUnit, temp2
theData.NUM_SCAN_VALUES = temp2

readu, theUnit, temp2
theData.STEP_SIZE = temp2

readu, theUnit, temp2
theData.COADD = temp2

readu, theUnit, tempf
theData.CALIBRATION_SOFTWARE_VERSION = tempf

result = swap_endian(thedata, /swap_if_little_endian)

return, result

end                                
        