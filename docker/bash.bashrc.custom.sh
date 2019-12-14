alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

complete -C /usr/local/bin/aws_completer aws

function _ps1_aws_profile() {
  if [ -n "${AWS_PROFILE}" ]; then
    echo "AWS:${AWS_PROFILE} "
  fi
}

# aws profile in PS1
PS1="\$(_ps1_aws_profile)${PS1}"
