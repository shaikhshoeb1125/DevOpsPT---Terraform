# Terraform Quiz

## Beginner Level

**1. Your team reviewed the Terraform plan and everything looks correct. You now want to actually create the infrastructure on AWS. Which command executes the changes?**
- A) terraform deploy
- B) terraform execute
- C) terraform apply
- D) terraform run

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> C (terraform apply)
<br/>
<b>Explanation:</b> `terraform apply` executes the actions proposed in a Terraform plan. It provisions or modifies real infrastructure to match your configuration. Terraform asks for confirmation before applying unless you pass the `-auto-approve` flag. Always review the plan output before approving.
</details>

<hr>

**2. Your team writes a Terraform file to create an AWS S3 bucket. You want to reuse the bucket name in multiple places without repeating it. Which Terraform feature lets you define a named value once and reference it throughout your configuration?**
- A) Data Source
- B) Module
- C) Variable
- D) Output

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> C (Variable)
<br/>
<b>Explanation:</b> Terraform input variables let you define named values that can be referenced throughout your configuration using `var.variable_name`. Variables make configurations reusable and configurable without modifying the code directly. Values can be passed via command line, variable files, or environment variables.
</details>

<hr>

**3. Your team wants to query information about an existing AWS VPC that was not created by Terraform so you can reference its ID in your configuration. Which Terraform feature reads existing infrastructure without managing it?**
- A) Variable
- B) Data Source
- C) Module
- D) Resource

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (Data Source)
<br/>
<b>Explanation:</b> Terraform data sources allow you to fetch information about existing resources that are managed outside of Terraform. For example, `aws_vpc` data source lets you look up a VPC by its ID or tags and use its attributes in your configuration without taking over management of that resource.
</details>

<hr>

**4. Your team wants to check that your Terraform configuration files are syntactically correct before running a plan. Which command verifies the configuration for syntax errors?**
- A) terraform lint
- B) terraform validate
- C) terraform fmt
- D) terraform plan

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (terraform validate)
<br/>
<b>Explanation:</b> `terraform validate` checks whether a Terraform configuration is syntactically valid and internally consistent. It verifies that all required arguments are present, attribute names are correct, and references are valid. It does not check against the actual cloud provider, so no credentials are needed.
</details>

<hr>

**5. Your Terraform configuration references AWS as the cloud provider. Before you can run `terraform plan`, Terraform needs to download the AWS plugin. Which command initializes the working directory and downloads providers?**
- A) terraform get
- B) terraform install
- C) terraform setup
- D) terraform init

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> D (terraform init)
<br/>
<b>Explanation:</b> `terraform init` initializes a Terraform working directory by downloading the required provider plugins, installing modules, and setting up the backend for state storage. It must be run before any other Terraform commands in a new or cloned configuration directory.
</details>

<hr>

**6. Your company grows and you find yourself copying the same Terraform code for VPCs, EC2 instances, and security groups across multiple projects. Which Terraform feature lets you package reusable infrastructure components that can be called with different inputs?**
- A) Workspace
- B) Backend
- C) Provider
- D) Module

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> D (Module)
<br/>
<b>Explanation:</b> Terraform modules are containers for multiple resources that are used together. A module packages reusable infrastructure code and accepts input variables, making it easy to create the same infrastructure pattern across multiple projects or environments with different configurations.
</details>

<hr>

**7. Your team stores Terraform state locally on each developer machine. Two developers ran `terraform apply` at the same time targeting the same environment and it corrupted the state file. How do you prevent this in the future?**
- A) Use remote state in S3 with DynamoDB state locking
- B) Use terraform plan instead of apply
- C) Email the team before running terraform apply
- D) Use a single developer machine for all applies

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> A (Use remote state in S3 with DynamoDB state locking)
<br/>
<b>Explanation:</b> Remote state in S3 with a DynamoDB lock table is the standard solution. When one developer runs apply, the DynamoDB table creates a lock entry preventing any other apply from running simultaneously. The S3 backend also makes state accessible to all team members consistently.
</details>

<hr>

**8. Your Terraform configuration creates an EC2 instance, and you want to print the public IP address of that instance after it is created so your team can use it. Which Terraform feature exposes values after apply?**
- A) Variable
- B) Data Source
- C) Output
- D) Local

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> C (Output)
<br/>
<b>Explanation:</b> Terraform output values expose specific attributes of your infrastructure after `terraform apply` completes. Outputs are displayed in the terminal and can also be queried with `terraform output`. They are useful for sharing values between modules or displaying connection information.
</details>

