pro init_mascs_cdr_templates_6
; Run this to set up the data structures for MASCS CDR files.
;
; v1.0		10/10/09	mrl
; v1.1		4/19/10		mrl		Updated: changed spare_1 (double) to SC_time (ulong)
; 								to match revised SOC template for CDRs
;
; V2        8/2011      AWM      Renamed to init_mascs_cdr_templates_4 to be consistent with read_mascs_cdr4
;						         Updated to replace SPARE_2 (double) with PMT_Temperature (float)
;						         Moved the location of PMT_Temperature in the Structure allocation.
;						         Changed name of Radiance Uncertainty to STEP_RADIANCE_SIGNAL_TO_NOISE
; v3.0		5/9/12		mrl		Updated to remove 4 fields of pointing information that
;								no one is using. (Saves 96 bytes per record.)
; v5							Re-named with a '5' on the end to make it easier to 
; 								identify it as a MASCS CDR Reader v5 file.
; v6							SPARE_2 is now used: ORBIT_NUMBER, and renamed to '6'.

uvvs_cdr_hdr = 	{							$
				cdr_hdr,					$
			   	SEQ_COUNTER:UINT(0),		$
   				SC_TIME:ULONG(0),			$
   				PACKET_SUBSECONDS:UINT(0),	$
   				START_POS:UINT(0),			$
   				STEP_COUNT:UINT(0),			$
   				INT_TIME:UINT(0),			$
   				STEP_TIME:UINT(0),			$
   				PHASE_OFFSET:UINT(0),		$
   				SCAN_CYCLES:UINT(0),		$
   				ZIGZAG:UINT(0),				$
   				COMPRESSION:UINT(0),		$
   				SLIT_MASK_POS:UINT(0),		$
   				FUV_ON:UINT(0),				$
   				MUV_ON:UINT(0),				$
   				VIS_ON:UINT(0),				$
   				BUFFER_OVERFLOW:UINT(0),	$
   				SPARE_BITS:UINT(0),			$
   				GD_SETTLE_CTR:UINT(0),		$
   				NUM_SCAN_VALUES:UINT(0),	$
   				STEP_SIZE:UINT(0),			$
   				PAD_BYTE:UINT(0),			$
   				COADD:UINT(0),				$
   				CALIBRATION_SOFTWARE_VERSION:FLOAT(0)	$
   				}
   				
uvvs_cdr_sci =	{											$
				cdr_sci,									$
				STEP_NUMBER:UINT(0),						$
   				;PLANET_SUN_VECTOR_J2:DBLARR(3),			$		; v3.0 set of J2000 fields deleted
   				;PLANET_SC_VECTOR_J2:DBLARR(3),				$
   				;SPACECRAFT_POSITION_VECTOR_J2:DBLARR(3),	$
   				;SUN_POSITION_VECTOR_J2:DBLARR(3),			$
   				;TARGET_BODY_VECTOR_J2:DBLARR(3),			$
   				;BORESIGHT_UNIT_VECTOR_CENTER_J2:DBLARR(3),	$
   				;BORESIGHT_UNIT_VECTOR_C1_J2:DBLARR(3),		$
   				;BORESIGHT_UNIT_VECTOR_C2_J2:DBLARR(3),		$
   				;BORESIGHT_UNIT_VECTOR_C3_J2:DBLARR(3),		$
   				;BORESIGHT_UNIT_VECTOR_C4_J2:DBLARR(3),		$
   				PLANET_SUN_VECTOR_TG:DBLARR(3),				$
   				PLANET_SC_VECTOR_TG:DBLARR(3),				$
   				BORESIGHT_UNIT_VECTOR_CENTER_TG:DBLARR(3),	$
   				BORESIGHT_UNIT_VECTOR_C1_TG:DBLARR(3),		$
   				BORESIGHT_UNIT_VECTOR_C2_TG:DBLARR(3),		$
   				BORESIGHT_UNIT_VECTOR_C3_TG:DBLARR(3),		$
   				BORESIGHT_UNIT_VECTOR_C4_TG:DBLARR(3),		$
   				SURFACE_TANGENT_VECTOR_CENTER:DBLARR(3),	$
   				SURFACE_TANGENT_VECTOR_C1:DBLARR(3),		$
   				SURFACE_TANGENT_VECTOR_C2:DBLARR(3),		$
   				SURFACE_TANGENT_VECTOR_C3:DBLARR(3),		$
   				SURFACE_TANGENT_VECTOR_C4:DBLARR(3),		$
   				RA_SET:DBLARR(5),							$
   				DEC_SET:DBLARR(5),							$
   				TARGET_LATITUDE_SET:DBLARR(5),				$
   				TARGET_LONGITUDE_SET:DBLARR(5),				$
   				TARGET_ALTITUDE_SET:DBLARR(5),				$
   				SLIT_ROTATION_ANGLE:double(0),				$
   				ALONG_TRACK_FOOTPRINT_SIZE:double(0),		$
   				ACROSS_TRACK_FOOTPRINT_SIZE:double(0),		$
   				FOOTPRINT_AZIMUTH:double(0),				$
   				INCIDENCE_ANGLE:double(0),					$
   				EMISSION_ANGLE:double(0),					$
   				PHASE_ANGLE:double(0),						$
  				SLANT_RANGE_TO_CENTER:double(0),			$
   				SUBSPACECRAFT_LATITUDE:double(0),			$
   				SUBSPACECRAFT_LONGITUDE:double(0),			$
   				NADIR_ALTITUDE:double(0),					$
   				SUBSOLAR_LATITUDE:double(0),				$
   				SUBSOLAR_LONGITUDE:double(0),				$
   				SOLAR_DISTANCE:double(0),					$
   				PLANET_TRUE_ANOMALY:double(0),				$
  	 			MIDSTEP_TIME:double(0),						$
   				STEP_UTC_TIME:bytarr(17),					$
   				GRATING_OFFSET:float(0),					$
   				STEP_POSITION:long(0),						$
   				STEP_WAVELENGTH:float(0),					$
   				RAW_STEP_DATA:uint(0),						$
   				COUNT_RATE:float(0),						$
   				DEAD_CORRECTED_COUNT_RATE:float(0),			$
   				DARK_RATE:float(0),							$
   				SCATTERED_LIGHT_RATE:float(0),				$
   				FULLY_CORRECTED_COUNT_RATE:float(0),		$
   				FULLY_CORRECTED_COUNT_RATE_UNCERTAINTY:float(0),	$
   				STEP_RADIANCE_KR:float(0),					$
   				STEP_RADIANCE_W:float(0),					$
   				STEP_RADIANCE_SIGNAL_TO_NOISE:float(0),		$
				PMT_TEMPERATURE:float(0),					$
   				DATA_QUALITY_INDEX:bytarr(21),				$
   				SC_TIME:ulong(0),							$			; v1.1 spare_1 changed to SC_TIME, was double, now ulong
   				OBSERVATION_TYPE:bytarr(30),				$			; v3.0
   				ORBIT_NUMBER:double(0)						$			; v5.1 Using up the last spare field.
   				}   				
   				

