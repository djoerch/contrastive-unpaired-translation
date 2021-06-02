#!/usr/bin/env bash

# -- DESC: this script contains various tested experiment calls. Instead of executing
#   this file as it is, it is rather thought of a documentation of the investigated
#   experiment settings.


# NOTE: Must contain subfolders 'trainA' and 'trainB'. The `dataset_mode` 'nifti'
#   expects each style folder to contain subject folders in the format of the
#   normalised nifti datasets (e.g. 'normalised_6'). The subject folders may be soft
#   links to the physical subject folders in order to save storage space.
#PATH_TO_DATAROOT="/home/daniel/novamia/mv_cycle_gan"


# folders in which all experiments have a checkpoint/results folder
PATH_TO_CHECKPOINTS_ROOT="/mnt/data/daniel/CUT/checkpoints"
PATH_TO_RESULTS_ROOT="/mnt/data/daniel/CUT/results"


cmd_train="python train.py"
cmd_test="python test.py"

common_args=()
common_args+=(--input_nc "1")
common_args+=(--output_nc "1")
common_args+=(--gpu_ids "0,1")
common_args+=(--batch_size "2")
common_args+=(--checkpoints_dir "${PATH_TO_CHECKPOINTS_ROOT}")
common_args+=(--dataset_mode "unaligned")

common_train_args=()
#common_train_args+=(--dataroot "${PATH_TO_DATAROOT}")
common_train_args+=(--pool_size "50")
common_train_args+=(--print_freq "1")
common_train_args+=(--display_freq "20")
common_train_args+=(--display_id "1")
common_train_args+=(--display_port "8078")

common_test_args=()
#common_test_args+=(--dataroot "${PATH_TO_DATAROOT}")
common_test_args+=(--results_dir "${PATH_TO_RESULTS_ROOT}")
common_test_args+=(--eval)
common_test_args+=(--num_test "3000")

continue_train_args=()
#continue_train_args+=(--continue_train)
#continue_train_args+=(--epoch "latest")
#continue_train_args+=(--epoch_count "101")  # this is for log output only


# ####
# EXPERIMENTS
# ####

# 1. ...
exp_args=()
exp_args+=(--name "mv_base_fastcut_HS2LC")
exp_args+=(--model "cut")
exp_args+=(--netG "resnet_9blocks")
exp_args+=(--netD "basic")
exp_args+=(--direction "AtoB")

exp_train_args=()
exp_train_args+=(--gan_mode "lsgan")
exp_train_args+=(--n_epochs "200")
exp_train_args+=(--n_epochs_decay "200")

#${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]}
#${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]}


# 2. ...
exp_args=()
exp_args+=(--name "mv_base_fastcut")
exp_args+=(--model "cut")
exp_args+=(--netG "resnet_9blocks")
exp_args+=(--netD "basic")
exp_args+=(--direction "BtoA")

exp_train_args=()
exp_train_args+=(--gan_mode "lsgan")
exp_train_args+=(--n_epochs "200")
exp_train_args+=(--n_epochs_decay "200")

#${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]}
#${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]}

# 3. ...
exp_args=()
exp_args+=(--name "mv_base_cut_LC2HS_wasserstein")
exp_args+=(--model "cut")
exp_args+=(--netG "resnet_9blocks")
exp_args+=(--netD "basic")
exp_args+=(--direction "BtoA")

exp_train_args=()
exp_train_args+=(--gan_mode "wgangp")
exp_train_args+=(--n_epochs "200")
exp_train_args+=(--n_epochs_decay "200")

#${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]}
#${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]}


# 4. ...
exp_args=()
exp_args+=(--name "mv_base_cut_LC2HS_vanilla")
exp_args+=(--model "cut")
exp_args+=(--netG "resnet_9blocks")
exp_args+=(--netD "basic")
exp_args+=(--direction "BtoA")

exp_train_args=()
exp_train_args+=(--gan_mode "vanilla")
exp_train_args+=(--n_epochs "200")
exp_train_args+=(--n_epochs_decay "200")

#${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]}
#${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]}

# 5. ...
exp_args=()
exp_args+=(--name "mv_base_cut_LC2HS_vanilla_serial")
exp_args+=(--model "cut")
exp_args+=(--netG "resnet_9blocks")
exp_args+=(--netD "basic")
exp_args+=(--direction "BtoA")

exp_train_args=()
exp_train_args+=(--gan_mode "vanilla")
exp_train_args+=(--n_epochs "200")
exp_train_args+=(--n_epochs_decay "200")
exp_train_args+=(--serial_batches)

#${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]}
#${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]}

# 6. ...
exp_args=()
exp_args+=(--name "mv_base_cut_LC2HS_vanilla_no_augm")
exp_args+=(--model "cut")
exp_args+=(--netG "resnet_9blocks")
exp_args+=(--netD "basic")
exp_args+=(--direction "BtoA")

exp_train_args=()
exp_train_args+=(--gan_mode "vanilla")
exp_train_args+=(--n_epochs "200")
exp_train_args+=(--n_epochs_decay "200")
exp_train_args+=(--preprocess "none")
exp_train_args+=(--no_flip)

#${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]}
#${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]}


###########################################

n_epochs="40"
n_epochs_decay="40"

load_size="416"
crop_size_train="386"  # NOTE: in training random crop
crop_size_test="${load_size}"  # NOTE: in testing no randomness