<hr>

**9. Your manager says instead of clicking around the AWS console to create infrastructure, we should define everything as code so it is repeatable and version controlled. Which tool is designed specifically for this?**
- A) Chef
- B) Terraform
- C) Ansible
- D) Jenkins

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (Terraform)
<br/>
<b>Explanation:</b> Terraform is an open source Infrastructure as Code tool by HashiCorp. It lets you define cloud infrastructure using configuration files that can be versioned, reviewed, and reused. Terraform supports AWS, Azure, GCP, and hundreds of other providers through its plugin system.
</details>

<hr>

**10. Your team just wrote their first Terraform configuration file. Before applying any changes, you want to see exactly what resources Terraform will create, modify, or destroy without actually making any changes. Which command do you run?**
- A) terraform plan
- B) terraform apply
- C) terraform validate
- D) terraform show

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> A (terraform plan)
<br/>
<b>Explanation:</b> `terraform plan` creates an execution plan, showing what actions Terraform will take to reach the desired state defined in your configuration. It is a dry run that lets you review changes before committing them. No real infrastructure changes are made during a plan.
</details>

<hr>

## Medium Level

**11. Your team uses Terraform to manage AWS infrastructure. A developer added a new S3 bucket directly in the AWS console without going through Terraform. Now `terraform plan` shows the bucket does not exist and wants to create a duplicate. How do you resolve this without deleting the manually created bucket?**
- A) Write the resource block in Terraform and run terraform import to bring it under Terraform management
- B) Delete the bucket and let Terraform recreate it
- C) Ignore it and use the console bucket
- D) Use terraform taint

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> A (Write the resource block in Terraform and run terraform import to bring it under Terraform management)
<br/>
<b>Explanation:</b> `terraform import` adds the existing manually created resource to the Terraform state file by linking it to a resource block in your configuration. After importing, `terraform plan` should show no changes for that resource. Going forward all changes go through Terraform maintaining your infrastructure as code principle.
</details>

<hr>

**12. Your Terraform module creates an EC2 instance that depends on a security group. Terraform usually infers dependencies automatically but you need to explicitly declare that the EC2 instance must wait for an S3 bucket policy to be applied first even though there is no direct reference. Which argument handles explicit dependencies?**
- A) lifecycle
- B) depends_on
- C) for_each
- D) count

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (depends_on)
<br/>
<b>Explanation:</b> The `depends_on` meta argument lets you explicitly define dependencies between resources or modules when Terraform cannot automatically infer them from configuration references. Terraform will ensure the specified resources are fully created or modified before processing the resource with depends_on.
</details>

<hr>

**13. Your team stores Terraform state in a local file by default, but this causes problems when multiple team members run Terraform simultaneously. You want to store state in an S3 bucket so everyone shares the same state. Which Terraform block configures this?**
- A) provider
- B) module
- C) variable
- D) backend

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> D (backend)
<br/>
<b>Explanation:</b> The backend block in Terraform configures where state is stored and how operations are performed. Using the S3 backend stores your terraform.tfstate file in an S3 bucket enabling shared state across your team. You can also enable state locking using a DynamoDB table to prevent concurrent modifications.
</details>

<hr>

**14. Your team manages three environments (dev, staging, and production) using the same Terraform code but with different variable values. You want to keep all three states separate without duplicating code. Which Terraform feature creates isolated state environments within the same configuration?**
- A) Backends
- B) Providers
- C) Workspaces
- D) Modules

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> C (Workspaces)
<br/>
<b>Explanation:</b> Terraform workspaces allow you to manage multiple distinct state files for the same configuration. Each workspace has its own state, so dev, staging, and production resources are tracked independently. You switch between them with `terraform workspace select` and reference the current workspace name using `terraform.workspace`.
</details>

<hr>

**15. Your team has 3 environments (dev, staging, and production) all managed by the same Terraform code. A developer ran `terraform destroy` in the wrong terminal window and destroyed the staging database. How do you prevent accidental destruction of critical resources in the future?**
- A) Add a confirmation prompt
- B) Restrict Terraform to one environment per machine
- C) Use terraform workspace carefully
- D) Add lifecycle prevent_destroy to the database resource and require peer reviewed PRs for infrastructure changes

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> D (Add lifecycle prevent_destroy to the database resource and require peer reviewed PRs for infrastructure changes)
<br/>
<b>Explanation:</b> The `lifecycle prevent_destroy` block causes Terraform to throw an error if any plan would delete that resource, providing a hard safety net. Combined with requiring pull request reviews for Terraform changes and using CI pipelines to run plans automatically, you create multiple layers of protection against accidental destruction.
</details>

