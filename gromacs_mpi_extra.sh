#!/bin/bash


OUT_DIR=$1
if [ -z "$OUT_DIR" ]; then
    OUT_DIR=".."
fi

OUT_FILE=${OUT_DIR}/gromacs_mpi_extra_mi100.txt

# Support execution from outside root dir
_CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
cd $_CWD

cd eag1/

# 4GPU
echo "benchmark,eag,gpus_4,rank_4,thread_4" | tee -a ${OUT_FILE}
mpirun --allow-run-as-root -np 4 gmx_mpi mdrun -v -s topol.tpr -nsteps 30000 -maxh 1.0 -resethway -noconfout -ntomp 4 -gpu_id 0123 -nb gpu -bonded gpu -update cpu -pme cpu -nstlist 100 -tunepme yes -dlb auto 2>&1 | tee -a ${OUT_FILE}

# 4GPU
echo "benchmark,aqp_ensemble,gpus_4,rank_8,thread_8" | tee -a ${OUT_FILE}
mpirun --allow-run-as-root -np 8 gmx_mpi mdrun -v -s topol.tpr -nsteps 30000 -maxh 1.0 -resethway -noconfout -ntomp 8 -gpu_id 0123 -nb gpu -bonded gpu -update cpu -pme cpu -nstlist 100 -tunepme yes -dlb auto 2>&1 | tee -a ${OUT_FILE}

cd ..
cd aqp_ensemble/
mkdir results-1
mkdir results-2
mkdir results-3
mkdir results-4
mkdir results-5
mkdir results-6
mkdir results-7
mkdir results-8
cp topol.tpr results-1/topol.tpr
cp topol.tpr results-2/topol.tpr
cp topol.tpr results-3/topol.tpr
cp topol.tpr results-4/topol.tpr
cp topol.tpr results-5/topol.tpr
cp topol.tpr results-6/topol.tpr
cp topol.tpr results-7/topol.tpr
cp topol.tpr results-8/topol.tpr
# 4GPU
echo "benchmark,aqp_ensemble,gpus_4,rank_4,thread_4" | tee -a ${OUT_FILE}
mpirun --allow-run-as-root -np 4 gmx_mpi mdrun -v -stepout 5000 -multidir results-1 results-2 results-3 results-4 -nsteps 100000 -maxh 1.0 -resethway -noconfout -ntomp 4 -gpu_id 0123 -nb gpu -bonded gpu -update gpu -pme gpu -dlb no -tunepme no -pin off 2>&1 | tee -a ${OUT_FILE}

# 4GPU
echo "benchmark,aqp_ensemble,gpus_4,rank_8,thread_4" | tee -a ${OUT_FILE}
mpirun --allow-run-as-root -np 8 gmx_mpi mdrun -v -stepout 5000 -multidir results-1 results-2 results-3 results-4 results-5 results-6 results-7 results-8 -nsteps 100000 -maxh 1.0 -resethway -noconfout -ntomp 8 -gpu_id 0123 -nb gpu -bonded gpu -update gpu -pme gpu -dlb no -tunepme no -pin off 2>&1 | tee -a ${OUT_FILE}

# 6GPU
# echo "benchmark,aqp_ensemble,gpus_6,rank_1,thread_64" | tee -a ${OUT_FILE}
# mpirun --allow-run-as-root -np 6 gmx_mpi mdrun -v -stepout 5000 -multidir results-1 results-2 results-3 results-4 results-5 results-6 -nsteps 100000 -maxh 1.0 -resethway -noconfout -ntomp 6 -gpu_id 012345 -nb gpu -bonded gpu -update gpu -pme gpu -dlb no -tunepme no -pin off 2>&1 | tee -a ${OUT_FILE}
