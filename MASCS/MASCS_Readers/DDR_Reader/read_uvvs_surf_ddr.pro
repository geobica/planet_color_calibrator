function read_uvvs_surf_ddr, theUnit
; v1.0      7/24/13     mrl     New. Initialize a data structure and read a MASCS UVVS surface
;                               DDR record from a file. Return the populated structure.

init_mascs_ddr_templates

theData = {uvvs_surf_ddr}

; Can't read from a file directly into a structure element.
; So, introduce some temp variables and use them...
temp2 = uint(0)
temp4 = ulong(0)
templ = long(0)
tempf = float(0)
tempd = double(0)
temp5d = dblarr(5)
temp25d = dblarr(25)


readu, theUnit, temp2
theData.BIN_NUMBER = temp2

readu, theUnit, temp5d
theData.TARGET_LATITUDE_SET = temp5d

readu, theUnit, temp5d
theData.TARGET_LONGITUDE_SET = temp5d 

readu, theUnit, tempd
theData.SLIT_ROTATION_ANGLE = tempd  

readu, theUnit, tempd
theData.ALONG_TRACK_FOOTPRINT_SIZE = tempd       
                        
readu, theUnit, tempd
theData.ACROSS_TRACK_FOOTPRINT_SIZE = tempd

readu, theUnit, tempd
theData.INCIDENCE_ANGLE = tempd

readu, theUnit, tempd
theData.EMISSION_ANGLE = tempd

readu, theUnit, tempd
theData.PHASE_ANGLE = tempd

readu, theUnit, tempd
theData.SOLAR_DISTANCE = tempd

readu, theUnit, tempd
theData.MIDBIN_TIME = tempd

tempbytes = bytarr(17)
readu, theUnit, tempbytes
theData.BIN_UTC_TIME = tempbytes

readu, theUnit, tempf
theData.BIN_WAVELENGTH = tempf    

readu, theUnit, tempf
theData.IOF_BIN_DATA = tempf 

readu, theUnit, tempf
theData.PHOTOM_IOF_BIN_DATA = tempf

readu, theUnit, tempf
theData.IOF_BIN_NOISE_DATA = tempf

readu, theUnit, tempf
theData.PHOTOM_IOF_BIN_NOISE_DATA = tempf

readu, theUnit, tempf
theData.FULLY_CORRECTED_COUNT_RATE = tempf

readu, theUnit, tempf
theData.STEP_RADIANCE_W = tempf

readu, theUnit, tempf
theData.PMT_TEMPERATURE = tempf

tempbytes = bytarr(21)
readu, theUnit, tempbytes
theData.DATA_QUALITY_INDEX = tempbytes

tempbytes = bytarr(30)
readu, theUnit, tempbytes
theData.OBSERVATION_TYPE = tempbytes   

readu, theUnit, tempd
theData.SPARE = tempd

readu, theUnit, tempd
theData.SPARE_2 = tempd

readu, theUnit, tempd
theData.SPARE_3 = tempd
          
result = swap_endian(thedata, /swap_if_little_endian)

return, result

end                                
        