<hr>

**16. Your senior engineer says always format your Terraform files consistently before committing to the repository so the code style is uniform across the team. Which command automatically rewrites Terraform files to the canonical format?**
- A) terraform lint
- B) terraform validate
- C) terraform check
- D) terraform fmt

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> D (terraform fmt)
<br/>
<b>Explanation:</b> `terraform fmt` reads Terraform configuration files and rewrites them to follow the HashiCorp canonical style including consistent indentation, alignment, and spacing. Running terraform fmt before every commit keeps code style uniform. You can use `terraform fmt -check` in CI pipelines to fail the build if files are not formatted.
</details>

<hr>

**17. Your Terraform configuration has a variable for environment that should only accept the values dev, staging, or production. How do you enforce this restriction so Terraform throws an error if an invalid value is provided?**
- A) Use a local value
- B) Add a validation block inside the variable definition
- C) Use a data source filter
- D) Use an output with a condition

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (Add a validation block inside the variable definition)
<br/>
<b>Explanation:</b> Terraform variable validation blocks let you define custom rules that input values must satisfy. You write a condition expression and an error message. If the condition returns false, Terraform shows your error message and stops. This is the standard way to enforce allowed values for input variables.
</details>

<hr>

**18. Your team wants to create multiple identical S3 buckets with different names from a single resource block using a list of bucket names. Which Terraform meta argument iterates over a map or set to create multiple resource instances?**
- A) depends_on
- B) count
- C) for_each
- D) lifecycle

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> C (for_each)
<br/>
<b>Explanation:</b> The `for_each` meta argument lets you create multiple instances of a resource from a map or set. Each instance gets a unique key from the collection. Unlike count which uses numeric indexes, for_each uses meaningful string keys, making it easier to add, remove, or modify individual instances without affecting others.
</details>

<hr>

**19. Your team created an AWS EC2 instance manually in the console and now wants to bring it under Terraform management without destroying and recreating it. Which Terraform command adds an existing resource to the state file?**
- A) terraform taint
- B) terraform state add
- C) terraform import
- D) terraform refresh

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> C (terraform import)
<br/>
<b>Explanation:</b> `terraform import` brings existing infrastructure under Terraform management by adding it to the state file. You provide the resource address and the real resource ID. After importing you must write the matching configuration manually since import only updates state not the configuration files.
</details>

<hr>

**20. Your teammate ran `terraform apply` and now the state file shows resources that no longer exist in AWS because someone deleted them manually from the console. You want to update the state to reflect reality without destroying and recreating everything. Which command refreshes the state?**
- A) terraform taint
- B) terraform refresh
- C) terraform sync
- D) terraform import

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (terraform refresh)
<br/>
<b>Explanation:</b> `terraform refresh` queries the real infrastructure and updates the Terraform state file to match the actual current state. It does not modify real infrastructure. Note that in newer versions refresh behavior is built into plan and apply with the `-refresh-only` flag replacing the standalone refresh command.
</details>

<hr>

## Hard Level

**21. Your team has a Terraform module that creates an RDS database and returns the connection string as an output. However the connection string contains the database password. How do you prevent Terraform from showing this value in plain text in the CLI output and in the state file?**
- A) Mark the output with sensitive equals true
- B) Store the password in a variable with no default
- C) Encrypt the output using a KMS key
- D) Use a local value instead of output

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> A (Mark the output with sensitive equals true)
<br/>
<b>Explanation:</b> Marking an output as `sensitive = true` tells Terraform to redact the value in CLI output replacing it with a sensitive value placeholder. However the value is still stored in the state file. For true secret protection use a secrets manager like AWS Secrets Manager or HashiCorp Vault and only store references not actual secrets in state.
</details>

<hr>

**22. Your CI pipeline runs `terraform plan` on every pull request. You want the pipeline to fail if the Terraform configuration files are not formatted with `terraform fmt`. Which command exits with a non zero code if formatting is needed without modifying files?**
- A) terraform fmt -diff
- B) terraform validate --format
- C) terraform fmt -check
- D) terraform fmt -list

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> C (terraform fmt -check)
<br/>
<b>Explanation:</b> `terraform fmt -check` runs the formatter in check mode. It exits with a non zero status code if any files need formatting but does not modify them. This makes it ideal for CI pipelines where you want to enforce formatting standards without automatically changing files in the pipeline.
</details>

