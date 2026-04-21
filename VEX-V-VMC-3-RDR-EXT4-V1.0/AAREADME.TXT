PDS_VERSION_ID                 = PDS3                                         
RECORD_TYPE                    = FIXED_LENGTH                                 
RECORD_BYTES                   = 80                                           
TARGET_NAME                    = VENUS                                        
                                                                              
RELEASE_ID                     = 0001                                         
REVISION_ID                    = 0000                                         
OBJECT                         = TEXT                                         
  PUBLICATION_DATE             = 2013-05-31                                   
  NOTE                         = "VENUS Express Archive DE_DLR_PF_VEXVMC_0001"
END_OBJECT                     = TEXT                                         
END                                                                           
                                                                              
                                                                              
                                                                              
1. Introduction                                                               
                                                                              
    This dataset contains images from the Venus Monitoring Camera (VMC)       
    onboard the VenusExpress spacecraft.                                      
                                                                              
    It also contains documentation which describe the images.                 
                                                                              
    The VMC images archived in this dataset are the exact products            
    released by the VMC team. Supporting documentation and label files        
    confirm to the Planetary Data System (PDS) Standards, Version 3.0,        
    Jet Propulsion Laboratory (JPL) document JPL D-7669.                      
    Additional information about the VMC experiment, including the            
    acquisition, processing, and quality of the VMC data, can be found in     
    documents that are available from ESA's Planetary Science Archive (PSA)   
    at ESTEC, Nordwijk, Netherlands.                                          
                                                                              
2. Disk Format                                                                
                                                                              
This section is not applicable since the data are stored only electronically. 
                                                                              
                                                                              
3. File Formats                                                               
                                                                              
    All document files and detached label files contain 80-byte fixed-        
length records, with a carriage return character (ASCII 13) in the 79th       
byte and a line feed character (ASCII 10) in the 80th byte.  This             
allows the files to be read by the MacOS, DOS, Unix, and VMS operating        
systems.  All tabular files are also described by PDS labels, either          
embedded at the beginning of the file or detached.  If detached, the          
PDS label file has the same name as the data file it describes, with          
the extension .LBL; for example, the file INDEX.TAB is accompanied            
by the detached label file INDEX.LBL in the same directory.                   
                                                                              
    Tabular files are formatted so that they may be read directly into        
