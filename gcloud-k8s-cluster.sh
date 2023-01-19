gcloud config set project k8s-training-375110
gcloud config set compute/zone europe-west9-a
gcloud compute networks create k8s-cluster --subnet-mode custom
gcloud compute networks subnets create k8s-nodes --network k8s-cluster --range 192.168.87.0/24
gcloud compute firewall-rules create k8s-cluster-allow-internal --allow tcp,udp,icmp,ipip --network k8s-cluster --source-ranges 192.168.87.0/24
gcloud compute firewall-rules create k8s-cluster-allow-external --allow tcp:22,tcp:6443,icmp --network k8s-cluster --source-ranges 0.0.0.0/0

gcloud compute instances create master-node \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family rocky-linux-8-optimized-gcp \
    --image-project rocky-linux-cloud \
    --machine-type e2-medium \
    --private-network-ip 192.168.87.10 \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet k8s-nodes \
    --zone europe-west9-a  \
    --tags k8s-cluster,master-node,controller

    for i in 1 2; do
      gcloud compute instances create workernode-${i} \
        --async \
        --boot-disk-size 200GB \
        --can-ip-forward \
        --image-family rocky-linux-8-optimized-gcp \
        --image-project rocky-linux-cloud \
        --machine-type e2-medium \
        --private-network-ip 192.168.87.1${i} \
        --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
        --subnet k8s-nodes \
        --zone europe-west9-a  \
        --tags k8s-cluster,worker
    done

#on master
dnf update -y
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
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce -y
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
containerd config default > /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl enable --now containerd.service
dnf install -y {kubelet,kubeadm,kubectl} --disableexcludes=kubernetes
systemctl enable --now kubelet.service
dnf install -y iproute-tc
modprobe br_netfilter
echo '1' > /proc/sys/net/ipv4/ip_forward
kubeadm init --pod-network-cidr=192.168.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl get pods -o wide

#on workers
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
kubeadm join MASTER_IP:PORT --token TOKEN  --discovery-token-ca-cert-hash sha256:HASH


#join output
kubeadm join 192.168.87.10:6443 --token ftxsjl.eu8xynikzomt40ce --discovery-token-ca-cert-hash sha256:2b421b8f13f49ddcce45124c80bb8fb11b973facbf14bf0ef7bb8d29f25402ef
