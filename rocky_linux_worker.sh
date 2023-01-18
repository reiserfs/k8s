yum update -y
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce -y
 swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
setenforce 0
 sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
dnf install vim wget curl -y
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl enable --now containerd.service
 systemctl status containerd.service
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

dnf install -y {kubelet,kubeadm,kubectl} --disableexcludes=kubernetes
modprobe br_netfilter
 echo '1' > /proc/sys/net/ipv4/ip_forward
kubeadm join 167.172.47.108:6443 --token jp6x6p.bjm1pn70k5mm9yzw  --discovery-token-ca-cert-hash sha256:b38b5240a97d4aecb256cdd41766293b838172168c27c23f75b73ae47764a858