for dataset in "mv_coronal_512" "mv_axial_512" "mv_coronal_axial_512"
do

    for gan_mode in "vanilla" "lsgan" "wgangp"
    do

        # 7.a ...
        EXP_NAME="mv_base_cut_LR2HS_${dataset}_${gan_mode}"
        mkdir -p "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}"
        exp_args=()
        exp_args+=(--name "${EXP_NAME}")
        exp_args+=(--model "cut")
        exp_args+=(--netG "resnet_9blocks")
        exp_args+=(--netD "basic")
        exp_args+=(--direction "BtoA")
        exp_args+=(--dataroot "/mnt/data/daniel/2d_gan_datasets/${dataset}")
        exp_args+=(--load_size "${load_size}")

        exp_train_args=()
        exp_train_args+=(--crop_size "${crop_size_train}")
        exp_train_args+=(--gan_mode "${gan_mode}")
        exp_train_args+=(--n_epochs "${n_epochs}")
        exp_train_args+=(--n_epochs_decay "${n_epochs_decay}")

        exp_test_args=()
        exp_test_args+=(--crop_size "${crop_size_test}")

        #${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]} >> "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}/.log.txt"
        ${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]} ${exp_test_args[@]} >> "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}/.log_test.txt"

        # 7.b ...
        EXP_NAME="mv_base_cut_LR2HS_${dataset}_${gan_mode}_no_preproc"
        mkdir -p "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}"
        exp_args=()
        exp_args+=(--name "${EXP_NAME}")
        exp_args+=(--model "cut")
        exp_args+=(--netG "resnet_9blocks")
        exp_args+=(--netD "basic")
        exp_args+=(--direction "BtoA")
        exp_args+=(--dataroot "/mnt/data/daniel/2d_gan_datasets/${dataset}")
        exp_args+=(--load_size "${load_size}")

        exp_train_args=()
        exp_train_args+=(--crop_size "${crop_size_train}")
        exp_train_args+=(--gan_mode "${gan_mode}")
        exp_train_args+=(--n_epochs "${n_epochs}")
        exp_train_args+=(--n_epochs_decay "${n_epochs_decay}")
        exp_train_args+=(--preprocess "none")
        exp_train_args+=(--no_flip)

        exp_test_args=()
        exp_test_args+=(--crop_size "${crop_size_test}")

        #${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]} >> "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}/.log.txt"
        #${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]} ${exp_test_args[@]} >> "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}/.log_test.txt"

    done  # dataset

done  # gan_mode



for dataset in "mv_coronal_512" "mv_axial_512" "mv_coronal_axial_512"
do

    for gan_mode in "vanilla" "lsgan" "wgangp"
    do

        # 7.a ...
        EXP_NAME="mv_base_cut_HS2LR_${dataset}_${gan_mode}"
        mkdir -p "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}"
        exp_args=()
        exp_args+=(--name "${EXP_NAME}")
        exp_args+=(--model "cut")
        exp_args+=(--netG "resnet_9blocks")
        exp_args+=(--netD "basic")
        exp_args+=(--direction "AtoB")
        exp_args+=(--dataroot "/mnt/data/daniel/2d_gan_datasets/${dataset}")
        exp_args+=(--load_size "${load_size}")

        exp_train_args=()
        exp_train_args+=(--crop_size "${crop_size_train}")
        exp_train_args+=(--gan_mode "${gan_mode}")
        exp_train_args+=(--n_epochs "${n_epochs}")
        exp_train_args+=(--n_epochs_decay "${n_epochs_decay}")

        exp_test_args=()
        exp_test_args+=(--crop_size "${crop_size_test}")

        #${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]} >> "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}/.log.txt"
        ${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]} ${exp_test_args[@]} >> "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}/.log_test.txt"

        # 7.b ...
        EXP_NAME="mv_base_cut_HS2LR_${dataset}_${gan_mode}_no_preproc"
        mkdir -p "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}"
        exp_args=()
        exp_args+=(--name "${EXP_NAME}")
        exp_args+=(--model "cut")
        exp_args+=(--netG "resnet_9blocks")
        exp_args+=(--netD "basic")
        exp_args+=(--direction "AtoB")
        exp_args+=(--dataroot "/mnt/data/daniel/2d_gan_datasets/${dataset}")
        exp_args+=(--load_size "${load_size}")

        exp_train_args=()
        exp_train_args+=(--crop_size "${crop_size_train}")
        exp_train_args+=(--gan_mode "${gan_mode}")
        exp_train_args+=(--n_epochs "${n_epochs}")
        exp_train_args+=(--n_epochs_decay "${n_epochs_decay}")
        exp_train_args+=(--preprocess "none")
        exp_train_args+=(--no_flip)

        exp_test_args=()
        exp_test_args+=(--crop_size "${crop_size_test}")

        #${cmd_train} ${common_args[@]} ${common_train_args[@]} ${exp_args[@]} ${exp_train_args[@]} >> "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}/.log.txt"
        #${cmd_test} ${common_args[@]} ${common_test_args[@]} ${exp_args[@]} ${exp_test_args[@]} >> "${PATH_TO_RESULTS_ROOT}/${EXP_NAME}/.log_test.txt"

    done  # dataset

done  # gan_mode
