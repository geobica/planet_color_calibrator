function read_uvvs_ddr_summary, theUnit
; v1.0		5/19/12		mrl		New. Initialize a data structure and read a MASCS UVVS
;								DDR record from a file. Return the populated structure.
; v1.1		1/14/13		mrl		Adding a new column "MET_PARTITION" following the
;								MET rollover event.


init_mascs_ddr_templates

theData = {uvvs_ddrsum}

; Can't read from a file directly into a structure element.
; So, introduce some temp variables and use them...
temp2 = uint(0)
temp4 = ulong(0)
templ = long(0)
tempf = float(0)
tempd = double(0)
temp3d = dblarr(3)
temp25d = dblarr(25)

tempbytes = bytarr(30)
readu, theUnit, tempbytes
theData.OBSERVATION_TYPE = tempbytes

tempbytes = bytarr(27)
readu, theUnit, tempbytes
theData.CDR_NAME = tempbytes

;readu,theUnit, temp2
;theData.OBS_SEQUENCE_INDEX = temp2

readu, theUnit, temp3d
theData.PLANET_SUN_VECTOR_TG = temp3d

readu, theUnit, temp3d
theData.PLANET_SC_VECTOR_TG = temp3d

readu, theUnit, temp3d
theData.BORESIGHT_UNIT_VECTOR_CENTER_TG = temp3d

readu,theUnit, tempd
theData.TARGET_LATITUDE = tempd

readu,theUnit, tempd
theData.TARGET_LONGITUDE = tempd

readu, theUnit, temp3d
theData.TARGET_ALTITUDE = temp3d

readu, theUnit, tempf
theData.TARGET_LOCAL_TIME = tempf

readu,theUnit, tempd
theData.SUBSPACECRAFT_LATITUDE = tempd

readu,theUnit, tempd
theData.SUBSPACECRAFT_LONGITUDE = tempd

readu,theUnit, tempd
theData.SPACECRAFT_ALTITUDE = tempd

readu, theUnit, tempf
theData.SPACECRAFT_LOCAL_TIME = tempf

readu,theUnit, tempd
theData.SUBSOLAR_LATITUDE = tempd

readu,theUnit, tempd
theData.SUBSOLAR_LONGITUDE = tempd

readu,theUnit, tempd
theData.PLANET_TRUE_ANOMALY = tempd

readu, theUnit, templ
theData.ORBIT_NUMBER = templ

readu,theUnit, temp4			; new in v1.1
theData.MET_PARTITION = temp4	; new in v1.1

readu,theUnit, tempd
theData.MID_SPECTRUM_TIME = tempd

tempbytes = bytarr(17)
readu, theUnit, tempbytes
theData.UTC_TIME = tempbytes

readu, theUnit, temp25d
theData.WAVELENGTH = temp25d

readu, theUnit, temp25d
theData.RADIANCE_KR = temp25d

readu, theUnit, temp25d
theData.RADIANCE_SNR = temp25d

readu,theUnit, tempd
theData.TOTAL_RADIANCE_KR = tempd

readu,theUnit, tempd
theData.TOTAL_RADIANCE_SNR = tempd

readu,theUnit, temp2
theData.SLIT_POS = temp2

readu,theUnit, tempd
theData.SPARE_1 = tempd

readu,theUnit, tempd
theData.SPARE_2 = tempd

readu,theUnit, tempd
theData.SPARE_3 = tempd

readu,theUnit, tempd
theData.SPARE_4 = tempd


result = swap_endian(thedata, /swap_if_little_endian)


return, result


end
