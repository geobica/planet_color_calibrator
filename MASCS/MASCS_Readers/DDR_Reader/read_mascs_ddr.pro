function read_mascs_ddr, filename

; v1.0    5/18/12   mrl		New. Read UVVS and VIRS DDR files. 
;							Based on the MASCS CDR reader and associated files.
; v1.1    1/14/13   mrl     Adding a new column "MET_PARTITION" following the
;                               MET rollover event.
; v2.0      7/24/13 mrl     Adding capability to read UVVS surface DDRs and the 
;                           associated header files.
; v3.0    2/25/17 GMH       Adding capability to read UVVS FUV surface DDRs.                          
; 
;
; Developer contact information:
; Mark Lankton
; University of Colorado/LASP
; mark.lankton@lasp.colorado.edu
; 303-492-7915 office
; 720-272-6555 cell


if n_params() ne 1 then filename = dialog_pickfile()
if filename eq '' then return, -1

init_mascs_ddr_templates

; Key text from DDR file names, to identify the type of data in file
visname = 'VIRSVD*.DAT'
nirname = 'VIRSND*.DAT'
uvvssciname = 'UD_??_??_??.DAT'       ; For the original UVVS atmosphere DDRs
uvvsscsiname = 'UD_*SUMMARY_*.DAT'    ; For the by orbit summary UVVS atmosphere DDRs
;uvvssurfddrname = 'U*D*SCI.DAT'      ; For the newer UVVS surface DDRs (v2.0)
uvvssurfddrfuvname = 'UFD*SCI.DAT'    ; UVVS FUV surface DDRs (v3.0)
uvvssurfddrmuvname = 'UMD*SCI.DAT'    ; UVVS MUV surface DDRs (v3.0)
uvvssurfhdrname = 'U*D*HDR.DAT'       ; Both UVVS FUV and MUV surface DDR header files (v3.0)



; Constants derived from UVVS and VIRS DDR formats
nirsize = 5338		; 
vissize = 10458		;
uvvssize = 910      ; updated for added column in v1.1 (was 903)
uvvssumsize=908
uvvssurfddrsize = 270   ; New in v2.0
uvvssurfhdrsize = 36    ; New in v2.0

; These will come in handy below.
isUVVSDDR = 1
isVISDDR = 2
isNIRDDR = 3
isUVVSSURFMUVDDR = 4
isUVVSSURFHDR = 5
isUVVSSURFFUVDDR = 6
isUVVSDDRSUM = 7

whichType = 0

justname = strupcase(file_basename(filename))   
info = file_info(filename)

openr, theLUN, filename, /get_LUN

if strmatch(justname, visname) then begin
   num_data = info.size / vissize
   whichType = isVISDDR
   dummy = {virs_vis_ddr}
endif else if strmatch(justname, nirname) then begin 
   num_data = info.size / nirsize
   whichType = isNIRDDR
   dummy = {virs_nir_ddr}
endif else if strmatch(justname, uvvssciname) then begin
   num_data = info.size / uvvssize
   whichType = isUVVSDDR
   dummy = {uvvs_ddr}
endif else if strmatch(justname, uvvsscsiname) then begin
   num_data = info.size / uvvssumsize
   whichType = isUVVSDDRSUM
   dummy = {uvvs_ddrsum}
;endif else if strmatch(justname, uvvssurfddrname) then begin  ;(v2.0)
;   num_data = info.size / uvvssurfddrsize
;   whichType = isUVVSSURFDDR
;   dummy = {uvvs_surf_ddr}
endif else if strmatch(justname, uvvssurfddrfuvname) then begin ;(v3.0)
   num_data = info.size / uvvssurfddrsize
   whichType = isUVVSSURFFUVDDR
   dummy = {uvvs_surf_fuv_ddr}   
endif else if strmatch(justname, uvvssurfddrmuvname) then begin ;(v3.0)
   num_data = info.size / uvvssurfddrsize
   whichType = isUVVSSURFMUVDDR
   dummy = {uvvs_surf_ddr}
endif else if strmatch(justname, uvvssurfhdrname) then begin
   num_data = info.size / uvvssurfhdrsize
   whichType = isUVVSSURFHDR
   dummy = {uvvs_surf_header}     
endif else begin
   print, 'Unknown file type'
   return, -1
endelse

print, 'number of items:', num_data

result = replicate(dummy, num_data)

case whichType of
	isUVVSDDR: 	begin
					for i = long(0), num_data -1 do begin
						result[i] = read_uvvs_ddr(theLUN)
					endfor
				end	
	isUVVSDDRSUM: 	begin
					for i = long(0), num_data -1 do begin
						result[i] = read_uvvs_ddr_summary(theLUN)
					endfor
				end	

	isVISDDR:	begin
				for i = long(0), num_data -1 do begin
						result[i] = read_virs_vis_ddr(theLUN)
					endfor
				end	
	isNIRDDR:	begin
				for i = long(0), num_data -1 do begin
						result[i] = read_virs_nir_ddr(theLUN)
					endfor
				end	
  isUVVSSURFFUVDDR:  begin  ; (v3.0)
        for i = long(0), num_data -1 do begin
            result[i] = read_uvvs_surf_fuv_ddr(theLUN)
          endfor
        end 
  isUVVSSURFMUVDDR:  begin
        for i = long(0), num_data -1 do begin
            result[i] = read_uvvs_surf_ddr(theLUN)
          endfor
        end
  isUVVSSURFHDR:  begin
        for i = long(0), num_data -1 do begin
            result[i] = read_uvvs_surf_hdr(theLUN)
          endfor
        end
	else: print, 'second CASE statement got surprised'
endcase



free_lun, theLUN
return, result

end
