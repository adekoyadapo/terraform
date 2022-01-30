#!/bin/bash
############################################################
# Help                                                     #
############################################################
show_help()
{
   # Display Help
   echo "Usage: $0 [-a|--action] [-e|--env]"
   echo "options:"
   echo "-a|--action [apply|destroy]     Terraform action to perform "
   echo "-e|--env    [dev|staging|prod]  Environment to deploy to."
}

TerrafromApply () {
  if [[ $1 == "Development" ]]; then
      $1=dev
    elif [[ $1 == "Staging" ]]; then
      $1=staging
    elif [[ $1 == "Production" ]]; then
      $1=prod
      echo  "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
      echo  "CAUTION !!!! THIS IS PRODUCTION ENVIRONMENT, ENSURE ALL CONFIGURATIONS ARE VALIDATED !!!";
      echo  "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
  fi; 
  terraform init;
  echo "Changing to $1 workspace";
  echo "-----------------------------";
  terraform workspace select $1 ;
  terraform plan -var-file=./tfvars/config-$1.tfvars ;
  echo;
  while true; do
     read -p "Do you wish to apply this plan (yes or no)? " yn
     case $yn in
         [Yy]* ) terraform apply -auto-approve -var-file=./tfvars/config-$1.tfvars; break;;
         [Nn]* ) exit;;
         * ) echo "Please answer yes or no.";;
     esac
  done
}

TerrafromDestroy () {
  if [[ $1 == "Development" ]]; then
      environment=dev
    elif [[ $1 == "Staging" ]]; then
      environment=staging
    elif [[ $1 == "Production" ]]; then
      env=prod
  fi; 
  terraform init;
  echo "Changing to $1 workspace";
  echo "--------------------------------";
  terraform workspace select $1 ;
  echo;
  while true; do
    echo "Removing all deployed infrastructure"
    echo  "CAUTION !!!! THIS IS A DESTRUCTIVE ACTION !!!";
    echo;
    read -p "Do you wish to continue (yes or no)? " yn
     case $yn in
         [Yy]* ) terraform destroy -auto-approve -var-file=./tfvars/config-$1.tfvars; break;;
         [Nn]* ) exit;;
         * ) echo "Please answer yes or no.";;
     esac
  done
} 
############################################################
############################################################
# Main program                                             #
############################################################
############################################################
ACTION=""
ENVIRONMENT=""    
usage() {                               
  echo "Usage: $0 [ -a ACTION ] [ -e ENVIRONMENT ]" 1>&2 
}
exit_abnormal() {
  usage
  exit 1
}
if [ $# -lt 2 ]; then
    show_help
    exit 1
  elif [ -z "$1" ] && [ -z "$2" ]; then
    show_help
    exit 1
fi

while getopts ":a:e:" options; do
  case "${options}" in                    
    a)
      ACTION=${OPTARG}
      ;;
    e)
      ENVIRONMENT=${OPTARG}
      re_isanum='^[a-z]+$'
      if ! [[ $ENVIRONMENT =~ $re_isanum ]] ; then
        echo "Error: Environment must be either dev|staging|prod"
        exit_abnormal
        exit 1
      elif ! [[ "$ENVIRONMENT" == "dev" || "$ENVIRONMENT" == "prod" || "$ENVIRONMENT" == "staging" ]] ; then
        echo "Error: Plesase enter an Environment either dev|staging|prod"
        exit_abnormal
      fi
      ;;
    :)
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal
      ;;
    *)
      exit_abnormal
      ;;
  esac
done
if [ "$ACTION" = "apply" ]; then
  TerrafromApply $ENVIRONMENT 
elif [ "$ACTION" = "destroy" ]; then 
  TerrafromDestroy $ENVIRONMENT
elif [ "$ACTION" != "destroy" ] || [ "$ACTION" != "apply" ] && [ -z $ENVIRONMENT ]; then                                      # Otherwise,
  show_help
fi
exit 0


#TerrafromDestroy Development
#TerrafromApply Development