many database management systems on various computers.  All fields are        
separated by commas, and character fields are enclosed in double              
quotation marks (").  Character fields are left justified, and numeric        
fields are right justified.  The "start byte" and "bytes" values listed       
in the labels do not include the commas between fields or the quotation       
marks surrounding character fields.  The records are of fixed length,         
and the last two bytes of each record contain the ASCII carriage return       
and line feed characters.  This allows a table to be treated as a fixed       
length record file on computers that support this file type and as a          
normal text file on other computers.                                          
                                                                              
    PDS labels are object-oriented.  The object to which the label            
refers (e.g. IMAGE, TABLE, etc.) is denoted by a statement of the form        
                                                                              
    ^object = location                                                        
                                                                              
in which the carat character (^, also called a pointer in this context)       
indicates that the object starts at the given location.  In an embedded       
label, the location is an integer representing the starting record            
number of the object (the first record in the file is record 1).  In a        
detached label, the location denotes the name of the file containing          
the object, along with the starting record or byte number if there is         
more than one object.  For example,                                           
                                                                              
    ^IMAGE_HEADER = ("F02.IMG",1)                                             
    ^IMAGE = ("F02.IMG",3)                                                    
                                                                              
indicates that the IMAGE object begins at record 3 of the file                
F02.IMG, in the same directory as the detached label file.  Below             
is a list of the possible formats for the ^object definition.                 
                                                                              
^object = n                                                                   
^object = n<BYTES>                                                            
^object = ("filename.ext")                                                    
^object = ("filename.ext",n)                                                  
^object = ("[dirlist]filename.ext",n)                                         
^object = ("filename.ext",n<BYTES>)                                           
^object = ("[dirlist]filename.ext",n<BYTES>)                                  
                                                                              
where                                                                         
                                                                              
   n        is the starting record or byte number of the object,              
             counting from the beginning of the file (record 1, byte 1).      
                                                                              
   <BYTES>  indicates that the number given is in units of bytes.             
                                                                              
    filename is the upper-case file name, before the decimal point.           
                                                                              
    ext      is the upper-case file name, after the decimal point.            
                                                                              
    dirlist  is a period-delimited path-list of parent directories, in        
             upper case, that specifies the object file directory.  The       
             list begins on directory level below the root directory of       
             the CD-ROM.  '[dirlist]' may be omitted when the object          
             being described is located either in the same directory as       
            the detached label or in a sub-directory named 'LABEL',           
            located one level below the CD-ROM root directory.                
                                                                              
                                                                              
      FILENAMING FOR IMAGE DATA                                               
                                                                              
      The following structure of filenames was used                           
                                                                              
      VOOOO_MMMM_DDL.IMG                                                      
                                                                              
      - camera id                                           V                 
                                                                              
      - orbit number                                        OOOO              
                                                                              
      - image number in one orbit                            MMMM             
                                                                              
      - detector id                                         DD                
        (can be UV,VI,I1,I2)                                                  
                                                                              
      - level (2)                                     L                       
                                                                              
      examples:                                                               
      V1234_0023_VI1.IMG                                                      
      V1234_0323_UV2.IMG                                                      
                                                                              
 4.  Volume Contents                                                          
                                                                              
     The files on this volumes are organized in one top-level directory       
 with several subdirectories.  The following table shows the structure        
 and content of these directories.  In the table, directory names are         
 enclosed in square brackets ([]), upper-case letters indicate an actual      
 directory or file name, and lower-case letters indicate the general          
 form of a set of directory or file names.                                    
                                                                              
                                                                              
 FILE                                     CONTENTS                            
                                                                              
Top-level directory                                                           
 |                                                                            
 |-AAREADME.TXT                This text file.                                
 |                                                                            
 |-VOLDESC.CAT                 A description of the contents of this          
 |                             volume in a PDS format readable by both        
 |                             human and computers.                           
 |                                                                            
 |-ERRATA.TXT                  This file summarizes known errors.             
 |                                                                            
 |- [BROWSE]                   This directory contains reduced size           
 |   |                         versions of all images in the DATA directory.  
 |   |                                                                        
 |   |- BROWINFO.TXT           A description of the contents of this          
 |   |                         directory.                                     
 |   |                                                                        
 |   |-[ORBIT NUMBER]          Sub-divided orbit number                       
 |      |                      directories.                                   
 |      |                                                                     
 |      |-----BROWSE.JPG       Browse images in .JPG format                   
 |      |                                                                     
 |      |-----BROWSE.LBL       PDS detached labels that describe the          
 |                             Browse images                                  
 |                                                                            
 |- [CATALOG]                  A directory containing files that provide      
 |   |                         a top-level understanding of the mission,      
 |   |                         spacecraft, instruments, and data sets.        
 |   |                                                                        
 |   |-CATINFO.TXT             A description of the contents of this          
 |   |                         directory.                                     
 |   |                                                                        
 |   |-DATASET.CAT             VMC  data set information for the PDS          
 |   |                         catalog.                                       
 |   |                                                                        
 |   |-INST.CAT                VMC  instrument information for the PDS        
 |   |                         catalog.                                       
 |   |                                                                        
 |   |-INSTHOST.CAT            VMC  instrument host (i.e.,spacecraft)         
 |   |                         information for the PDS catalog.               
 |   |                                                                        
 |   |-MISSION.CAT             VMC  mission information for the PDS           
 |   |                         catalog.                                       
 |   |                                                                        
 |   |-PERSON.CAT              Personnel information for the PDS catalog      
 |   |                         (Team and PDS personnel responsible for        
 |   |                         generating the archive).                       
 |   |                                                                        
 |   |-REF.CAT                 References mentioned in other *.CAT files.     
 |   |                                                                        
 |   |-RELEASE.CAT             Catalog file for the different releases        
 |   |                                                                        
 |   |-TARGET.CAT              Catalog of targets                             
 |                                                                            
 |                                                                            
 |                                                                            
 |-[DATA]                      A directory containing VEX/VMC  instrument     
 |   |                         image data files with attached dual            
 |   |-[ORBIT NUMBER]          PDS/VICAR labels. Sub-divided orbit number     
 |                             directories.                                   
 |                                                                            
 |                                                                            
 |-[DOCUMENT]                  A directory that contains documentation        
 |   |                         to help the user understand and use the        
 |   |                         archive data.                                  
 |   |                                                                        
 |   |-DOCINFO.TXT             A description of the contents of this          
 |   |                         directory.                                     
 |   |                                                                        
 |   |-GEOMETRY_CUBE_DESC.LBL  The label for GEOMETRY_CUBE_DESC.TXT           
 |   |                                                                        
 |   |-GEOMETRY_CUBE_DESC.TXT  Description of the Geometry Cubes              
 |   |                                                                        
 |   |-INSTRUMENT_DESC.LBL     The label for the INSTRUMENT_DESC.TXT.         
 |   |                                                                        
 |   |-INSTRUMENT_DESC.TXT     Instrument description.                        
 |   |                                                                        
 |   |-OBSERVATION_TYPE_DESC.LBL    The label for the                         
 |   |                              OBSERVATION_TYPE_DESC.TXT.                
 |   |                                                                        
 |   |-OBSERVATION_TYPE_DESC.TXT    Description of the different observation  
 |   |                              types.                                    
 |   |                                                                        
 |   |-VEX_ORIENTATION_DESC.LBL     The label for the                         
 |   |                              VEX_ORIENTATION_DESC.TXT.                 
 |   |                                                                        
 |   |-VEX_ORIENTATION_DESC.TXT     Description of the VEX orientation modes. 
 |   |                                                                        
 |   |-VEX_POINTING_MODE_DESC.LBL   The label for the                         
 |   |                              VEX_POINTING_MODE_DESC.TXT.               
 |   |                                                                        
 |   |-VEX_POINTING_MODE_DESC.TXT   Description of the VEX pointing modes.    
 |   |                                                                        
 |   |-VEX_SCIENCE_CASE_ID_DESC.LBL The label for the                         
 |   |                              VEX_SCIENCE_CASE_ID_DESC.TXT.             
 |   |                                                                        
 |   |-VEX_SCIENCE_CASE_ID_DESC.TXT Description of the VEX science cases.     
 |   |                                                                        
 |   |-VICAR2.LBL                   The label for the VICAR2.TXT.             
 |   |                                                                        
 |   |-VICAR2.TXT                   Description of the VICAR label.           
 |   |                                                                        
 |   |-VMC_ANOMALOUS_FEATURES.LBL   The label for the                         
 |   |                              VMC_ANOMALOUS_FEATURES_REPORT.PDF         
 |   |                                                                        
 |   |-VMC_ANOMALOUS_FEATURES.PDF   Description of the VMC anomalous          
 |   |                              feautures.                                
 |   |                                                                        
 |   |-VMC_CALIBRATION_REPORT.LBL   The label for the                         
 |   |                              VMC_CALIBRATION_REPORT.PDF                
 |   |                                                                        
 |   |-VMC_CALIBRATION_REPORT.PDF   VMC calibration report                    
 |   |                                                                        
 |   |-VMC_COMMISiSIONING_REPORT.LBL  The label for the                       
 |   |                              VMC_COMMISSIONING_REPORT.PDF              
 |   |                                                                        
 |   |-VMC_COMMISiSIONING_REPORT.PDF  VMC Commissioning report                
 |   |                                                                        
 |   |-VMC_EAICD.LBL           The label for the Experimenter to Archive ICD. 
 |   |                                                                        
 |   |-VMC_EAICD.PDF           The Adobe PDF file of the experimenter to      
 |   |                         Archive ICD                                    
 |   |                                                                        
 |   |-VMC_EAICD.TXT            The ASCII version of the experimenter to      
 |   |                          Archive ICD                                   
 |   |                                                                        
 |   |-VMC_ESA_SP.LBL          The label for the VMC  Instrument Description  
 |   |                         published in the ESA SP-1295                   
 |   |                                                                        
 |   |-VMC_ESA_SP.PDF          The Adobe PDF file of the ESA SP-1295          
 |   |                                                                        
 |   |-VMC_LABEL.LBL           The label for VMC_LABEL.PDF                    
 |   |                                                                        
 |   |-VMC_LABEL.PDF           Description of the keywords in the PDS label.  
 |   |                                                                        
 |   |-VMC_NATURE.PDF          VMC Nature article summarizing the first       
 |   |                         scientific results.                            
 |   |                                                                        
 |   |-VMC_NATURE.LBL          The label for VMC_NATURE.PDF                   
 |                                                                            
 |                                                                            
 |-ERRATA.TXT                  Optional file summarizing the known errors.    
 |                                                                            
 |                                                                            
 |-[GEOMETRY]                  A directory containing Geometry Cubes for each 
 |   |                         image in the DATA directory with attached dual 
 |   |-[ORBIT NUMBER]          PDS/VICAR labels. Sub-divided orbit number     
 |                             directories.                                   
 |                                                                            
 |                                                                            
 |-[INDEX]                     A directory containing index files which       
 |   |                         describe products published so far or on       
 |   |                         this volume.                                   
 |   |                                                                        
 |   |-BROWSE_INDEX.LBL        A PDS detached label that describes            
 |   |                         BROWSE_INDEX.TAB                               
 |   |                                                                        
 |   |-BROWSE_INDEX.TAB        A table listing all browse files on this       
 |   |                         volume.                                        
 |   |                                                                        
 |   |-GEO_VENUS.LBL           A PDS detached label that describes            
 |   |                         GEO_VENUS.TAB                                  
 |   |                                                                        
 |   |-GEO_VENUS.TAB           The geometrical index file                     
 |   |                                                                        
 |   |-INDEX.LBL               A PDS detached label that describes            
 |   |                         INDEX.TAB.                                     
 |   |                                                                        
 |   |-INDEX.TAB               A table listing all data products on this      
 |   |                         volume.                                        
 |   |                                                                        
 |   |-INDEXINFO.TXT           A description of the contents of this          
 |                             directory.                                     
 |                                                                            
 |                                                                            
 |-VOLDESC.CAT                 Volume Desription file                         
                                                                              
                                                                              
5. Recommended CD-ROM Drives and Driver Software                              
                                                                              
This section is not applicable since the data are stored only electronically. 
                                                                              
                                                                              
6. Errata and Disclaimer                                                      
                                                                              
A cumulative list of anomalies and errors will be maintained in the file      
ERRATA.TXT at the root directory of this volume. This file will not be        
available if no errors are known.                                             
Although considerable care has gone into making this volume, errors are       
both possible and likely.                                                     
Users of the data are advised to exercise the same caution as they would      
when dealing with any other unknown data set.                                 
Reports of errors or difficulties would be appreciated. Please contact        
one of the persons listed herein.                                             
                                                                              
                                                                              
7. Whom to Contact for Information                                            
                                                                              
Planteray Science Archive Help desk                                           
email: psahelp@rssd.esa.int                                                   
                                                                              
