pro init_mascs_ddr_templates
; Run this to set up the data structures for MASCS DDR files.
; Based on the very similar file for CDR files
;
; v1.0      5/17/12     mrl     New
; v1.1      1/14/13     mrl     Adding a new column "MET_PARTITION" 
;                               following the MET rollover event.
; v2.0      7/24/13     mrl     Adding capability to read UVVS surface DDRs.


uvvs_ddr =  {                                           $  ;This template is for the original UVVS atmosphere DDRs
            uvvs_ddr,                                   $
            OBSERVATION_TYPE:bytarr(30),                $
            CDR_NAME:bytarr(27),                        $
            OBS_SEQUENCE_INDEX:uint(0),                 $
            PLANET_SUN_VECTOR_TG:DBLARR(3),             $
            PLANET_SC_VECTOR_TG:DBLARR(3),              $
            BORESIGHT_UNIT_VECTOR_CENTER_TG:DBLARR(3),  $
            TARGET_LATITUDE:double(0),                  $
            TARGET_LONGITUDE:double(0),                 $
            TARGET_ALTITUDE:dblarr(3),                  $
            TARGET_LOCAL_TIME:float(0),                 $
            SUBSPACECRAFT_LATITUDE:double(0),           $
            SUBSPACECRAFT_LONGITUDE:double(0),          $
            SPACECRAFT_ALTITUDE:double(0),              $
            SPACECRAFT_LOCAL_TIME:float(0),             $
            SUBSOLAR_LATITUDE:double(0),                $
            SUBSOLAR_LONGITUDE:double(0),               $
            PLANET_TRUE_ANOMALY:double(0),              $
            ORBIT_NUMBER:long(0),                       $
            MET_PARTITION:ulong(0),                     $    ; New in v1.1
            MID_SPECTRUM_TIME:double(0),                $
            UTC_TIME:bytarr(17),                        $
            WAVELENGTH:dblarr(25),                      $
            RADIANCE_KR:dblarr(25),                     $
            RADIANCE_SNR:dblarr(25),                    $
            TOTAL_RADIANCE_KR:double(0),                $
            TOTAL_RADIANCE_SNR:double(0),               $
            SLIT_POS:uint(0),                           $
            SPARE_1:double(0),                          $
            SPARE_2:double(0),                          $
            SPARE_3:double(0),                          $
            SPARE_4:double(0)                           $
            }
            
uvvs_ddrsum = {                                         $  ;This template is for the original UVVS summary atmosphere DDRs
            uvvs_ddrsum,                                $
            OBSERVATION_TYPE:bytarr(30),                $
            CDR_NAME:bytarr(27),                        $
        ;   OBS_SEQUENCE_INDEX:uint(0),                 $
            PLANET_SUN_VECTOR_TG:DBLARR(3),             $
            PLANET_SC_VECTOR_TG:DBLARR(3),              $
            BORESIGHT_UNIT_VECTOR_CENTER_TG:DBLARR(3),  $
            TARGET_LATITUDE:double(0),                  $
            TARGET_LONGITUDE:double(0),                 $
            TARGET_ALTITUDE:dblarr(3),                  $
            TARGET_LOCAL_TIME:float(0),                 $
            SUBSPACECRAFT_LATITUDE:double(0),           $
            SUBSPACECRAFT_LONGITUDE:double(0),          $
            SPACECRAFT_ALTITUDE:double(0),              $
            SPACECRAFT_LOCAL_TIME:float(0),             $
            SUBSOLAR_LATITUDE:double(0),                $
            SUBSOLAR_LONGITUDE:double(0),               $
            PLANET_TRUE_ANOMALY:double(0),              $
            ORBIT_NUMBER:long(0),                       $
            MET_PARTITION:ulong(0),                     $
            MID_SPECTRUM_TIME:double(0),                $
            UTC_TIME:bytarr(17),                        $
            WAVELENGTH:dblarr(25),                      $
            RADIANCE_KR:dblarr(25),                     $
            RADIANCE_SNR:dblarr(25),                    $
            TOTAL_RADIANCE_KR:double(0),                $
            TOTAL_RADIANCE_SNR:double(0),               $
            SLIT_POS:uint(0),                           $
            SPARE_1:double(0),                          $
            SPARE_2:double(0),                          $
            SPARE_3:double(0),                          $
            SPARE_4:double(0)                           $
            }
            
