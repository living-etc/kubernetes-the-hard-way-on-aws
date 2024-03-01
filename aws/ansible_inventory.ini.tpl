[workers]
%{ for worker in workers ~}
${worker.name} ansible_host=${worker.ip}
%{ endfor ~}

[controllers]
%{ for controller in controllers ~}
${controller.name} ansible_host=${controller.ip}
%{ endfor ~}