virs_vis_cdr = 	{											$
				vis_cdr,									$
 				SEQ_COUNTER:UINT(0),						$
   				SC_TIME:ulong(0),							$
   				PACKET_SUBSECONDS:UINT(0),					$
   				INT_TIME:UINT(0),							$
   				INT_COUNT:UINT(0),							$
   				PERIOD:UINT(0),								$
   				DARK_FREQ:UINT(0),							$
   				TEMP_1:float(0),							$
   				TEMP_2:float(0),							$
   				NIR_GAIN:UINT(0),							$
   				OTHER_CHANNEL_ON:UINT(0),					$
   				NIR_LAMP_ON:UINT(0),						$
   				VIS_LAMP_ON:UINT(0),						$
   				BINNING:UINT(0),							$
   				START_PIXEL:UINT(0),						$
   				END_PIXEL:UINT(0),							$
   				SPECTRUM_NUMBER:UINT(0),					$
   				SPECTRUM_MET:ulong(0),						$
   				SPECTRUM_SUBSECONDS:UINT(0),				$
   				RAW_SPECTRUM_DATA:intarr(512),				$
   				SPECTRUM_UTC_TIME:bytarr(17),				$
   				CORRECTED_COUNTS_SPECTRUM_DATA:fltarr(512),	$
   				CALIBRATED_RADIANCE_SPECTRUM_DATA:fltarr(512),	$
   				NOISE_SPECTRUM_DATA:fltarr(512),				$
	   			CALIBRATION_SOFTWARE_VERSION:float(0), 			$
   				CHANNEL_WAVELENGTHS:fltarr(512),			$
   				HK_DATA_FLAG:long(0),						$
   				DATA_QUALITY_INDEX:bytarr(19),				$
   				VIRS_GRATING_TEMP:float(0),					$
   				;SPACECRAFT_POSITION_VECTOR:dblarr(3),		$	These 4 fields deleted for v3.0
   				;SUN_POSITION_VECTOR:dblarr(3),				$
   				;TARGET_BODY_VECTOR:dblarr(3),				$
   				;INSTRUMENT_BORESIGHT_VECTOR:dblarr(3),		$
   				TARGET_LATITUDE_SET:dblarr(5),				$
   				TARGET_LONGITUDE_SET:dblarr(5),				$
   				ALONG_TRACK_FOOTPRINT_SIZE:double(0),		$
   				ACROSS_TRACK_FOOTPRINT_SIZE:double(0),		$
   				FOOTPRINT_AZIMUTH:double(0),				$
   				INCIDENCE_ANGLE:double(0),					$
   				EMISSION_ANGLE:double(0),					$
   				PHASE_ANGLE:double(0),						$
   				SLANT_RANGE_TO_CENTER:double(0),			$
   				SUBSPACECRAFT_LATITUDE:double(0),			$
   				SUBSPACECRAFT_LONGITUDE:double(0),			$
   				NADIR_ALTITUDE:double(0),					$
   				SUBSOLAR_LATITUDE:double(0),				$
   				SUBSOLAR_LONGITUDE:double(0),				$
   				SOLAR_DISTANCE:double(0),					$
   				PLANET_TRUE_ANOMALY:double(0),				$
   				SPARE_1:float(0),							$
   				RIGHT_ASCENSION:double(0),					$
   				DECLINATION:double(0),						$
			   	SPARE_2:long(0),							$
			  	SPARE_3:long(0),							$
			   	SPARE_4:long(0),							$
			   	SPARE_5:long(0),							$
			   	SPARE_6:long(0),							$
			   	SPARE_7:long(0),							$
			   	SPARE_8:long(0),							$
			   	SPARE_9:long(0),							$
			   	SPARE_10:long(0),							$
			   	SPARE_11:long(0)							$
			   	}



