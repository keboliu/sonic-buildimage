#!/bin/sh
set -e

sign_image_prod()
{
  UNSIGNED_IMG=$1
  OUT_CMS_SIGNATURE=$2
  echo "secure upgrade remote signing START"
  echo "sign_image_prod params: UNSIGNED_IMG=$UNSIGNED_IMG, OUT_CMS_SIGNATURE=$OUT_CMS_SIGNATURE, SECURE_MODE_FLAG=$SECURE_MODE_FLAG"

  if [ ! -f "${UNSIGNED_IMG}" ]; then
      echo "ERROR: UNSIGNED_IMG=${UNSIGNED_IMG} file does not exist"
      exit 1
  fi

  if [ -z ${OUT_CMS_SIGNATURE} ]; then
      echo "ERROR: OUT_CMS_SIGNATURE=${OUT_CMS_SIGNATURE} is empty"
      exit 1
  fi



  : "${SECURE_MODE_FLAG:=prod}"
  if [[ $SECURE_MODE_FLAG != "staging" && $SECURE_MODE_FLAG != "prod" ]]; then
      echo "ERROR: SECURE_MODE_FLAG=${SECURE_MODE_FLAG} is incorrect, should be prod or staging"
      print_usage
      exit 1
  fi
  if [[ $SECURE_MODE_FLAG == "prod" ]]; then
      SIGN_FLAG="--prod"
  fi

  SERVER_SIGN_SCRIPT=/opt/nvidia/sonic_sign.sh
  # signing with prod server
  ${SERVER_SIGN_SCRIPT} --file ${UNSIGNED_IMG} \
                      --type CMS $SIGN_FLAG \
                      --description 'CMS Signing NVOS IMG' \
                      --out-file ${OUT_CMS_SIGNATURE} || exit $? ;
  echo "secure upgrade remote signing DONE"
}