uvvs_surf_header = {                                    $   ; New in v2.0
            uvvs_surf_header,                           $
            SC_TIME:ULONG(0),                           $
            PACKET_SUBSECONDS:UINT(0),                  $
            START_POS:UINT(0),                          $
            STEP_COUNT:UINT(0),                         $
            INT_TIME:UINT(0),                           $
            STEP_TIME:UINT(0),                          $
            PHASE_OFFSET:UINT(0),                       $
            SCAN_CYCLES:UINT(0),                        $
            ZIGZAG:UINT(0),                             $
            COMPRESSION:UINT(0),                        $
            SLIT_MASK_POS:UINT(0),                      $
            GD_SETTLE_CTR:UINT(0),                      $
            NUM_SCAN_VALUES:UINT(0),                    $
            STEP_SIZE:UINT(0),                          $
            COADD:UINT(0),                              $
            CALIBRATION_SOFTWARE_VERSION:FLOAT(0)       $
            }
            
 uvvs_surf_ddr = {                                      $   ; New in v2.0 
            uvvs_surf_ddr,                              $
            BIN_NUMBER:uint(0),                         $
            TARGET_LATITUDE_SET:dblarr(5),              $
            TARGET_LONGITUDE_SET:dblarr(5),             $
            SLIT_ROTATION_ANGLE:double(0),              $
            ALONG_TRACK_FOOTPRINT_SIZE:double(0),       $
            ACROSS_TRACK_FOOTPRINT_SIZE:double(0),      $
            INCIDENCE_ANGLE:double(0),                  $
            EMISSION_ANGLE:double(0),                   $
            PHASE_ANGLE:double(0),                      $
            SOLAR_DISTANCE:double(0),                   $
            MIDBIN_TIME:double(0),                      $
            BIN_UTC_TIME:bytarr(17),                    $
            BIN_WAVELENGTH:float(0),                    $
            IOF_BIN_DATA:float(0),                      $
            PHOTOM_IOF_BIN_DATA:float(0),               $
            IOF_BIN_NOISE_DATA:float(0),                $
            PHOTOM_IOF_BIN_NOISE_DATA:float(0),         $
            FULLY_CORRECTED_COUNT_RATE:float(0),        $
            STEP_RADIANCE_W:float(0),                   $
            PMT_TEMPERATURE:float(0),                   $
            DATA_QUALITY_INDEX:bytarr(21),              $
            OBSERVATION_TYPE:bytarr(30),                $
            SPARE:double(0),                            $
            SPARE_2:double(0),                          $
            SPARE_3:double(0)                           $
            }
                
uvvs_surf_fuv_ddr = {                                     $
              uvvs_surf_fuv_ddr,                          $
              BIN_NUMBER:uint(0),                         $
              TARGET_LATITUDE_SET:dblarr(5),              $
              TARGET_LONGITUDE_SET:dblarr(5),             $
              SLIT_ROTATION_ANGLE:double(0),              $
              ALONG_TRACK_FOOTPRINT_SIZE:double(0),       $
              ACROSS_TRACK_FOOTPRINT_SIZE:double(0),      $
              INCIDENCE_ANGLE:double(0),                  $
              EMISSION_ANGLE:double(0),                   $
              PHASE_ANGLE:double(0),                      $
              SOLAR_DISTANCE:double(0),                   $
              MIDBIN_TIME:double(0),                      $
              BIN_UTC_TIME:bytarr(17),                    $
              BIN_WAVELENGTH:float(0),                    $
              IOF_BIN_DATA:float(0),                      $
              PHOTOM_IOF_BIN_DATA:float(0),               $
              IOF_BIN_NOISE_DATA:float(0),                $
              PHOTOM_IOF_BIN_NOISE_DATA:float(0),         $
              FULLY_CORRECTED_COUNT_RATE:float(0),        $
              BIN_RADIANCE_W:float(0),                    $
              BIN_SOLAR_IRRADIANCE_W:float(0),            $
              PMT_TEMPERATURE:float(0),                   $
              DATA_QUALITY_INDEX:bytarr(21),              $
              OBSERVATION_TYPE:bytarr(30),                $
              SPARE:float(0),                             $
              SPARE_2:double(0),                          $
              SPARE_3:double(0)                           $
            }

                   
virs_nir_ddr =  {                                           $
                virs_nir_ddr,                               $
                SC_TIME:long(0),                            $
                PACKET_SUBSECONDS:uint(0),                  $
                INT_TIME:UINT(0),                           $
                INT_COUNT:UINT(0),                          $
                DARK_FREQ:UINT(0),                          $
                TEMP_2:float(0),                            $
                BINNING:UINT(0),                            $
                START_PIXEL:UINT(0),                        $
                END_PIXEL:UINT(0),                          $
                SPECTRUM_NUMBER:UINT(0),                    $
                SPECTRUM_MET:ulong(0),                      $
                SPECTRUM_SUBSECONDS:UINT(0),                $
                SPECTRUM_UTC_TIME:bytarr(17),               $
                IOF_SPECTRUM_DATA:fltarr(256),              $
                PHOTOM_IOF_SPECTRUM_DATA:fltarr(256),       $
                IOF_NOISE_SPECTRUM_DATA:fltarr(256),        $
                PHOTOM_IOF_NOISE_SPECTRUM_DATA:fltarr(256), $
                SOFTWARE_VERSION:float(0),                  $
                CHANNEL_WAVELENGTHS:fltarr(256),            $
                DATA_QUALITY_INDEX:bytarr(19),              $
                TARGET_LATITUDE_SET:dblarr(5),              $
                TARGET_LONGITUDE_SET:dblarr(5),             $
                ALONG_TRACK_FOOTPRINT_SIZE:double(0),       $
                ACROSS_TRACK_FOOTPRINT_SIZE:double(0),      $
                INCIDENCE_ANGLE:double(0),                  $
                EMISSION_ANGLE:double(0),                   $
                PHASE_ANGLE:double(0),                      $
                SOLAR_DISTANCE:double(0),                   $
                SPARE_1:float(0),                           $
                SPARE_2:long(0),                            $
                SPARE_3:long(0),                            $
                SPARE_4:long(0),                            $
                SPARE_5:long(0)                             $
                }
                