<hr>

**23. Your organization uses Terraform Cloud and wants to enforce a policy that no S3 bucket can be created without server side encryption enabled. Which HashiCorp tool lets you write these governance policies as code?**
- A) Checkov
- B) Sentinel
- C) Terraform Validate
- D) OPA

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (Sentinel)
<br/>
<b>Explanation:</b> Sentinel is HashiCorps policy as code framework integrated into Terraform Cloud and Terraform Enterprise. You write policies in the Sentinel language that are evaluated after terraform plan and before terraform apply. If a policy check fails the apply is blocked enforcing organizational governance rules.
</details>

<hr>

**24. Your Terraform configuration uses count to create 5 EC2 instances. You need to remove only the third instance which is count index 2 without affecting the others. What is the safest approach?**
- A) Use terraform state rm to remove only that instance
- B) Reduce count to 4
- C) Remove that instance from the list and let Terraform recalculate
- D) Use terraform taint on that instance

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> A (Use terraform state rm to remove only that instance)
<br/>
<b>Explanation:</b> `terraform state rm` removes a specific resource from the Terraform state without destroying the real resource. After removal Terraform no longer manages that instance. You can then remove it from the configuration. Directly reducing count would cause Terraform to destroy the last instance not a specific one showing a key advantage of for_each over count for named resources.
</details>

<hr>

**25. Your team manages 50 Terraform modules and wants to enforce that all modules use provider versions within a safe tested range. Which Terraform block in the root module pins provider versions?**
- A) required_providers inside terraform block
- B) module
- C) backend
- D) variable

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> A (required_providers inside terraform block)
<br/>
<b>Explanation:</b> The `required_providers` block inside the terraform configuration block specifies the source and version constraints for each provider. Using version constraints like `>= 5.0` and `< 6.0` ensures your team always uses tested provider versions and prevents accidental upgrades that could introduce breaking changes.
</details>

<hr>

**26. Your team runs `terraform apply` in a CI pipeline and wants Terraform to automatically approve without prompting for confirmation. Which flag achieves this?**
- A) --confirm
- B) -auto-approve
- C) --yes
- D) --force

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (-auto-approve)
<br/>
<b>Explanation:</b> The `-auto-approve` flag tells terraform apply to skip the interactive confirmation prompt and apply the changes immediately. This is required in automated CI/CD pipelines where there is no human to type yes. Always ensure your pipeline includes a plan review step before using `-auto-approve` in production pipelines.
</details>

<hr>

**27. In Terraform what is the purpose of the terraform.tfstate file and why should it never be committed to a public Git repository?**
- A) It tracks the mapping between your configuration and real world resources and may contain sensitive data like passwords and private keys
- B) It caches downloaded provider plugins and is too large for Git
- C) It stores provider credentials and committing it exposes secrets
- D) It contains the execution logs from the last terraform apply

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> A (It tracks the mapping between your configuration and real world resources and may contain sensitive data like passwords and private keys)
<br/>
<b>Explanation:</b> The `terraform.tfstate` file is Terraforms source of truth for what infrastructure it manages. It records resource IDs, attributes, and sometimes sensitive values like database passwords. Committing state to a public repo exposes infrastructure details and secrets. Always use a remote backend like S3 with encryption and restrict access.
</details>

<hr>

**28. Your Terraform configuration creates resources in a specific order based on dependencies. You notice that a null_resource needs to run a provisioner script every time a certain EC2 instance is replaced. Which argument inside null_resource triggers re-execution when a dependency changes?**
- A) depends_on
- B) lifecycle
- C) triggers
- D) provisioner

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> C (triggers)
<br/>
<b>Explanation:</b> The `triggers` argument in `null_resource` is a map of values that when changed cause the null_resource to be replaced and its provisioners to re run. By referencing the EC2 instance ID in triggers the null_resource will re execute its provisioner script every time the instance is replaced providing a hook for configuration management tasks.
</details>

<hr>

**29. Your `terraform plan` shows that Terraform wants to destroy and recreate a resource you expected to only be updated in place. What is the most likely reason for this forced replacement?**
- A) The resource has a prevent_destroy lifecycle
- B) An argument that requires replacement was changed such as the instance type or availability zone
- C) The provider version changed
- D) The state file is corrupted

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (An argument that requires replacement was changed such as the instance type or availability zone)
<br/>
<b>Explanation:</b> Certain resource arguments are immutable after creation. Changing them forces Terraform to destroy and recreate the resource. For example changing the availability_zone of an EC2 instance or the engine of an RDS instance triggers replacement. The plan output marks these changes with the replace symbol so always read plan output carefully.
</details>

