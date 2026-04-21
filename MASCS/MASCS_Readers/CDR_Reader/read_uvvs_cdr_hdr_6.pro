function read_uvvs_cdr_hdr_6, theUnit
; v1.0		10/10/09	mrl		Initialize a data structure and read a MASCS UVVS
;								CDR record from a file. Return the populated structure.
;								This one reads the UVVS 'HDR' files.
; v1.1		6/26/13		mrl		Updated the first line to call init_mascs_cdr_templates_5, 
;								the current version.
; v1.2		7/14/13		mrl		Another update: now it's init_mascs_cdr_templates_6
; v1.3      11/9/13     mrl     Greg Holsclaw found that the filename and function name did not
;                               match, leading to calling a stale version from other programs. Fixed. 


init_mascs_cdr_templates_6	; v1.2

theData = {cdr_hdr}


; Can't read from a file directly into a structure element.
; So, let's introduce some variables and use them...
temp2 = uint(0)
temp4 = ulong(0)
tempf = float(0)
tempd = double(0)

readu, theUnit, temp2
theData.seq_counter = temp2

readu, theUnit, temp4
theData.sc_time = temp4

readu,theUnit, temp2
theData.packet_subseconds = temp2

readu,theUnit, temp2
theData.start_pos = temp2

readu,theUnit, temp2
theData.step_count = temp2

readu,theUnit, temp2
theData.int_time = temp2

readu,theUnit, temp2
theData.step_time = temp2

readu,theUnit, temp2
theData.phase_offset = temp2

readu,theUnit, temp2
theData.scan_cycles = temp2

readu,theUnit, temp2
theData.zigzag = temp2

readu,theUnit, temp2
theData.compression = temp2

readu,theUnit, temp2
theData.slit_mask_pos = temp2

readu,theUnit, temp2
theData.fuv_on = temp2

readu,theUnit, temp2
theData.muv_on = temp2

readu,theUnit, temp2
theData.vis_on = temp2

readu,theUnit, temp2
theData.buffer_overflow = temp2

readu,theUnit, temp2
theData.spare_bits = temp2

readu,theUnit, temp2
theData.gd_settle_ctr = temp2

readu,theUnit, temp2
theData.num_scan_values = temp2

readu,theUnit, temp2
theData.step_size = temp2

readu,theUnit, temp2
theData.pad_byte = temp2

readu,theUnit, temp2
theData.coadd = temp2

readu,theUnit, tempf
theData.calibration_software_version = tempf


result = swap_endian(thedata, /swap_if_little_endian)

return, result

end
