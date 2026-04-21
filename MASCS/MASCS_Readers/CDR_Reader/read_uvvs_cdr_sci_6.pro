function read_uvvs_cdr_sci_6, theUnit
; v1.0		10/10/09	mrl		Initialize a data structure and read a MASCS UVVS
;								CDR record from a file. Return the populated structure.
;								This one reads the UVVS "SCI' files.
; v1.1		4/19/10		mrl		Updated to replace SPARE_1 (double) with SC_TIME (ulong)


;V2         8/2011      AWM     Renamed to read_uvvs_cdr_sci_4 to be consistent with 
;								read_mascs_cdr4

;						Updated to replace SPARE_2 (double) with PMT_Temperature (float)

;						Moved the location of PMT_Temperature in the Structure allocation.

;						Changed name of Radiance Uncertainty to STEP_RADIANCE_SIGNAL_TO_NOISE
; v3.0		5/9/12		mrl		Updated to remove fields of J2000 pointing information that
;								no one is using. 
; v5							Re-named with a '5' on the end to make it easier to 
;								identify it as a MASCS CDR Reader v5 file.
; v6		7/14/13		mrl		Used the last spare field for ORBIT_NUMBER


init_mascs_cdr_templates_6

theData = {cdr_sci}

; Can't read from a file directly into a structure element.
; So, let's introduce some temp variables and use them...
temp2 = uint(0)
temp4 = ulong(0)
templ = long(0)
tempf = float(0)
tempd = double(0)
temp3d = dblarr(3)
temp5d = dblarr(5)
tempb17 = bytarr(17)
tempb21 = bytarr(21)
tempb30 = bytarr(30)

readu, theUnit, temp2
theData.step_number = temp2

; v3.0 J2000 items deleted here

readu, theUnit, temp3d
theData.PLANET_SUN_VECTOR_TG = temp3d

readu, theUnit, temp3d
theData.PLANET_SC_VECTOR_TG = temp3d

readu, theUnit, temp3d
theData.BORESIGHT_UNIT_VECTOR_CENTER_TG = temp3d

readu, theUnit, temp3d
theData.BORESIGHT_UNIT_VECTOR_C1_TG = temp3d

readu, theUnit, temp3d
theData.BORESIGHT_UNIT_VECTOR_C2_TG = temp3d

readu, theUnit, temp3d
theData.BORESIGHT_UNIT_VECTOR_C3_TG = temp3d

readu, theUnit, temp3d
theData.BORESIGHT_UNIT_VECTOR_C4_TG = temp3d

readu, theUnit, temp3d
theData.SURFACE_TANGENT_VECTOR_CENTER = temp3d

readu, theUnit, temp3d
theData.SURFACE_TANGENT_VECTOR_C1 = temp3d

readu, theUnit, temp3d
theData.SURFACE_TANGENT_VECTOR_C2 = temp3d

readu, theUnit, temp3d
theData.SURFACE_TANGENT_VECTOR_C3 = temp3d

readu, theUnit, temp3d
theData.SURFACE_TANGENT_VECTOR_C4 = temp3d

readu, theUnit, temp5d
theData.RA_SET = temp5d

readu, theUnit, temp5d
theData.DEC_SET = temp5d

readu, theUnit, temp5d
theData.TARGET_LATITUDE_SET = temp5d

readu, theUnit, temp5d
theData.TARGET_LONGITUDE_SET = temp5d

readu, theUnit, temp5d
theData.TARGET_ALTITUDE_SET = temp5d				

readu, theUnit, tempd
theData.SLIT_ROTATION_ANGLE = tempd

readu, theUnit, tempd
theData.ALONG_TRACK_FOOTPRINT_SIZE = tempd

readu, theUnit, tempd
theData.ACROSS_TRACK_FOOTPRINT_SIZE = tempd

readu, theUnit, tempd
theData.FOOTPRINT_AZIMUTH = tempd

readu, theUnit, tempd
theData.INCIDENCE_ANGLE = tempd

readu, theUnit, tempd
theData.EMISSION_ANGLE = tempd

readu, theUnit, tempd
theData.PHASE_ANGLE = tempd

readu, theUnit, tempd
theData.SLANT_RANGE_TO_CENTER = tempd

readu, theUnit, tempd
theData.SUBSPACECRAFT_LATITUDE = tempd

readu, theUnit, tempd
theData.SUBSPACECRAFT_LONGITUDE = tempd

readu, theUnit, tempd
theData.NADIR_ALTITUDE = tempd

readu, theUnit, tempd
theData.SUBSOLAR_LATITUDE = tempd

readu, theUnit, tempd
theData.SUBSOLAR_LONGITUDE = tempd

readu, theUnit, tempd
theData.SOLAR_DISTANCE = tempd

readu, theUnit, tempd
theData.PLANET_TRUE_ANOMALY = tempd

readu, theUnit, tempd
theData.MIDSTEP_TIME = tempd

readu, theUnit, tempb17
theData.STEP_UTC_TIME = tempb17

readu, theUnit, tempf
theData.GRATING_OFFSET = tempf

readu, theUnit, templ
theData.STEP_POSITION = templ

readu, theUnit, tempf
theData.STEP_WAVELENGTH = tempf

readu, theUnit, temp2
theData.RAW_STEP_DATA = temp2

readu, theUnit, tempf
theData.COUNT_RATE = tempf

readu, theUnit, tempf
theData.DEAD_CORRECTED_COUNT_RATE = tempf

readu, theUnit, tempf
theData.DARK_RATE = tempf

readu, theUnit, tempf
theData.SCATTERED_LIGHT_RATE = tempf

readu, theUnit, tempf
theData.FULLY_CORRECTED_COUNT_RATE = tempf

readu, theUnit, tempf
theData.FULLY_CORRECTED_COUNT_RATE_UNCERTAINTY = tempf

readu, theUnit, tempf
theData.STEP_RADIANCE_KR = tempf

readu, theUnit, tempf
theData.STEP_RADIANCE_W = tempf

readu, theUnit, tempf
theData.STEP_RADIANCE_SIGNAL_TO_NOISE = tempf

readu, theUnit, tempf
theData.PMT_TEMPERATURE = tempf

readu, theUnit, tempb21
theData.DATA_QUALITY_INDEX = tempb21	

readu, theUnit, temp4					; 
theData.SC_TIME = temp4

; The next field is now a 30 byte "observation type"
readu, theUnit, tempb30
theData.observation_type = tempb30

readu, theUnit, tempd
theData.ORBIT_NUMBER = tempd


result = swap_endian(thedata, /swap_if_little_endian)


return, result


end
