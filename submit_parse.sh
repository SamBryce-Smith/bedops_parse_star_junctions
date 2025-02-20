#!/bin/bash
#Submit to the cluster, give it a unique name
#$ -S /bin/bash

#$ -cwd
#$ -V
#$ -l h_vmem=1.9G,h_rt=72:00:00,tmem=1.9G


# join stdout and stderr output
#$ -j y
#$ -sync y

if [ "$1" != "" ]; then
    RUN_NAME=$1
else
    RUN_NAME="run"
fi

FOLDER=submissions/$(date +"%Y%m%d%H%M")
mkdir -p ${FOLDER}


snakemake -s parse_star_junctions.smk \
--use-conda \
--jobscript cluster_qsub.sh \
--cluster-config cluster.yaml \
--cluster-sync "qsub -l tmem={cluster.tmem},h_vmem={cluster.h_vmem},h_rt={cluster.h_rt} -o $FOLDER {cluster.submission_string}" \
-j 15 \
--group-components prep_sample_beds=10 get_aggregate_bed=10 \
--nolock \
--rerun-incomplete \
--latency-wait 100
