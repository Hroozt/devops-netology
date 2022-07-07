export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export TF_VAR_folder_id=$YC_FOLDER_ID
export AWS_ACCESS_KEY_ID=YCAJEKmZrk_TW35s1VJMP9m3b
export AWS_SECRET_ACCESS_KEY=YCMapBCwxcZ3MXmE6X0j0AIw1RzsSzvZItNI0EwH