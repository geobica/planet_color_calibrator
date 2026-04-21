function read_mascs_cdr_6, filename, NotNAN = notnan

; v1.0    mrl    10/10/09      Read data from a MASCS binary Calibrated Data Record,
;							   returning an array of data structures that match the
;							   table structure defined in the CDR SIS documents for 
;							   UVVS and VIRS
;                              Works on all 4 flavors of CDR: UVVS header, UVVS data,
;							   VIRS VIS, and VIRS NIR.
;							   Reworked from the original to avoid the used of binary
;							   templates, which seem to be causing problems with
;							   MacOS implementation on 10.6.x and IDL7.1 (at least).
;
; v1.1	  mrl	 5/25/10	   Changed loop counters to longs to handle large files.
; 
; v1.2    mrl    8/19/10       Renamed to read_mascs_cdr3.pro. Major change to improve
;                              speed: space for the entire array of structures is now
;                              allocated at the start. Much, much faster.


; V2             8/2011          AWM             Renamed to read_mascs_cdr4.pro

;						Updated to replace SPARE_2 (double) with PMT_Temperature (float)

;						Moved the location of PMT_Temperature in the Structure allocation
;						Changed name of Radiance Uncertainty to STEP_RADIANCE_SIGNAL_TO_NOISE
;
; v3.0	mrl		5/11/12			Changed name again to "read_mascs_cdr_5.pro to signal
;								revisions to the CDR format. Subprograms have also been
;								updated; use the ones with a '5' in the name.
; v6	mrl		7/14/13			Last UVVS spare field is now used, for ORBIT_NUMBER
; 
; v6.1  mrl     5/21/14         Affects VIRS VIS and NIR CDRs only.
;                               Added "NotNAN" keyword. If this keyword is NOT set, this function
;                               replace all values of 1E32 in fields 
;                               CORRECTED_COUNTS_SPECTRUM_DATA
;                               and
;                               CALIBRATED_RADIANCE_SPECTRUM_DATA
;                               with !values.f_nan. This is the default action.
;                               If keyword NotNAN IS set, no replacement occurs. 
;                               By Special Request.
;
; Developer contact information:
; Mark Lankton
; University of Colorado/LASP
; mark.lankton@lasp.colorado.edu
; 303-492-7915 office
; 720-272-6555 cell


if n_params() ne 1 then filename = dialog_pickfile()
if filename eq '' then return, -1

init_mascs_cdr_templates_6

if ~keyword_set(notnan) then notnan = 0       ; Make sure nan has a value before passing it below.

; Key text from CDR file names, to identify the type of data in file
visname = 'VIRSVC*.DAT'
nirname = 'VIRSNC*.DAT'
uvvshdrname = '*HDR.DAT'
uvvssciname = '*SCI.DAT'

; Constants derived from UVVS and VIRS CDR formats
nirsize = 4954		; was 5050 in previous version
vissize = 9562		; was 9658 in previous version
uvvshdrsize = 50
uvvsscisize = 752    ; Was 970 in previous version

; These will come in handy below.
isUVVSSci = 1
isUVVSHdr = 2
isVISSci = 3
isNIRSci = 4

whichType = 0

justname = strupcase(file_basename(filename))   
info = file_info(filename)

openr, theLUN, filename, /get_LUN

if strmatch(justname, visname) then begin
   num_data = info.size / vissize
   whichType = isVISSCI
   dummy = {vis_cdr}
endif else if strmatch(justname, nirname) then begin 
   num_data = info.size / nirsize
   whichType = isNIRSci
   dummy = {nir_cdr}
endif else if strmatch(justname, uvvshdrname) then begin   
   num_data = info.size / uvvshdrsize
   whichType = isUVVSHdr
   dummy = {cdr_hdr}
endif else if strmatch(justname, uvvssciname) then begin
   num_data = info.size / uvvsscisize
   whichType = isUVVSSci
   dummy = {cdr_sci}
endif else begin
   print, 'Unknown file type'
   return, -1
endelse

print, 'number of items:', num_data

result = replicate(dummy, num_data)

case whichType of
	isUVVSHdr:	begin
					for i = long(0), num_data -1 do begin
						result[i] = read_uvvs_cdr_hdr_6(theLUN)
					endfor
				end
	isUVVSSci: 	begin
					for i = long(0), num_data -1 do begin
						result[i] = read_uvvs_cdr_sci_6(theLUN)
					endfor
				end	
	isVISSCI:	begin
				for i = long(0), num_data -1 do begin
						dummy = read_virs_vis_cdr_6(theLUN)
						if notnan eq 0 then begin
						  dummy.CORRECTED_COUNTS_SPECTRUM_DATA[where(dummy.CORRECTED_COUNTS_SPECTRUM_DATA eq 1.0e32)] = !values.f_nan
                          dummy.CALIBRATED_RADIANCE_SPECTRUM_DATA[where(dummy.CALIBRATED_RADIANCE_SPECTRUM_DATA eq 1.0e32)] = !values.f_nan
						endif
						result[i] = dummy
					endfor
				end	
	isNIRSci:	begin
				for i = long(0), num_data -1 do begin
						dummy = read_virs_nir_cdr_6(theLUN)
						if notnan eq 0 then begin
						  dummy.CORRECTED_COUNTS_SPECTRUM_DATA[where(dummy.CORRECTED_COUNTS_SPECTRUM_DATA eq 1.0e32)] = !values.f_nan
                          dummy.CALIBRATED_RADIANCE_SPECTRUM_DATA[where(dummy.CALIBRATED_RADIANCE_SPECTRUM_DATA eq 1.0e32)] = !values.f_nan
						endif
						result[i] = dummy
					endfor
				end	
	else: print, 'second CASE statement got surprised'
endcase



free_lun, theLUN
return, result

end