<hr>

**30. Your infrastructure team uses Terraform but developers keep making manual changes in the AWS console causing drift between actual infrastructure and Terraform state. These drift events caused 2 incidents when `terraform apply` overwrote manual fixes. How do you detect and prevent drift systematically?**
- A) Lock the AWS account
- B) Run terraform plan on a schedule in CI and alert on any detected drift. Enforce SCPs in AWS Organizations blocking direct console changes to production resources. All changes must go through Terraform pull requests.
- C) Ask developers not to use the console
- D) Use terraform refresh only

<details>
<summary><b>View Answer</b></summary>
<b>Correct Answer:</b> B (Run terraform plan on a schedule in CI and alert on any detected drift. Enforce SCPs in AWS Organizations blocking direct console changes to production resources. All changes must go through Terraform pull requests.)
<br/>
<b>Explanation:</b> Systematic drift prevention requires both detection and prevention. Scheduled `terraform plan` runs in CI detect when actual infrastructure diverges from state and alert the team. AWS Organizations Service Control Policies block console modifications to production resources at the IAM policy level making Terraform the only path for infrastructure changes. This two-layer approach eliminates both accidental and intentional drift.
</details>

<hr>

## Interview Questions (Open Ended)

**31. What is the lifecycle meta-argument and when do you use each setting?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> Lifecycle settings: 1) create_before_destroy — creates replacement before destroying original, use for resources that cannot have downtime (auto scaling groups, load balancers) or when downstream resources depend on this one, 2) prevent_destroy — raises error if plan includes destroying this resource, use for critical resources (production databases, state buckets) to prevent accidental deletion, 3) ignore_changes — ignores changes to specified attributes made outside Terraform, use when an external system modifies resource attributes (ASG desired count managed by autoscaling, container image managed by deployment tool), 4) replace_triggered_by — triggers resource replacement when specified resources/attributes change. Use sparingly — overuse complicates state management. ignore_changes should be the last resort when proper management isn't feasible.
</details>

<hr>

**32. What is terraform workspace and what are its limitations?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> Terraform workspaces create isolated state instances within the same backend. Commands: terraform workspace new/select/list/delete. Use case: managing multiple environments (dev/staging/prod) from same configuration. Access current workspace in config: ${terraform.workspace}. Limitations: 1) All workspaces share the same configuration and providers, 2) Not suitable for environments with different infrastructure needs, 3) Backend configuration is shared — same S3 bucket, 4) Easy to accidentally apply to wrong workspace, 5) Not supported in all backends. Better alternative for most teams: separate directories per environment with separate state files providing true isolation. Use workspaces only for truly identical environments where only variable values differ.
</details>

<hr>

**33. What is Terraform and what problem does it solve?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> Terraform is an open-source Infrastructure as Code tool by HashiCorp solving the problem of manual, inconsistent infrastructure management. Problems it solves: 1) Manual infrastructure creates snowflake servers with undocumented configurations, 2) No version history for infrastructure changes, 3) Difficult to replicate environments (dev/staging/prod drift), 4) Manual processes are slow and error-prone. Terraform provides: declarative configuration (describe desired state), execution plans (preview changes before applying), state management (track real resources), provider plugins for 3000+ services, and idempotent operations (safe to run multiple times).
</details>

<hr>

**34. What is Terraform state and why is it important?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> Terraform state (terraform.tfstate) maps your configuration to real-world resources. It's important because: 1) Tracks which resources Terraform manages, 2) Stores metadata about resources (IDs, attributes) needed for updates, 3) Used for dependency resolution — knows the order to create/destroy resources, 4) Detects drift between configuration and actual infrastructure, 5) Enables terraform plan to show accurate changes. Without state Terraform couldn't know if a resource already exists. Problems: state file can contain sensitive values, must be kept in sync with reality, concurrent modifications cause conflicts. Solution: remote state backends with locking (S3 + DynamoDB).
</details>

<hr>

