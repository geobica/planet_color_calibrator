pro show_DQI, theData, VERBOSE = verbose

; v1.0		mrl		12/18/08	Show the MASCS Calibrated Data Record Data_Quality_Index flags
;								in a useful way.
;								Works for VIRS_VIS, VIRS_NIR and UVVS_SCI Calibrated Data Records
;								"Verbose" mode lists flag descriptions with flags. "Non-verbose" mode
;								just shows all flags for a record on one line -- this would make it 
;								easy to scan for changes in flags.
;
; v2.0		mrl		2/12/09		Updated for versions 1.4 of the UVVS and VIRS SIS
;
; v3.0		mrl		5/24/12		Updated to recognize the VIRS and UVVS DDR structures. The
;								DQI details are unchanged from the CDRS.
;
; Developer contact information:
; Mark Lankton
; University of Colorado/LASP
; mark.lankton@lasp.colorado.edu
; 303-492-7915 office
; 720-272-6555 cell


if n_params() ne 1 then begin
	print, '### Usage: show_DQI, theData ###'
	print, 'Set /VERBOSE keyword to show descriptions with flags'
	print, '"theData" must be UVVS science or VIRS NIR or VIS CDR data as returned by "read_mascs_cdr" '
	return
endif

numStructs = n_elements(theData)

; No checks to make sure that 'theData' is the right stuff; just try to use it.
tags = tag_names(theData)
if (strupcase(tags[0]) eq 'STEP_NUMBER')  then begin	; Must be UVVS
	for i = 0, numStructs - 1 do begin
		print, 'Record#' + string(i), '    ', string(theData[i].data_quality_index)
		if keyword_set(verbose) then begin
			print, 'SBOS Trip:', string((theData[i].data_quality_index)[0])
			print, 'Footprint center on planet:', string((theData[i].data_quality_index)[2])
			print, 'Footprint C1 on planet:', string((theData[i].data_quality_index)[3])
			print, 'Footprint C2 on planet:', string((theData[i].data_quality_index)[4])
			print, 'Footprint C3 on planet:', string((theData[i].data_quality_index)[5])
			print, 'Footprint C4 on planet:', string((theData[i].data_quality_index)[6])
			print, 'Partial scan (macro cutoff):', string((theData[i].data_quality_index)[8])
			print, 'Temperature 1 flag:', string((theData[i].data_quality_index)[9])
			print, 'UVVS noise spike flag:', string((theData[i].data_quality_index)[10])
			print, 'VIRS operating flag:', string((theData[i].data_quality_index)[11])
			print, 'Buffer overflow flag:', string((theData[i].data_quality_index)[13])
			print, 'Background subtraction method:', string((theData[i].data_quality_index)[14])
			print, 'Background quality flag:', string((theData[i].data_quality_index)[15])
			print, 'SPICE Version Epoch:', string((theData[i].data_quality_index)[17])
			print, 'Spare 2:', string((theData[i].data_quality_index)[18])
			print, 'Spare 3:', string((theData[i].data_quality_index)[19])
			print, 'Spare 4:', string((theData[i].data_quality_index)[20])
			print, ''
		endif
	endfor
endif else if (strupcase(tags[5]) eq 'PERIOD' or strupcase(tags[0]) eq 'SC_TIME') then begin	; Must be VIRS
	for i = 0, numStructs - 1 do begin
		print, 'Record#' + string(i), '    ', string(theData[i].data_quality_index)
		if keyword_set(verbose) then begin
			print, 'Dark Scan Flag:', string((theData[i].data_quality_index)[0])
			print, 'Temperature 1 Flag:', string((theData[i].data_quality_index)[1])
			print, 'Temperature 2 Flag:', string((theData[i].data_quality_index)[2])
			print, 'Grating Temperature Flag:', string((theData[i].data_quality_index)[3])
			print, 'Anomalous Pixels:', string((theData[i].data_quality_index)[5])
			print, 'Partial Data Flag:', string((theData[i].data_quality_index)[6])
			print, 'Saturation Flag:', string((theData[i].data_quality_index)[7])
			print, 'Low Signal Level Flag:', string((theData[i].data_quality_index)[8])
			print, 'Low VIS Wavelength Uncertainty Flag:', string((theData[i].data_quality_index)[10])
			print, 'High VIS Wavelength Uncertainty Flag:', string((theData[i].data_quality_index)[11])
			print, 'UVVS Operating Flag:', string((theData[i].data_quality_index)[12])
			print, 'UVVS Noise Spike Flag:', string((theData[i].data_quality_index)[13])
			print, 'SPICE Version Epoch:', string((theData[i].data_quality_index)[15])
			print, 'Spare 2:', string((theData[i].data_quality_index)[16])
			print, 'Spare 3:', string((theData[i].data_quality_index)[17])
			print, 'Spare 4:', string((theData[i].data_quality_index)[18])
			print, ''
		endif
	endfor
endif else begin
	print, 'This does not appear to be UVVS CDR, or VIRS CDR or DDR data'
endelse




end
	