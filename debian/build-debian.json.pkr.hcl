variable "iso_url" {
  type    = string
}

variable "iso_checksum" {
  type    = string
}

variable "vm_name" {
  type    = string
}

variable "ssh_name" {
  type    = string
  default = "vagrant"
}

variable "ssh_pass" {
  type    = string
  default = "vagrant"
}

source "qemu" "qemu" {
  iso_url           = var.iso_url
  iso_checksum      = var.iso_checksum
  output_directory  = "output/packer"
  shutdown_command  = "echo '${var.ssh_pass}' | sudo -E -S poweroff"
  disk_size         = "10240M"
  format            = "qcow2"
  accelerator       = "kvm"
  http_directory    = "./preseeds"
  ssh_username      = var.ssh_name
  ssh_password      = var.ssh_pass
  ssh_timeout       = "20m"
  vm_name           = var.vm_name
  net_device        = "virtio-net"
  disk_interface    = "virtio-scsi"
  boot_wait         = "10s"
  boot_command      = ["<esc><wait1s>", "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian-preseed.cfg", "<enter>"]
}

build {
  sources = ["source.qemu.qemu"]

  post-processor "vagrant" {
    keep_input_artifact = true
    provider_override   = "libvirt"
    compression_level   = 9
    output              = "./output/${var.vm_name}.box"
  }
}
