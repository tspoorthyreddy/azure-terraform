module "rgroup-N01580452" {
  source   = "./modules/rgroup-N01580452"
  rg-name  = "N01580452-RG"
  location = "canadacentral"
  common_tags = local.common_tags
}
module "network-N01580452"{
  source                        = "./modules/network-N01580452"
  rg-name                       = module.rgroup-N01580452.network-rg-name
  location                      = module.rgroup-N01580452.network-rg-location
  depends_on                    = [module.rgroup-N01580452]
  vnet-name                     = "N01580452-vnet"
  vnet-space                    = ["10.0.0.0/16"]
  subnet-name1                  = "N01580452-subnet"
  subnet1-address-space         = ["10.0.1.0/24"]
  security-group1               = "N01580452-sg"
}
module "common-N01580452" {
  source                        = "./modules/common-N01580452"
  la_name                       = "N01580452-la"
  storage_account_name          = "strn01580452"
  rg-name                       = module.rgroup-N01580452.network-rg-name
  location                      = module.rgroup-N01580452.network-rg-location
  subnet_id                     = module.network-N01580452.azurerm_subnet_name
  depends_on                    = [
                                   module.rgroup-N01580452
                                  ]
  common_tags                   = local.common_tags
}
module "vmlinux-N01580452" {
  source                         = "./modules/vmlinux-N01580452"
  nb_count                       = 3
  linux_vm_name                  = "linux-vmN01580452"
  rg_name                        = module.rgroup-N01580452.network-rg-name
  location                       = module.rgroup-N01580452.network-rg-location
  subnet_id                      = module.network-N01580452.azurerm_subnet_name
  depends_on = [
    module.rgroup-N01580452,
    module.network-N01580452,
    module.common-N01580452
  ]
  admin-username                  = "Babanjot-N01580452"
  storage_account_name            = module.common-N01580452.storage_account_name.name
  storage_account_key             = module.common-N01580452.storage_account_key
  storage_act                     = module.common-N01580452.storage_account_name
  common_tags                     = local.common_tags
}
module "vmwindows-N01580452" {
  source                          = "./modules/vmwindows-N01580452"
  windows_vm_name                 = "vmwin-n01580452"
  windows_username                = "Babanjot-N01580452"
  windows_password                = "WindowsP@ssw0rd"  
  rg_name                         = module.rgroup-N01580452.network-rg-name
  location                        = module.rgroup-N01580452.network-rg-location
  subnet_id                       = module.network-N01580452.azurerm_subnet_name
  depends_on                      = [module.common-N01580452, module.network-N01580452, module.rgroup-N01580452]
  storage_account_name            = module.common-N01580452.storage_account_name
  common_tags                     = local.common_tags
}           
module "datadisk-N01580452" {
  source                          = "./modules/datadisk-N01580452"
  linux-vm-ids                    = module.vmlinux-N01580452.linux-vm-ids
  windows_vm_id                   = module.vmwindows-N01580452.windows_vm_id
  location                        = module.rgroup-N01580452.network-rg-location
  rg_name                         = module.rgroup-N01580452.network-rg-name
  depends_on                      = [module.rgroup-N01580452, module.vmwindows-N01580452, module.vmlinux-N01580452]
  disk_size_gb                    = 20
  common_tags                     = local.common_tags
}
module "loadbalancer-N01580452" {
  source                          = "./modules/loadbalancer-N01580452"
  lb_name                         = "lb-n01580452"
  lb_ip_name                      = "lbpip-n01580452"
  rg_name                         = module.rgroup-N01580452.network-rg-name
  location                        = module.rgroup-N01580452.network-rg-location
  vm_public_ip                    = module.vmlinux-N01580452.linux-vm-public-ip
  linux-nic-id                    = module.vmlinux-N01580452.nic_id[0]
  nb_count                        = "3"
  linux_vm_name                   = module.vmlinux-N01580452.linux-vm-hostname
  subnet_id                       = module.network-N01580452.azurerm_subnet_name
  depends_on = [
    module.rgroup-N01580452,
    module.vmlinux-N01580452,
  ]
  common_tags                     = local.common_tags
}
module "database-N01580452" {
  source                          = "./modules/database-N01580452"
  db_name                         = "n01580452-db"
  server_name                     = "db-n01580452"
  db_username                     = "psqluser"
  db_pass                         = "psql@12345"
  rg_name                         = module.rgroup-N01580452.network-rg-name
  location                        = module.rgroup-N01580452.network-rg-location
  depends_on = [
    module.rgroup-N01580452
  ]
  common_tags                     = local.common_tags
}