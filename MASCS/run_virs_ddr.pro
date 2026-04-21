; Add DDR reader directory to GDL path
!PATH = expand_path('+MASCS_Readers/CDR_Reader') + ':' + !PATH

; Initialize CDR templates
init_mascs_cdr_templates

; Debug print
print, 'Starting CDR read...'
flush, -1

; Read your VIRS NIR CDR file
result = read_mascs_cdr_6('virsvc_vf2_07156_225458.dat')

print, 'Finished read.'
help, result, /STRUCTURE

; Optional: save output for Python
save, result, filename='virsvc_vf2_07156_225458.sav'


;!PATH = expand_path('+MASCS_Readers/DDR_Reader') + ':' + !PATH
;init_mascs_ddr_templates

;result = read_mascs_ddr('virsne_vf2_07156_225458.dat')
;print, 'Finished read.'
;help, result, /STRUCTURE
;save, result, filename='virsne_vf2_07156_225458.sav'

exit