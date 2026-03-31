# Terraform `for_each` on Azure — Complete Tutorial

> **Level:** Beginner to Advanced | **Provider:** `azurerm ~> 4.0` | **Terraform:** `~> 1.9`

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Prerequisites](#2-prerequisites)
3. [Beginner Examples](#3-beginner-examples)
4. [Intermediate Examples](#4-intermediate-examples)
5. [Advanced Examples](#5-advanced-examples)
6. [Real-World Use Cases](#6-real-world-use-cases)
7. [Best Practices](#7-best-practices)
8. [for_each vs count](#8-for_each-vs-count)
9. [Exercises](#9-exercises)

---

## 1. Introduction

### What is `for_each`?

`for_each` is a **meta-argument** you attach to a `resource` or `module` block that tells Terraform to create **one instance for every item** in a map or set you supply.

It accepts two collection types:

| Input type | `each.key` | `each.value` |
|---|---|---|
| `set(string)` | the string itself | same as key |
| `map(any)` | the map key | the map value |

State addresses are **named**, not positional:

```
azurerm_resource_group.env["dev"]
azurerm_resource_group.env["prod"]
```

### for_each vs count — 30-second summary

```hcl
# count — positional indices
resource "azurerm_resource_group" "env" {
  count    = 3
  name     = "rg-${count.index}"   # rg-0, rg-1, rg-2
  location = "East US"
}

# for_each — named keys
resource "azurerm_resource_group" "env" {
  for_each = toset(["dev", "staging", "prod"])
  name     = "rg-${each.key}"      # rg-dev, rg-staging, rg-prod
  location = "East US"
}
```

> **IMPORTANT**
> With `count`, removing "staging" from the list renumbers all subsequent indices and **may destroy-recreate prod**. With `for_each`, removing "staging" only affects `env["staging"]`.

### When to use `for_each`

- Creating multiple similar resources
- Collections where items may be added or removed
- When each item needs different attributes
- When you want to reference instances by name

---

## 2. Prerequisites

```bash
# Azure CLI
brew install azure-cli && az login

# Terraform
brew tap hashicorp/tap && brew install hashicorp/tap/terraform
terraform -version    # >= 1.9 required

# Set Azure credentials (or use az login for local dev)
export ARM_SUBSCRIPTION_ID="..."
export ARM_TENANT_ID="..."
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
```

**versions.tf (copy to each example folder):**

```hcl
terraform {
  required_version = "~> 1.9"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}
provider "azurerm" { features {} }
```

---

## 3. Beginner Examples

### Example 1 — Multiple Resource Groups (set of strings)

**File:** `01_beginner/example1_resource_groups/main.tf`

```hcl
variable "resource_groups" {
  description = "Set of environment names. One RG per name."
  type        = set(string)
  default     = ["dev", "staging", "prod"]
}

resource "azurerm_resource_group" "env" {
  for_each = var.resource_groups   # each.key == each.value for a set

  name     = "rg-${each.key}"
  location = "East US"
  tags     = { environment = each.key, managed_by = "terraform" }
}

output "resource_group_ids" {
  value = { for env, rg in azurerm_resource_group.env : env => rg.id }
}
```

**How it works step by step:**

```
Input: { "dev", "staging", "prod" }
         |           |          |
         v           v          v
     rg-dev      rg-staging   rg-prod

State:
  azurerm_resource_group.env["dev"]
  azurerm_resource_group.env["staging"]
  azurerm_resource_group.env["prod"]
```

```bash
cd 01_beginner/example1_resource_groups
terraform init && terraform plan
# Expected: 3 resource groups to add
```

---

### Example 2 — Multiple Storage Accounts (map of strings)

**File:** `01_beginner/example2_storage_accounts/main.tf`

```hcl
variable "storage_accounts" {
  description = "Map of short name to replication SKU."
  type        = map(string)
  default = {
    logs        = "Standard_LRS"
    backups     = "Standard_GRS"
    application = "Standard_ZRS"
  }
}

resource "azurerm_storage_account" "this" {
  for_each = var.storage_accounts

  name                     = "st${each.key}tutorial001"  # globally unique name
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = each.value  # LRS / GRS / ZRS from map value
}
```

| Expression | For key "logs" |
|---|---|
| `each.key` | `"logs"` |
| `each.value` | `"Standard_LRS"` |
| Resource name in Azure | `"stlogstutorial001"` |

---

## 4. Intermediate Examples

### Example 3 — VNets with Subnets (nested map + flattening)

**File:** `02_intermediate/example3_vnets_subnets/main.tf`

**The challenge:** Subnets live *inside* VNets in the variable, but a Terraform resource block cannot be nested inside another resource block.

**Solution — flatten into a local map:**

```hcl
variable "virtual_networks" {
  type = map(object({
    location      = string
    address_space = list(string)
    subnets = map(object({
      address_prefix = string
    }))
  }))
  default = {
    "vnet-frontend" = {
      location      = "East US"
      address_space = ["10.10.0.0/16"]
      subnets = {
        "snet-web" = { address_prefix = "10.10.1.0/24" }
        "snet-app" = { address_prefix = "10.10.2.0/24" }
      }
    }
  }
}

# VNets: one per map entry
resource "azurerm_virtual_network" "this" {
  for_each            = var.virtual_networks
  name                = each.key
  location            = each.value.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = each.value.address_space
}

# Flatten: "vnet-name/subnet-name" => { config }
locals {
  subnets_flat = {
    for vnet_key, vnet_val in var.virtual_networks :
    "${vnet_key}/${subnet_key}" => {
      vnet_key   = vnet_key
      subnet_key = subnet_key
      subnet_val = subnet_val
    }
    if true
    for subnet_key, subnet_val in vnet_val.subnets
  }
}

# Subnets: one per flattened entry
resource "azurerm_subnet" "this" {
  for_each             = local.subnets_flat
  name                 = each.value.subnet_key
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = each.value.vnet_key
  address_prefixes     = [each.value.subnet_val.address_prefix]
  depends_on           = [azurerm_virtual_network.this]
}
```

**Visual model:**
```
Variable (nested)                Locals (flat)
-----------------                -------------
vnet-frontend                    "vnet-frontend/snet-web"
  snet-web: 10.10.1.0/24   -->   "vnet-frontend/snet-app"
  snet-app: 10.10.2.0/24
```

---

### Example 4 — AKS Clusters (complex objects + optional())

**File:** `02_intermediate/example4_complex_maps/main.tf`

```hcl
variable "aks_clusters" {
  type = map(object({
    kubernetes_version = string
    default_node_pool  = object({
      name       = string
      node_count = number
      vm_size    = string
    })
    # optional() = Terraform 1.3+; caller can omit, gets the default
    network_profile = optional(object({
      network_plugin = string
      dns_service_ip = string
      service_cidr   = string
    }), {
      network_plugin = "azure"
      dns_service_ip = "10.100.0.10"
      service_cidr   = "10.100.0.0/16"
    })
    tags = optional(map(string), {})
  }))
  default = {
    "aks-dev" = {
      kubernetes_version = "1.29"
      default_node_pool  = { name = "default", node_count = 2, vm_size = "Standard_B2s" }
    }
    "aks-prod" = {
      kubernetes_version = "1.29"
      default_node_pool  = { name = "default", node_count = 5, vm_size = "Standard_D4s_v3" }
      tags = { critical = "true" }
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  for_each            = var.aks_clusters
  name                = each.key
  kubernetes_version  = each.value.kubernetes_version
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  dns_prefix          = each.key

  default_node_pool {
    name       = each.value.default_node_pool.name
    node_count = each.value.default_node_pool.node_count
    vm_size    = each.value.default_node_pool.vm_size
  }

  identity { type = "SystemAssigned" }

  network_profile {
    network_plugin = each.value.network_profile.network_plugin
    dns_service_ip = each.value.network_profile.dns_service_ip
    service_cidr   = each.value.network_profile.service_cidr
  }

  tags = merge({ managed_by = "terraform" }, each.value.tags)
}
```

---

## 5. Advanced Examples

### Example 5 — `for_each` on a Module Call

**Files:** `03_advanced/example5_module_foreach/`

```hcl
# Root module — one network stack per environment
module "network" {
  source   = "./modules/network"
  for_each = var.environments   # map of environment configs

  env_name      = each.key
  location      = each.value.location
  address_space = each.value.address_space
  subnets       = each.value.subnets
}

# Access module outputs:
output "vnet_ids_by_env" {
  value = { for env, mod in module.network : env => mod.vnet_id }
}
```

State addressing with module for_each:
```
module.network["dev"].azurerm_resource_group.this
module.network["dev"].azurerm_virtual_network.this
module.network["prod"].azurerm_resource_group.this
module.network["prod"].azurerm_virtual_network.this
```

The child module (`modules/network/main.tf`) uses `cidrsubnet()` to derive subnet CIDRs:

```hcl
locals {
  subnet_map = {
    for s in var.subnets :
    s.name => { address_prefix = cidrsubnet(var.address_space, s.newbits, s.netnum) }
  }
}
resource "azurerm_subnet" "this" {
  for_each         = local.subnet_map
  name             = "snet-${each.key}"
  address_prefixes = [each.value.address_prefix]
  # cidrsubnet("10.10.0.0/16", 8, 1) -> "10.10.1.0/24"
}
```

---

### Example 6 — Conditional Creation with Filtered Maps

**File:** `03_advanced/example6_conditional_filtered/main.tf`

```hcl
variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}

variable "all_storage_accounts" {
  type = map(object({ environment = string, sku = string }))
  default = {
    "salogsdev001"   = { environment = "dev",  sku = "Standard_LRS" }
    "salogsstagin001"= { environment = "staging", sku = "Standard_GRS" }
    "salogsprod001"  = { environment = "prod", sku = "Standard_GRS" }
  }
}

locals {
  # Filter: only keep entries matching the active environment
  filtered_storage = {
    for name, cfg in var.all_storage_accounts :
    name => cfg
    if cfg.environment == var.environment
  }
}

resource "azurerm_storage_account" "this" {
  for_each                 = local.filtered_storage
  name                     = each.key
  account_replication_type = each.value.sku
  # ...
}
```

> **TIP:** Set `TF_VAR_environment=prod` and only prod accounts are planned. No conditional logic in the resource blocks — it's all in the `locals` filter.

---

### Example 7 — `for_each` + `dynamic` Blocks

**File:** `03_advanced/example7_dynamic_blocks/main.tf`

```hcl
variable "network_security_groups" {
  type = map(object({
    rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
  default = {
    "nsg-web" = {
      rules = [
        { name = "allow-http",  priority = 100, direction = "Inbound", access = "Allow",
          protocol = "Tcp", source_port_range = "*", destination_port_range = "80",
          source_address_prefix = "*", destination_address_prefix = "*" },
        { name = "allow-https", priority = 110, direction = "Inbound", access = "Allow",
          protocol = "Tcp", source_port_range = "*", destination_port_range = "443",
          source_address_prefix = "*", destination_address_prefix = "*" },
      ]
    }
    "nsg-data" = {
      rules = [
        { name = "deny-all", priority = 4096, direction = "Inbound", access = "Deny",
          protocol = "*", source_port_range = "*", destination_port_range = "*",
          source_address_prefix = "*", destination_address_prefix = "*" },
      ]
    }
  }
}

resource "azurerm_network_security_group" "this" {
  for_each            = var.network_security_groups  # outer: one NSG
  name                = each.key
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dynamic "security_rule" {             # inner: one rule per list item
    for_each = each.value.rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
```

**Two-level loop visualization:**
```
Outer for_each (NSG)       Inner dynamic (rules)
--------------------       ---------------------
nsg-web              -->   rule: allow-http  (priority 100)
                           rule: allow-https (priority 110)
nsg-data             -->   rule: deny-all    (priority 4096)
```

---

## 6. Real-World Use Cases

### UC-1: Multi-Environment Deployments

**Problem:** Dev needs cheap VMs; prod needs powerful, HA ones. Managing separate configs leads to configuration drift.

```hcl
variable "environments" {
  type = map(object({ location = string, plan_sku = string, worker_count = number }))
  default = {
    dev     = { location = "East US",     plan_sku = "B1",   worker_count = 1 }
    staging = { location = "East US",     plan_sku = "P1v3", worker_count = 2 }
    prod    = { location = "West Europe", plan_sku = "P3v3", worker_count = 5 }
  }
}
resource "azurerm_service_plan" "env" {
  for_each     = var.environments
  name         = "asp-myapp-${each.key}"
  sku_name     = each.value.plan_sku
  worker_count = each.value.worker_count
}
```

---

### UC-2: Multi-Region Rollout

**Problem:** Deploying identical infra to 3+ regions — copy-paste is error-prone.

```hcl
locals {
  region_cidrs = {
    for region, cfg in var.regions :
    region => cidrsubnet("10.0.0.0/8", 8, cfg.cidr_offset)
  }
}
# eastus -> 10.0.0.0/16 | westeurope -> 10.1.0.0/16 | southeastasia -> 10.2.0.0/16

resource "azurerm_virtual_network" "region" {
  for_each      = var.regions
  name          = "vnet-platform-${each.key}"
  location      = each.key
  address_space = [local.region_cidrs[each.key]]
}
```

---

### UC-3: RBAC Assignments at Scale

**Problem:** 20 role assignments across 5 subscriptions — manual Azure Portal ACL management is a nightmare.

```hcl
variable "role_assignments" {
  type = map(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
  }))
}
resource "azurerm_role_assignment" "this" {
  for_each             = var.role_assignments
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
# Adding a new assignment = one map entry. No logic changes.
```

---

### UC-4: Tag Standardisation

**Problem:** Finance can't do cost allocation because resources have inconsistent tags.

```hcl
locals {
  mandatory_tags = { managed_by = "terraform", last_modified = "2025-01-01" }
  workload_tags = {
    for name, cfg in var.workloads :
    name => merge(local.mandatory_tags, {
      workload    = name
      cost_center = cfg.cost_center
      owner       = cfg.owner
      environment = cfg.environment
    })
  }
}
resource "azurerm_resource_group" "workload" {
  for_each = var.workloads
  tags     = local.workload_tags[each.key]  # full merged tag set
}
```

---

### UC-5: Multi-Tenant SaaS Isolation

Same file as UC-4. Adding one map entry provisions an isolated resource group, storage account, and Key Vault — under 30 seconds.

```hcl
variable "tenants" {
  type = map(object({ location = string, tier = string }))
  default = {
    "contoso"  = { location = "East US",    tier = "pro" }
    "fabrikam" = { location = "West Europe", tier = "enterprise" }
  }
}

# Adding "northwind" = one map entry -> RG + SA + Key Vault created automatically
resource "azurerm_key_vault" "tenant" {
  for_each = var.tenants
  name     = "kv-${substr(each.key, 0, 10)}-001"
  sku_name = each.value.tier == "enterprise" ? "premium" : "standard"
}
```

---

## 7. Best Practices

### Resource block ordering (terraform-skill standard)

```hcl
resource "azurerm_virtual_network" "this" {
  for_each = var.virtual_networks    # 1. for_each FIRST (blank line after)

  name                = each.key    # 2. other arguments
  location            = each.value.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = each.value.address_space

  tags = { managed_by = "terraform" }  # 3. tags second-to-last

  lifecycle {                           # 4. lifecycle at very end (if needed)
    create_before_destroy = false
  }
}
```

### DO

| Practice | Reason |
|---|---|
| Use **stable, descriptive keys** | Keys are state addresses; changing them forces destroy+create |
| Declare `description` on every variable | Required by terraform-best-practices.com |
| Use `map(object(...))` not `map(any)` | Type-checks at `terraform validate` time |
| Use `optional(type, default)` for new attrs | Backward-compatible schema evolution |
| **Flatten nested structures in `locals`** | Keeps resource blocks clean |
| Use `moved` block when renaming keys | Renames in state without destroying resources |

### DON'T

| Anti-pattern | Problem |
|---|---|
| Integer string keys: `"0"`, `"1"` | Same instability as `count` |
| Use computed/unknown values in `for_each` | Terraform must know the full keyset at plan time |
| Mix `count` and `for_each` on the same resource | Not permitted by Terraform |
| Change a key without `moved` block | Destroy + recreate the resource |
| Use `for_each` for a simple bool toggle | Use `count = condition ? 1 : 0` instead |

### Key rename pitfall and fix

```hcl
# BEFORE: key was "vnet01"
# AFTER:  key is "vnet-primary"
# Without moved block -> destroy vnet01, create vnet-primary (DANGEROUS!)

# WITH moved block -> rename in state only, no downtime
moved {
  from = azurerm_virtual_network.this["vnet01"]
  to   = azurerm_virtual_network.this["vnet-primary"]
}
```

---

## 8. `for_each` vs `count`

### Side-by-side comparison

```hcl
# count — list-based, positional
variable "envs" { default = ["dev", "staging", "prod"] }
resource "azurerm_resource_group" "count_ex" {
  count    = length(var.envs)
  name     = "rg-${var.envs[count.index]}"
  location = "East US"
}
# Remove "staging" -> prod shifts from index 2 to index 1 -> RECREATED!

# for_each — map/set-based, named
resource "azurerm_resource_group" "foreach_ex" {
  for_each = toset(var.envs)
  name     = "rg-${each.key}"
  location = "East US"
}
# Remove "staging" -> only env["staging"] is destroyed -> prod is safe
```

### Decision matrix

| Scenario | Use |
|---|---|
| Boolean on/off toggle | `count = condition ? 1 : 0` |
| N identical resources | `count = N` |
| Named collection | `for_each = map` |
| Items may be removed | `for_each = set/map` |
| Different config per item | `for_each = map(object)` |
| Reference resource later by name | `for_each` |

---

## 9. Hands-On Exercises

> **Starter code:** `05_exercises/exercises.tf` (has TODO comments)
> **Solutions:** `05_exercises/solutions/solutions.tf`

| # | Task | Skill practiced | Difficulty |
|---|---|---|---|
| 1 | Deploy 3 resource groups from a `set(string)` | Basic `for_each`, `each.key` | ⭐ |
| 2 | Deploy storage accounts from a `map(string)` | `each.value`, outputs | ⭐⭐ |
| 3 | Deploy VNets + subnets from a nested map | Flattening with `locals` | ⭐⭐⭐ |
| 4 | Deploy only "active" RGs from a complete catalogue | Filtering with `if` | ⭐⭐⭐⭐ |
| 5 | One NSG per tier with per-port rules | `for_each` + `dynamic` | ⭐⭐⭐⭐⭐ |

### Exercise 4 hint

```hcl
# Filter map to active=true before passing to for_each
locals {
  active_rgs = {
    for k, v in var.all_rgs : k => v if v.active
  }
}
resource "azurerm_resource_group" "active" {
  for_each = local.active_rgs
  name     = each.key
  location = each.value.location
}
```

### Exercise 5 hint

```hcl
resource "azurerm_network_security_group" "tiers" {
  for_each = var.tiers    # outer: one NSG

  dynamic "security_rule" {
    for_each = each.value.allowed_ports  # inner: one rule per port number
    content {
      name                       = "allow-port-${security_rule.value}"
      priority                   = 100 + security_rule.key   # key = list index
      destination_port_range     = tostring(security_rule.value)
      # ...
    }
  }
}
```

---

## Directory Layout

```
for_each_rw_examples/
├── versions.tf
├── TUTORIAL.md
├── 01_beginner/
│   ├── example1_resource_groups/     # for_each over set of strings
│   └── example2_storage_accounts/   # for_each over map(string)
├── 02_intermediate/
│   ├── example3_vnets_subnets/       # nested map + flattening
│   └── example4_complex_maps/       # AKS with optional() typed objects
├── 03_advanced/
│   ├── example5_module_foreach/      # for_each on module call
│   │   └── modules/network/
│   ├── example6_conditional_filtered/ # filtered maps
│   └── example7_dynamic_blocks/     # for_each + dynamic blocks
├── 04_real_world/
│   ├── uc1_multi_environment.tf
│   ├── uc2_multi_region.tf
│   ├── uc3_rbac_at_scale.tf
│   ├── uc4_and_uc5_tags_and_tenants.tf
│   └── versions.tf
└── 05_exercises/
    ├── exercises.tf
    ├── versions.tf
    └── solutions/solutions.tf
```
