# Create MySQL Server
resource "azurerm_mysql_server" "Team2" {
  resource_group_name = azurerm_resource_group.Team2.name
  name                = "mysqlserver-${(random_string.qwer.result)}"
  location            = azurerm_resource_group.Team2.location
  version             = "5.7"

  administrator_login          = var.database_admin_login
  administrator_login_password = var.database_admin_password

  sku_name                     = "GP_Gen5_4"
  storage_mb                   = "102400"
  auto_grow_enabled            = false
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = false
  #ssl_minimal_tls_version_enforced = "TLS1_2"
}

# Create MySql DataBase
resource "azurerm_mysql_database" "Team2" {
  name                = "db-${(random_string.qwer.result)}"
  resource_group_name = azurerm_resource_group.Team2.name
  server_name         = azurerm_mysql_server.Team2.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Config MySQL Server Firewall Rule
resource "azurerm_mysql_firewall_rule" "Team2" {
  name                = "Team2-mysql-firewall-rule"
  resource_group_name = azurerm_resource_group.Team2.name
  server_name         = azurerm_mysql_server.Team2.name
  start_ip_address    = azurerm_public_ip.Team2.ip_address
  end_ip_address      = azurerm_public_ip.Team2.ip_address
}

data "azurerm_mysql_server" "Team2" {
  name                = azurerm_mysql_server.Team2.name
  resource_group_name = azurerm_resource_group.Team2.name
}
