#!/bin/bash
#$ -cwd -l mem=4g,time=8:00:00 -S /bin/bash -N JOBNAME -j y -t 1:1000

currind=${SGE_TASK_ID}

R=/nfs/apps/R/3.1.1/bin/Rscript
R_LIBS_USER=ifs/home/msph/biostat/zc2326/R_LIB:/ifs/scratch/msph/software/R/library311:/ifs/scratch/msph/software/R/library:$R_LIBS_USER

${R} --vanilla crm_array.R  ${currind}

