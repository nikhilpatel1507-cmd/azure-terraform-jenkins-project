output "vm_id" {
  value = azurerm_linux_virtual_machine.app_vm.id
}

output "public_ip_address" {
  value = azurerm_public_ip.app_pip.ip_address
}
