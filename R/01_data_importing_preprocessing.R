# IMPORT FILES FROM THE WORKING DIRECTORY
library(hyperSpec)
library(readr)
# DEFINE THE IMPORT FUNCTION
scan.txt.BWtek <- function (files = "*.txt", ..., label = list ()) {
  label <- modifyList (list (.wavelength =
                               expression(paste("Raman shift (cm^-1)",sep = "")),
                             spc = "Intensity (a.u)"),label)
  
  # FIND THE FILES
  files <- Sys.glob (files)
  if (length (files) == 0){
    warning ("No files found.")
    return (new ("hyperSpec"))
  }
  
  # READ THE FIRST FILE
  mydf <- read.table(files[1], sep=";", dec=",", skip=89)
  mydf<- mydf[,c(4,8)]
  
  # THE FIRST COLUMN DEFINES THE WAVELENGTH VECTOR
  wavelength <- mydf [, 1]
  
  # PREALLOCATE THE SPECTRA MATRIX
  # ONE ROW PER FILE, WITH AS MANY COLUMNS AS THE FIRST FILE HAS ROWS
  spc <- matrix (ncol = nrow (mydf), nrow = length (files))
  
  # THE DATA FROM THE FIRST FILE GOES INTO THE FIRST ROW
  spc [1, ] <- mydf [, 2]
  
  # READ THE REMAINING FILES
  for (f in seq_along(files[-1])) {
    mydf <- read.table(files[f], sep=";", dec=",", skip=89)
    mydf<- mydf[,c(4,8)]
    spc [f, ] <- mydf[, 2]
  }
  
  # GENERATE THE HYPERSPEC OBJECT
  new ("hyperSpec", wavelength = wavelength, spc = spc,
       label = label)
}

# GET THE FILE NAME
spectra_files <- list.files(pattern = "\\.txt", recursive = T)
# IMPORT THE DATA
spc <- lapply (spectra_files, scan.txt.BWtek)
spc <- collapse (spc)
spc$file <- spectra_files


# GET METADATA FROM THE FILE NAMES
meta <- strsplit(spc$file, "_")
# ASSIGN THE METADATA NAMES
spc$spect <- sapply(meta, "[[",1)
spc$rep<- sapply(meta, "[[",2)
spc$met<- sapply(meta,"[[",3)
spc$substr<- sapply(meta,"[[",4)
spc$npconc<- sapply(meta,"[[",5)
spc$ratio<- sapply(meta,"[[",6)
spc$laspw<- sapply(meta,"[[",7)
spc$timeesp<- sapply(meta,"[[",8)
spc$nacc<- sapply(meta,"[[",9)
spc$API<- sapply(meta,"[[",10)
spc$conc<- sapply(meta,"[[",11)
spc$solv<- sapply(meta,"[[",12)
spc$pbs<- sapply(meta,"[[",13)  
spc$ph<- sapply(meta,"[[",14)
spc$date<- sapply(meta,"[[",15)
spc$salt<- sapply(meta,"[[",16)
spc$saltconc<- sapply(meta,"[[",17)
# GENERATE THE BASELINE AND PERFORM SMOOTHING
library(baseline)
spc<- spc.loess(spc, c(seq(350,1800,3)))
bl<- baseline(spc[[]], method="als", lambda=4, p=0.005, maxit=100)
spc[[]]<-getCorrected(bl)
# EXTRACT THE BASELINE DATA FROM THE bl OBJECT
baseline<- getBaseline(bl)

##OPTIONAL: VECTOR NORMALIZATION
factor <- apply (spc, 1,function(x){sqrt(sum(x^2))})
spc <- sweep (spc, 1, factor, "/")
