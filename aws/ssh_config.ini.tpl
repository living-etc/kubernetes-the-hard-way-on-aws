%{ for worker in workers ~}
Host ${worker.name}
  User ubuntu
  Hostname ${worker.ip}
  IdentityFile ssh/id_rsa
  StrictHostKeyChecking no

%{ endfor ~}
%{ for controller in controllers ~}
Host ${controller.name}
  User ubuntu
  Hostname ${controller.ip}
  IdentityFile ssh/id_rsa
  StrictHostKeyChecking no

%{ endfor ~}
