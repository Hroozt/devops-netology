export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export TF_VAR_folder_id=$YC_FOLDER_ID
export AWS_ACCESS_KEY_ID=YCAJE6I4NA5ZHPXF0htWij2Qn
export AWS_SECRET_ACCESS_KEY=YCPa8TeCPuBEampbDz4E2YiDi6hpklAhpdNLMTUp