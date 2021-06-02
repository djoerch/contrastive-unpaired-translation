#!/usr/bin/env bash

PATH_TO_RESULTS_ROOT="/mnt/data/daniel/CUT/results_cross_eval"
PATH_TO_DATASETS_ROOT="/mnt/data/daniel/2d_gan_datasets"

path_to_exp_results="${PATH_TO_RESULTS_ROOT}/mv_coronal_512/mv_base_cut_LR2HS_mv_axial_512_lsgan"
path_to_dataset="${PATH_TO_DATASETS_ROOT}/mv_coronal_512"

img_plane="coronal"


# restack images
for folder in "real_A" "real_B" "fake_B"
do
    cmd="episr_png_to_subjects.py"
    args=()
    args+=(-i "${path_to_exp_results}/test_latest/images/${folder}")
    args+=(-o "${path_to_exp_results}/test_latest/images")
    args+=(-c "${path_to_dataset}/test/datasetinfo.json")
    args+=(-t "multi_view")
    args+=(--basename "${img_plane}_${folder}")
    ${cmd} ${args[@]}
done


# segment images

# 2D_512
for folder in "real_A"  # NOTE: this is for direction LR2HS, i.e. LR: A, HR: B.
do
    cmd="episr_compute_seg_metrics_for_dataset.sh"
    args=()
    args+=("${path_to_exp_results}/test_latest/images/highres_${img_plane}_${img_plane}")
    args+=("${path_to_exp_results}/test_latest/images/highres_${img_plane}_${img_plane}")
    args+=("${folder}")
    args+=("2D_512")
    args+=("/opt/temp/normalised_6")
    ${cmd} ${args[@]}
done

# 2.5D
for folder in "real_B" "fake_B"
do
    cmd="episr_compute_seg_metrics_for_dataset.sh"
    args=()
    args+=("${path_to_exp_results}/test_latest/images/highres_${img_plane}_${img_plane}")
    args+=("${path_to_exp_results}/test_latest/images/highres_${img_plane}_${img_plane}")
    args+=("${folder}")
    args+=("25D")
    args+=("/opt/temp/normalised_6")
    ${cmd} ${args[@]}
done