**35. What is the purpose of variables in Terraform?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> Variables make Terraform configurations flexible and reusable by parameterizing values. Types: string, number, bool, list, map, set, object, tuple, any. Define in variables.tf with optional type, default, description, and validation. Assign values via: terraform.tfvars file (auto-loaded), *.auto.tfvars files, -var flag (CLI), -var-file flag, environment variables (TF_VAR_name), or interactive prompt if no default. Use with var.variable_name in configuration. Best practice: define all variables with descriptions, use validation blocks for constraints, never hardcode environment-specific values.
</details>

<hr>

**36. What is a Terraform module and why use them?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> A module is a container for multiple related Terraform resources. The root module is your main configuration. Child modules are called with module blocks referencing local directories or registry modules. Benefits: 1) Reusability — write once, use many times across projects, 2) Encapsulation — hide implementation complexity, expose only necessary inputs/outputs, 3) Consistency — standardize infrastructure patterns across teams, 4) Versioning — pin module versions for stability. Input variables receive values, output values expose resource attributes to calling modules. The Terraform Registry hosts thousands of community modules for common patterns.
</details>

<hr>

**37. What is terraform init and what does it do?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> `terraform init` initializes the working directory. It performs: 1) Backend initialization — configures the specified backend (S3, Terraform Cloud) for state storage, 2) Provider installation — downloads and installs provider plugins specified in required_providers, 3) Module installation — downloads modules from registry or remote sources, 4) Creates .terraform directory for downloaded providers/modules, 5) Creates .terraform.lock.hcl for provider version locking. Must be run: when first working with a configuration, after adding new providers or modules, when changing backend configuration. Run terraform init -upgrade to update providers to latest allowed version.
</details>

<hr>

**38. What is the terraform.lock.hcl file?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> The .terraform.lock.hcl is a dependency lock file ensuring consistent provider versions across team members. It records: exact provider versions selected, cryptographic hashes for verification. Introduced in Terraform 0.14. Should be committed to version control so all team members and CI/CD use identical provider versions. Run terraform providers lock to update it for additional platforms (needed for cross-platform teams where some develop on ARM Macs but deploy on amd64 Linux). Run terraform init -upgrade to update provider versions and regenerate the lock file. Unlike application lock files it must be manually managed for upgrades.
</details>

<hr>

**39. What are Terraform outputs and how are they used?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> Output values expose resource attributes from your Terraform configuration for use by other configurations or for displaying information after apply. Defined in outputs.tf: output instance_ip { value = aws_instance.web.public_ip }. Uses: 1) Display information after apply (terraform output), 2) Pass values to other modules (root module outputs accessible via terraform_remote_state), 3) Used by CI/CD to get resource IDs/endpoints, 4) Integration between configurations. Mark as sensitive = true to mask sensitive values in output. In modules, outputs are accessed via module.module_name.output_name. terraform output -json returns all outputs as JSON for scripting.
</details>

<hr>

**40. What is the difference between count and for_each?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> Both create multiple resource instances. count accepts a whole number creating numbered instances (resource[0], resource[1]). for_each accepts a map or set of strings creating instances with meaningful keys (resource[key]). Key differences: 1) count instances are identified by index — removing an element from the middle causes all subsequent instances to be recreated (shifted indices), 2) for_each instances are identified by key — removing a key only destroys that specific instance, others unchanged, 3) for_each is preferred for resources with distinct configurations, count for truly identical resources. count.index references current index, each.key/each.value references current for_each element.
</details>

<hr>

**41. What is a Terraform Provider?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> A provider is a plugin that implements resource types for a specific API or service. Providers handle authentication, API calls, and resource lifecycle. There are 3000+ providers including: cloud providers (AWS, Azure, GCP), Kubernetes, databases (MySQL, PostgreSQL), monitoring (Datadog, PagerDuty), DNS (Route53, Cloudflare), and more. Configure in provider block: provider aws { region = var.aws_region }. Specify versions with required_providers block. Providers are downloaded during terraform init from the Terraform Registry. Custom providers can be built using the Terraform Plugin SDK.
</details>

<hr>

**42. What is the difference between terraform plan and terraform apply?**

<details>
<summary><b>View Answer</b></summary>
<b>Explanation:</b> `terraform plan` creates an execution plan showing what changes will be made without actually making them — it's a dry run. It shows resources to be created (+), destroyed (-), or modified (~) with the specific attribute changes. It's safe to run anytime. `terraform apply` executes the plan making actual changes to infrastructure. It first shows the same plan and asks for confirmation (unless -auto-approve flag). Best practice: always run plan first and review changes, use plan output files (-out=plan.tfplan) in CI/CD to ensure apply runs exactly the reviewed plan without re-planning.
</details>
