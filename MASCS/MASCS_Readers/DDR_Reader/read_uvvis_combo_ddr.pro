function read_uvvis_combo_ddr, filename
  ; v1.0    5/19/12   mrl   Initialize a data structure and read a MASCS VIRS
  ;               VIS DDR record from a file. Return the populated structure.
  ;

  init_mascs_ddr_templates
  
  theData = {uvvis_combo_ddr}

  
  
;  uvvis_combo_ddr = { $
;    uvvis_combo_ddr                                                ,$
;    UVVS_HEADER_FILE_ID :            strarr(1)                     ,$
;    UVVS_SCIENCE_FILE_ID :           strarr(1)                     ,$
;    VIRS_VIS_FILE_ID :               strarr(1)                     ,$
;    VIRS_NIR_FILE_ID :               strarr(1)                     ,$
;    VIRS_SPECTRUM_NUMBER :           intarr(1)                     ,$
;    UVVS_DRIFT :                     dblarr(1)                     ,$
;    UVVS_SMEAR :                     dblarr(1)                     ,$
;    UVVS_TARGET_LATITUDE_C0 :        dblarr(46)                    ,$
;    UVVS_TARGET_LATITUDE_C1 :        dblarr(46)                    ,$
;    UVVS_TARGET_LATITUDE_C2 :        dblarr(46)                    ,$
;    UVVS_TARGET_LATITUDE_C3 :        dblarr(46)                    ,$
;    UVVS_TARGET_LATITUDE_C4 :        dblarr(46)                    ,$
;    UVVS_TARGET_LONGITUDE_C0 :       dblarr(46)                    ,$
;    UVVS_TARGET_LONGITUDE_C1 :       dblarr(46)                    ,$
;    UVVS_TARGET_LONGITUDE_C2 :       dblarr(46)                    ,$
;    UVVS_TARGET_LONGITUDE_C3 :       dblarr(46)                    ,$
;    UVVS_TARGET_LONGITUDE_C4 :       dblarr(46)                    ,$
;    VIRS_TARGET_LATITUDE_SET :       dblarr(5)                     ,$
;    VIRS_TARGET_LONGITUDE_SET :      dblarr(5)                     ,$
;    VIRS_UVVS_CENTER_DISTANCE :      dblarr(1)                     ,$
;    VIRS_UVVS_OFFSET_PERCENTAGE :    dblarr(1)                     ,$
;    UVVS_CENTER_PHOT_ANGLES :        dblarr(3)                     ,$
;    VIRS_CENTER_PHOT_ANGLES :        dblarr(3)                     ,$
;    VIRS_UVVS_MATCH :                fltarr(1)                     ,$
;    DQI :                            strarr(7)                     ,$
;    FULLSPEC_WAVELENGTHS :           fltarr(540)                   ,$
;    FULLSPEC_PHOTOM_IOF_DATA :       fltarr(540)                   ,$
;    FULLSPEC_PHOTOM_IOF_NOISE_DATA : fltarr(540)                   ,$
;    SPARE_1 :                        fltarr(1)                     ,$
;    SPARE_2 :                        fltarr(1)                     ,$
;    SPARE_3 :                        fltarr(1)                     ,$
;    SPARE_4 :                        fltarr(1)                     }

;theData = {uvvis_combo_ddr}


combosize=10485


  
  justname = strupcase(file_basename(filename))
  info = file_info(filename)
 openr, theUNIT, filename, /get_LUN
  num_data = info.size / combosize
  dummy = {uvvis_combo_ddr}

result = dummy

  ; Can't read from a file directly into a structure element.
  ; So, let's introduce some temp variables and use them...
  temp1 = strarr(1)
  temp2 = dblarr(1)
  temp3 = dblarr(46)
  temp4 = dblarr(5)
  temp5 = dblarr(3)
  temp6 = fltarr(1)
  temp7 = strarr(7)
  temp8 = fltarr(540)
  temp9 = intarr(1)
  
  
  temp1='XXX_XXX_XX_XXXXX_XXXXXX_XXX.DAT'
  readu, theUnit, temp1
  thedata.UVVS_HEADER_FILE_ID= temp1

  temp1='XXX_XXX_XX_XXXXX_XXXXXX_XXX.DAT'
  readu, theUnit, temp1
  thedata.UVVS_SCIENCE_FILE_ID= temp1

  temp1='XXXXXX_XXX_XXXXX_XXXXXX.DAT'
  readu, theUnit, temp1
  thedata.VIRS_VIS_FILE_ID= temp1

  temp1='XXXXXX_XXX_XXXXX_XXXXXX.DAT'
  readu, theUnit, temp1
  thedata.VIRS_NIR_FILE_ID= temp1
  
  readu, theUnit, temp9
  thedata.VIRS_SPECTRUM_NUMBER= temp9

  readu, theUnit, temp2
  thedata.UVVS_DRIFT= temp2

  readu, theUnit, temp2
  thedata.UVVS_SMEAR= temp2

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LATITUDE_C0= temp3
  
  readu, theUnit, temp3
  thedata.UVVS_TARGET_LATITUDE_C1= temp3

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LATITUDE_C2= temp3

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LATITUDE_C3= temp3

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LATITUDE_C4= temp3

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LONGITUDE_C0= temp3

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LONGITUDE_C1= temp3

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LONGITUDE_C2= temp3

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LONGITUDE_C3= temp3

  readu, theUnit, temp3
  thedata.UVVS_TARGET_LONGITUDE_C4= temp3

  readu, theUnit, temp4
  thedata.VIRS_TARGET_LATITUDE_SET= temp4

  readu, theUnit, temp4
  thedata.VIRS_TARGET_LONGITUDE_SET= temp4

  readu, theUnit, temp2
  thedata.VIRS_UVVS_CENTER_DISTANCE= temp2
  
  readu, theUnit, temp2
  thedata.VIRS_UVVS_OFFSET_PERCENTAGE= temp2

  readu, theUnit, temp5
  thedata.UVVS_CENTER_PHOT_ANGLES= temp5

  readu, theUnit, temp5
  thedata.VIRS_CENTER_PHOT_ANGLES= temp5

  readu, theUnit, temp6
  thedata.VIRS_UVVS_MATCH= temp6

;I don't know why this skip is needed. There is apparently one floating point number
; stuck into the DDR that throws everything off. If I skip it, everything reads correctly.

  skip=1.
  readu, theUnit, skip


  temp7=['0', '0', '0', '0', '0', '0','0']
  readu, theUnit, temp7
  thedata.DQI= temp7
  
  readu, theUnit, temp8
  thedata.FULLSPEC_WAVELENGTHS= temp8

  readu, theUnit, temp8
  thedata.FULLSPEC_PHOTOM_IOF_DATA= temp8

  readu, theUnit, temp8
  thedata.FULLSPEC_PHOTOM_IOF_NOISE_DATA= temp8

  readu, theUnit, temp6
  thedata.SPARE_1= temp6

  readu, theUnit, temp6
  thedata.SPARE_2= temp6

  readu, theUnit, temp6
  thedata.SPARE_3= temp6

  readu, theUnit, temp6
  thedata.SPARE_4= temp6

  result = swap_endian(thedata, /swap_if_little_endian)

;print,result
;stop

  return, result


end