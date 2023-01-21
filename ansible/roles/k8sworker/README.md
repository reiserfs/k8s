Role Name
=========

Deploy docker, kubeadm, kubelet, kubectl on Linux and setup a Workers nodes for a K8s cluster

Requirements
------------

A RHEL Linux Operating System.

Example Playbook
----------------

    - hosts: workers
      roles:
         - { role: k8sworker }

License
-------

BSD

Author Information
------------------

Thiago Melo - 2022
https://github.com/reiserfs/k8s