virs_vis_ddr =  {                                           $
                virs_vis_ddr,                               $
                SC_TIME:long(0),                            $
                PACKET_SUBSECONDS:uint(0),                  $
                INT_TIME:UINT(0),                           $
                INT_COUNT:UINT(0),                          $
                DARK_FREQ:UINT(0),                          $
                TEMP_2:float(0),                            $
                BINNING:UINT(0),                            $
                START_PIXEL:UINT(0),                        $
                END_PIXEL:UINT(0),                          $
                SPECTRUM_NUMBER:UINT(0),                    $
                SPECTRUM_MET:ulong(0),                      $
                SPECTRUM_SUBSECONDS:UINT(0),                $
                SPECTRUM_UTC_TIME:bytarr(17),               $
                IOF_SPECTRUM_DATA:fltarr(512),              $
                PHOTOM_IOF_SPECTRUM_DATA:fltarr(512),       $
                IOF_NOISE_SPECTRUM_DATA:fltarr(512),        $               
                PHOTOM_IOF_NOISE_SPECTRUM_DATA:fltarr(512), $
                SOFTWARE_VERSION:float(0),                  $
                CHANNEL_WAVELENGTHS:fltarr(512),            $
                DATA_QUALITY_INDEX:bytarr(19),              $
                TARGET_LATITUDE_SET:dblarr(5),              $
                TARGET_LONGITUDE_SET:dblarr(5),             $
                ALONG_TRACK_FOOTPRINT_SIZE:double(0),       $
                ACROSS_TRACK_FOOTPRINT_SIZE:double(0),      $
                INCIDENCE_ANGLE:double(0),                  $
                EMISSION_ANGLE:double(0),                   $
                PHASE_ANGLE:double(0),                      $
                SOLAR_DISTANCE:double(0),                   $
                SPARE_1:float(0),                           $
                SPARE_2:long(0),                            $
                SPARE_3:long(0),                            $
                SPARE_4:long(0),                            $
                SPARE_5:long(0)                             $
                }
                

uvvis_combo_ddr = { $
                  uvvis_combo_ddr                                                ,$
                  UVVS_HEADER_FILE_ID :            strarr(1)                     ,$
                  UVVS_SCIENCE_FILE_ID :           strarr(1)                     ,$
                  VIRS_VIS_FILE_ID :               strarr(1)                     ,$
                  VIRS_NIR_FILE_ID :               strarr(1)                     ,$
                  VIRS_SPECTRUM_NUMBER :           intarr(1)                     ,$
                  UVVS_DRIFT :                     dblarr(1)                     ,$
                  UVVS_SMEAR :                     dblarr(1)                     ,$
                  UVVS_TARGET_LATITUDE_C0 :        dblarr(46)                    ,$
                  UVVS_TARGET_LATITUDE_C1 :        dblarr(46)                    ,$
                  UVVS_TARGET_LATITUDE_C2 :        dblarr(46)                    ,$
                  UVVS_TARGET_LATITUDE_C3 :        dblarr(46)                    ,$
                  UVVS_TARGET_LATITUDE_C4 :        dblarr(46)                    ,$
                  UVVS_TARGET_LONGITUDE_C0 :       dblarr(46)                    ,$
                  UVVS_TARGET_LONGITUDE_C1 :       dblarr(46)                    ,$
                  UVVS_TARGET_LONGITUDE_C2 :       dblarr(46)                    ,$
                  UVVS_TARGET_LONGITUDE_C3 :       dblarr(46)                    ,$
                  UVVS_TARGET_LONGITUDE_C4 :       dblarr(46)                    ,$
                  VIRS_TARGET_LATITUDE_SET :       dblarr(5)                     ,$
                  VIRS_TARGET_LONGITUDE_SET :      dblarr(5)                     ,$
                  VIRS_UVVS_CENTER_DISTANCE :      dblarr(1)                     ,$
                  VIRS_UVVS_OFFSET_PERCENTAGE :    dblarr(1)                     ,$
                  UVVS_CENTER_PHOT_ANGLES :        dblarr(3)                     ,$
                  VIRS_CENTER_PHOT_ANGLES :        dblarr(3)                     ,$
                  VIRS_UVVS_MATCH :                fltarr(1)                     ,$
                  DQI :                            strarr(7)                     ,$
                  FULLSPEC_WAVELENGTHS :           fltarr(540)                   ,$
                  FULLSPEC_PHOTOM_IOF_DATA :       fltarr(540)                   ,$
                  FULLSPEC_PHOTOM_IOF_NOISE_DATA : fltarr(540)                   ,$
                  SPARE_1 :                        fltarr(1)                     ,$
                  SPARE_2 :                        fltarr(1)                     ,$
                  SPARE_3 :                        fltarr(1)                     ,$
                  SPARE_4 :                        fltarr(1)                     }
                
                   
end

