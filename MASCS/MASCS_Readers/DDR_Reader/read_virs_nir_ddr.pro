function read_virs_nir_ddr, theUnit
; v1.0		5/19/12		mrl		Initialize a data structure and read a MASCS VIRS
;								NIR DDR record from a file. Return the populated structure.
;								

init_mascs_ddr_templates

theData = {virs_nir_ddr}

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
temp256 = intarr(256)
tempf256 = fltarr(256)


readu, theUnit, temp4
thedata.SC_TIME= temp4

readu, theUnit, temp2
thedata.PACKET_SUBSECONDS = temp2

readu, theUnit, temp2
thedata.INT_TIME = temp2

readu, theUnit, temp2
thedata.INT_COUNT = temp2

readu, theUnit, temp2
thedata.DARK_FREQ = temp2

readu, theUnit, tempf
thedata.TEMP_2 = tempf

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

readu, theUnit, tempb17
thedata.SPECTRUM_UTC_TIME = tempb17

readu, theUnit, tempf256
thedata.IOF_SPECTRUM_DATA = tempf256

readu, theUnit, tempf256
thedata.PHOTOM_IOF_SPECTRUM_DATA = tempf256

readu, theUnit, tempf256
thedata.IOF_NOISE_SPECTRUM_DATA = tempf256

readu, theUnit, tempf256
thedata.PHOTOM_IOF_NOISE_SPECTRUM_DATA = tempf256

readu, theUnit, tempf
thedata.SOFTWARE_VERSION = tempf

readu, theUnit, tempf256
thedata.CHANNEL_WAVELENGTHS = tempf256

readu, theUnit, tempb19
thedata.DATA_QUALITY_INDEX = tempb19

readu, theUnit, temp5d
thedata.TARGET_LATITUDE_SET = temp5d

readu, theUnit, temp5d
thedata.TARGET_LONGITUDE_SET = temp5d

readu, theUnit, tempd
thedata.ALONG_TRACK_FOOTPRINT_SIZE = tempd

readu, theUnit, tempd
thedata.ACROSS_TRACK_FOOTPRINT_SIZE = tempd

readu, theUnit, tempd
thedata.INCIDENCE_ANGLE = tempd

readu, theUnit, tempd
thedata.EMISSION_ANGLE = tempd

readu, theUnit, tempd
thedata.PHASE_ANGLE = tempd

readu, theUnit, tempd
thedata.SOLAR_DISTANCE = tempd

readu, theUnit, tempf
thedata.SPARE_1 = tempf

readu, theUnit, temp4
thedata.SPARE_2 = temp4

readu, theUnit, temp4
thedata.SPARE_3 = temp4

readu, theUnit, temp4
thedata.SPARE_4 = temp4

readu, theUnit, temp4
thedata.SPARE_5 = temp4

result = swap_endian(thedata, /swap_if_little_endian)

return, result


end