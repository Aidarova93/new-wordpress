resource "azurerm_lb" "Team2" {
  name                = "Team2-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.Team2.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.Team2.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "Team2" {
  loadbalancer_id = azurerm_lb.Team2.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "Team2" {
  resource_group_name = azurerm_resource_group.Team2.name
  loadbalancer_id     = azurerm_lb.Team2.id
  name                = "ssh-running-probe"
  port                = var.application_port
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name            = azurerm_resource_group.Team2.name
  loadbalancer_id                = azurerm_lb.Team2.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.application_port
  backend_port                   = var.application_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.Team2.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.Team2.id
}

resource "azurerm_linux_virtual_machine_scale_set" "Team2" {
  name                            = "vmscaleset"
  location                        = var.location
  resource_group_name             = azurerm_resource_group.Team2.name
  sku                             = "Standard_D2S_v3"
  instances                       = 2
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  custom_data = "IyEvYmluL2Jhc2gKc3VkbyB5dW0gaW5zdGFsbCBodHRwZCB3Z2V0IHVuemlwIGVwZWwtcmVsZWFzZSBteXNxbCAteQpzdWRvIHl1bSAteSBpbnN0YWxsIGh0dHA6Ly9ycG1zLnJlbWlyZXBvLm5ldC9lbnRlcnByaXNlL3JlbWktcmVsZWFzZS03LnJwbQpzdWRvIHl1bSAteSBpbnN0YWxsIHl1bS11dGlscwpzdWRvIHl1bS1jb25maWctbWFuYWdlciAtLWVuYWJsZSByZW1pLXBocDU2ICAgW0luc3RhbGwgUEhQIDUuNl0Kc3VkbyB5dW0gLXkgaW5zdGFsbCBwaHAgcGhwLW1jcnlwdCBwaHAtY2xpIHBocC1nZCBwaHAtY3VybCBwaHAtbXlzcWwgcGhwLWxkYXAgcGhwLXppcCBwaHAtZmlsZWluZm8Kc3VkbyB3Z2V0IGh0dHBzOi8vd29yZHByZXNzLm9yZy9sYXRlc3QudGFyLmd6CnN1ZG8gdGFyIC14ZiBsYXRlc3QudGFyLmd6IC1DIC92YXIvd3d3L2h0bWwvCnN1ZG8gbXYgL3Zhci93d3cvaHRtbC93b3JkcHJlc3MvKiAvdmFyL3d3dy9odG1sLwpzdWRvIGdldGVuZm9yY2UKc3VkbyBzZWQgJ3MvU0VMSU5VWD1wZXJtaXNzaXZlL1NFTElOVVg9ZW5mb3JjaW5nL2cnIC9ldGMvc3lzY29uZmlnL3NlbGludXggLWkKc3VkbyBzZXRlbmZvcmNlIDAKc3VkbyBjaG93biAtUiBhcGFjaGU6YXBhY2hlIC92YXIvd3d3L2h0bWwvCnN1ZG8gc3lzdGVtY3RsIHN0YXJ0IGh0dHBkCnN1ZG8gc3lzdGVtY3RsIGVuYWJsZSBodHRwZAoKCnN1ZG8gZXhwb3J0IFdPUkRQUkVTU19EQl9IT1NUPW15c3Fsc2VydmVyLSR7KHJhbmRvbV9zdHJpbmcuZnFkbi5yZXN1bHQpfS5teXNxbC5kYXRhYmFzZS5henVyZS5jb20Kc3VkbyBleHBvcnQgV09SRFBSRVNTX0RCX1VTRVI9d29yZHByZXNzCnN1ZG8gZXhwb3J0IFdPUkRQUkVTU19EQl9QQVNTV09SRD1XMHJkcHIzc3NAcDRzcwpzdWRvIGV4cG9ydCBXT1JEUFJFU1NfREJfTkFNRT13b3JkcHJlc3MK"
 source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "NetworkInterface"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = azurerm_subnet.Team2.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.Team2.id]
      primary                                = true
    }
  }

  tags = var.tags
}

# data "template_file" "script" {
#   # template = filebase64("/home/ec2-user/Team2-azure-terraform-T3/Team2.sh")
#   template = file("Team2.conf")
# }

# data "template_cloudinit_config" "config" {
#   gzip          = true
#   base64_encode = true

#   part {
#     # filename     = "Team2.sh"
#     filename     = "Team2.conf"
#     content_type = "text/cloud-config"
#     content      = data.template_file.script.rendered
#   }

#   depends_on = [azurerm_mysql_server.Team2]
# }
