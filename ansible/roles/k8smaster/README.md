Role Name
=========

Deploy docker, kubeadm, kubelet, kubectl on Linux and setup a master node for a K8s cluster

Requirements
------------

A RHEL Linux Operating System.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: master
      roles:
         - { role: k8smaster }

License
-------

BSD

Author Information
------------------

Thiago Melo - 2022
https://github.com/reiserfs/k8s
