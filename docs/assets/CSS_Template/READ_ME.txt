###################################################################
# CSS Templates
# Jake S. Truscott
# Updated April 2026
###################################################################


###################################################################
# CSS_Template.Rproj
###################################################################

CSS_Template.Rproj is going to serve as your primary project file. 
Open this and it will automatically set all the necessary relative 
paths and serve as central compiler. 

###################################################################
# Main Folders
###################################################################

The two main folders are beamer_files and manuscript_files. As you can 
probably infer, beamer_files are files to render the slideshow presentation, 
while manuscript_files are for paper submissions. I have provided some sample
language in these documents as a guide, though feel free to shoot me an email if you
have any questions or concerns (jaketruscott@ufl.edu). 

*Note* In both the manuscript and beamer samples, there is header material
in the preamble where you would include your title and name. I would highly
recommend *against* changing anything related to header-include or related. 

###################################################################
# Subfolders
###################################################################

#####################################
# references
#####################################

Inside the manuscript_files subfolder is a references.bib file, which you can use 
to automatically render and structure your references pages. Additional information is provided
inside the manuscript.rmd document. 

#####################################
# Style
#####################################

The style files are the packages, functions, and definitions to render
the .RMD files using latex (beamer). I would highly recommend *against* 
altering those files in any way. 

#####################################
# Figures and Images
#####################################

These can serve as repository folders for images and analysis-derived figures. I 
have gone ahead and provided some sample language in the manuscript document for how to 
render these images (if necessary) from their relative folder path. 