virs_nir_cdr = 	{											$
				nir_cdr,									$
 				SEQ_COUNTER:UINT(0),						$
   				SC_TIME:ulong(0),							$
   				PACKET_SUBSECONDS:UINT(0),					$
   				INT_TIME:UINT(0),							$
   				INT_COUNT:UINT(0),							$
   				PERIOD:UINT(0),								$
   				DARK_FREQ:UINT(0),							$
   				TEMP_1:float(0),							$
   				TEMP_2:float(0),							$
   				NIR_GAIN:UINT(0),							$
   				OTHER_CHANNEL_ON:UINT(0),					$
   				NIR_LAMP_ON:UINT(0),						$
   				VIS_LAMP_ON:UINT(0),						$
   				BINNING:UINT(0),							$
   				START_PIXEL:UINT(0),						$
   				END_PIXEL:UINT(0),							$
   				SPECTRUM_NUMBER:UINT(0),					$
   				SPECTRUM_MET:ulong(0),						$
   				SPECTRUM_SUBSECONDS:UINT(0),				$
   				RAW_SPECTRUM_DATA:intarr(256),				$
   				SPECTRUM_UTC_TIME:bytarr(17),				$
   				CORRECTED_COUNTS_SPECTRUM_DATA:fltarr(256),	$
   				CALIBRATED_RADIANCE_SPECTRUM_DATA:fltarr(256),	$
   				NOISE_SPECTRUM_DATA:fltarr(256),				$
	   			CALIBRATION_SOFTWARE_VERSION:float(0), 			$
   				CHANNEL_WAVELENGTHS:fltarr(256),			$
   				HK_DATA_FLAG:long(0),						$
   				DATA_QUALITY_INDEX:bytarr(19),				$
   				VIRS_GRATING_TEMP:float(0),					$
   				;SPACECRAFT_POSITION_VECTOR:dblarr(3),		$	These 4 fields deleted for v3.0
   				;SUN_POSITION_VECTOR:dblarr(3),				$
   				;TARGET_BODY_VECTOR:dblarr(3),				$
   				;INSTRUMENT_BORESIGHT_VECTOR:dblarr(3),		$
   				TARGET_LATITUDE_SET:dblarr(5),				$
   				TARGET_LONGITUDE_SET:dblarr(5),				$
   				ALONG_TRACK_FOOTPRINT_SIZE:double(0),		$
   				ACROSS_TRACK_FOOTPRINT_SIZE:double(0),		$
   				FOOTPRINT_AZIMUTH:double(0),				$
   				INCIDENCE_ANGLE:double(0),					$
   				EMISSION_ANGLE:double(0),					$
   				PHASE_ANGLE:double(0),						$
   				SLANT_RANGE_TO_CENTER:double(0),			$
   				SUBSPACECRAFT_LATITUDE:double(0),			$
   				SUBSPACECRAFT_LONGITUDE:double(0),			$
   				NADIR_ALTITUDE:double(0),					$
   				SUBSOLAR_LATITUDE:double(0),				$
   				SUBSOLAR_LONGITUDE:double(0),				$
   				SOLAR_DISTANCE:double(0),					$
   				PLANET_TRUE_ANOMALY:double(0),				$
   				SPARE_1:float(0),							$
   				RIGHT_ASCENSION:double(0),					$
   				DECLINATION:double(0),						$
			   	SPARE_2:long(0),							$
			  	SPARE_3:long(0),							$
			   	SPARE_4:long(0),							$
			   	SPARE_5:long(0),							$
			   	SPARE_6:long(0),							$
			   	SPARE_7:long(0),							$
			   	SPARE_8:long(0),							$
			   	SPARE_9:long(0),							$
			   	SPARE_10:long(0),							$
			   	SPARE_11:long(0)							$
			   	}
			   	
			   	
end
