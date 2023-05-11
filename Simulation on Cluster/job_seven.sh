#!/bin/bash
#$ -cwd -l mem=4g,time=00:10:00 -S /bin/bash -N JOBEX1 -j y -t 1:18

currind=${SGE_TASK_ID}

R=/nfs/apps/R/3.1.1/bin/Rscript
R_LIBS_USER=ifs/home/msph/LeeLab/zc2326/R_LIB:/ifs/scratch/msph/software/R/library311:/ifs/scratch/msph/software/R/library:$R_LIBS_USER

${R} --vanilla example1.R  ${currind}
