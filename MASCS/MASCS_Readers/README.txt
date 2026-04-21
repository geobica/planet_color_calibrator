3/27/17

NOTE TO USERS: The readers described in this readme file are provided as a courtesy for selected 
MESSENGER MASCS CDR and DDR products, are not part of the official MASCS PDS archive, and are not 
validated. These readers are provided without guarantee of support by the MESSENGER team, and users 
are advised to reference the MASCS PDS documentation for the peer-reviewed information on the MASCS 
products.

This is the README file for the MASCS CDR and DDR readers:
  read_mascs_cdr_6.pro 
    and 
  read_mascs_ddr.pro
    and
  read_uvvis_combo_ddr.pro
----------------------------------------------------------------------------------------------
MASCS science data are available from the Planetary Data System (PDS) as Calibrated Data Record (CDR) 
and Derived Data Record (DDR) files. The data structures of the CDR and DDR files are defined
in Software Interface Specification (SIS) documents, available from PDS.

The IDL readers "read_mascs_cdr_6.pro", "read_mascs_ddr.pro, and "read_uvvis_combo_ddr.pro" are 
functions that read a CDR or DDR file and return an IDL array of data structures that follow the 
SIS definitions.
----------------------------------------------------------------------------------------------
Release Notes 3/27/17

This is the final release of the MASCS CDR and DDR readers concurrent with PDS release 16.
The readers have been updated to read the 3 news DDR data products: the UVVS FUV Surface DDRs, 
the UVVS Atmosphere Summary DDRs, and the UVVS+VIRS Combined DDRs.
----------------------------------------------------------------------------------------------
Release Notes 6/3/2014

This release implements a change in the reader's default behavior when reading VIRS VIS and VIRS NIR
CDRs. The default behavior of read_mascs_cdr_6() is now to replace any instance of the value 
1.0e32 in the fields CORRECTED_COUNTS_SPECTRUM_DATA and CALIBRATED_RADIANCE_SPECTRUM_DATA with 
NaN (Not a Number), specifically the IDL system value !values.f_nan.

To maintain the original behavior of read_mascs_cdr_6() for users who prefer it, the keyword 
NotNaN was added. If the keyword is set to 1, no replacement occurs.
----------------------------------------------------------------------------------------------
Usage:

  result = read_mascs_cdr_6(CDR_Filename, [/NotNaN])
    or
  result = read_mascs_ddr(DDR_Filename)
    or
  result = read_uvvis_combo_ddr(DDR_Filename)
  
Wildcard characters are NOT allowed in the filename parameter. 

If no filename is supplied, the readers query the user to select a file via IDL's 
dialog_pickfile() dialog box.
----------------------------------------------------------------------------------------------
Supporting files:

For read_mascs_cdr_6, the following files, included in the distribution of the 
CDR reader, must be available in the IDL path:

  init_mascs_cdr_templates_6.pro
  read_mascs_cdr_6.pro
  read_uvvs_cdr_hdr_6.pro
  read_uvvs_cdr_sci_6.pro
  read_virs_nir_cdr_6.pro
  read_virs_vis_cdr_6.pro
  
For read_mascs_ddr, the following files, included in the distribution of the 
DDR reader, must be available in the IDL path:

  init_mascs_ddr_templates.pro
  read_mascs_ddr.pro
  read_uvvs_ddr.pro
  read_uvvs_ddr_summary.pro
  read_uvvs_surf_ddr.pro
  read_uvvs_surf_fuv_ddr.pro
  read_uvvs_surf_hdr.pro
  read_virs_nir_ddr.pro
  read_virs_vis_ddr.pro
  
In order to read in the UVVS+VIRS combined DDR dataset, the following file, included
in the distribution of the DDR reader, must be available in the IDL path:

  read_uvvis_combo_ddr.pro
----------------------------------------------------------------------------------------------
Contact information:

MASCS VIRS:
Greg Holsclaw
University of Colorado/LASP
Greg.Holsclaw@lasp.colorado.edu
303-735-0480

MASCS UVVS:
Aimee Merkel
University of Colorado/LASP
Aimee.Merkel@lasp.colorado.edu
303-735-5658
