function read_virs_vis_cdr_6, theUnit
; v1.0		10/10/09	mrl		Initialize a data structure and read a MASCS UVVS
;								CDR record from a file. Return the populated structure.
;								This one reads the VIRS VIS "SCI' files.
; v2.0		5/9/12		mrl		Updated to remove 4 fields of pointing information that
;								no one is using. (Saves 96 bytes per record.)
;								Re-named with a '5' on the end to make it easier to 
;								identify it as a MASCS CDR Reader v5 file.
; v6		7/14/13		mrl		Re-named with a 6 on the end to identify it as a
;								MASCS CDR Reader v6 file

init_mascs_cdr_templates_6

theData = {vis_cdr}

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
tempb19 = bytarr(19)
temp512 = intarr(512)
temp512f = fltarr(512)

readu, theUnit, temp2
thedata.SEQ_COUNTER = temp2

readu, theUnit, temp4
thedata.SC_TIME= temp4

readu, theUnit, temp2
thedata.PACKET_SUBSECONDS = temp2

readu, theUnit, temp2
thedata.INT_TIME = temp2

readu, theUnit, temp2
thedata.INT_COUNT = temp2

readu, theUnit, temp2
thedata.PERIOD = temp2

readu, theUnit, temp2
thedata.DARK_FREQ = temp2

readu, theUnit, tempf
thedata.TEMP_1 = tempf

readu, theUnit, tempf
thedata.TEMP_2 = tempf

readu, theUnit, temp2
thedata.NIR_GAIN = temp2

readu, theUnit, temp2
thedata.OTHER_CHANNEL_ON = temp2

readu, theUnit, temp2
thedata.NIR_LAMP_ON = temp2

readu, theUnit, temp2
thedata.VIS_LAMP_ON = temp2

readu, theUnit, temp2
thedata.BINNING = temp2

readu, theUnit, temp2
thedata.START_PIXEL = temp2

readu, theUnit, temp2
thedata.END_PIXEL = temp2

readu, theUnit, temp2
thedata.SPECTRUM_NUMBER = temp2

readu, theUnit, temp4
thedata.SPECTRUM_MET = temp4

readu, theUnit, temp2
thedata.SPECTRUM_SUBSECONDS = temp2

readu, theUnit, temp512
thedata.RAW_SPECTRUM_DATA = temp512

readu, theUnit, tempb17
thedata.SPECTRUM_UTC_TIME = tempb17

readu, theUnit, temp512f
thedata.CORRECTED_COUNTS_SPECTRUM_DATA = temp512f

readu, theUnit, temp512f
thedata.CALIBRATED_RADIANCE_SPECTRUM_DATA = temp512f

readu, theUnit, temp512f
thedata.NOISE_SPECTRUM_DATA = temp512f

readu, theUnit, tempf
thedata.CALIBRATION_SOFTWARE_VERSION = tempf

readu, theUnit, temp512f
thedata.CHANNEL_WAVELENGTHS = temp512f

readu, theUnit, templ
thedata.HK_DATA_FLAG = templ

readu, theUnit, tempb19
thedata.DATA_QUALITY_INDEX = tempb19

readu, theUnit, tempf
thedata.VIRS_GRATING_TEMP = tempf

; v3.0 deleted pointing columns that no one was using.

readu, theUnit, temp5d
thedata.TARGET_LATITUDE_SET = temp5d

readu, theUnit, temp5d
thedata.TARGET_LONGITUDE_SET = temp5d

readu, theUnit, tempd
thedata.ALONG_TRACK_FOOTPRINT_SIZE = tempd

readu, theUnit, tempd
thedata.ACROSS_TRACK_FOOTPRINT_SIZE = tempd

readu, theUnit, tempd
thedata.FOOTPRINT_AZIMUTH = tempd

readu, theUnit, tempd
thedata.INCIDENCE_ANGLE = tempd

readu, theUnit, tempd
thedata.EMISSION_ANGLE = tempd

readu, theUnit, tempd
thedata.PHASE_ANGLE = tempd

readu, theUnit, tempd
thedata.SLANT_RANGE_TO_CENTER = tempd

readu, theUnit, tempd
thedata.SUBSPACECRAFT_LATITUDE = tempd

readu, theUnit, tempd
thedata.SUBSPACECRAFT_LONGITUDE = tempd

readu, theUnit, tempd
thedata.NADIR_ALTITUDE = tempd

readu, theUnit, tempd
thedata.SUBSOLAR_LATITUDE = tempd

readu, theUnit, tempd
thedata.SUBSOLAR_LONGITUDE = tempd

readu, theUnit, tempd
thedata.SOLAR_DISTANCE = tempd

readu, theUnit, tempd
thedata.PLANET_TRUE_ANOMALY = tempd

readu, theUnit, tempf
thedata.SPARE_1 = tempf

readu, theUnit, tempd
thedata.RIGHT_ASCENSION = tempd

readu, theUnit, tempd
thedata.DECLINATION = tempd

readu, theUnit, templ
thedata.SPARE_2 = templ

readu, theUnit, templ
thedata.SPARE_3 = templ

readu, theUnit, templ
thedata.SPARE_4 = templ

readu, theUnit, templ
thedata.SPARE_5 = templ

readu, theUnit, templ
thedata.SPARE_6 = templ

readu, theUnit, templ
thedata.SPARE_7 = templ

readu, theUnit, templ
thedata.SPARE_8 = templ

readu, theUnit, templ
thedata.SPARE_9 = templ

readu, theUnit, templ
thedata.SPARE_10 = templ

readu, theUnit, templ
thedata.SPARE_11 = templ

result = swap_endian(thedata, /swap_if_little_endian)

return, result


end