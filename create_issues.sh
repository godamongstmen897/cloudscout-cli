#!/bin/bash

gh issue create \
  --title "feat(aws-rule): Write rule to flag EC2 instances with exposed SSH (Port 22) to 0.0.0.0/0" \
  --body "## Context
Detect EC2 instances with overly permissive SSH access that exposes them to the public internet.

## Requirements
- Scan EC2 security groups for inbound rules allowing SSH (port 22) from 0.0.0.0/0
- Report affected instances and their security group configurations

## Complexity
- Level: Medium (150 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to detect IAM policies using overly permissive wildcards (Action: *)" \
  --body "## Context
Identify IAM policies that grant unrestricted permissions using wildcard actions.

## Requirements
- Scan IAM policies for Action: * (all actions) permissions
- Flag roles and users with such policies and recommend principle of least privilege

## Complexity
- Level: Medium (150 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to scan for public read/write access on S3 buckets" \
  --body "## Context
Detect S3 buckets with public access that could expose sensitive data.

## Requirements
- Check S3 bucket ACLs and bucket policies for public (AllUsers or AuthenticatedUsers) read/write permissions
- Report buckets with public access and their current permissions

## Complexity
- Level: High (200 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to ensure default VPC security groups restrict all inbound traffic" \
  --body "## Context
Verify that default security groups in VPCs are properly configured to block unauthorized access.

## Requirements
- Check default security groups for inbound rules
- Ensure they allow no unrestricted inbound traffic (only restricted or no rules)

## Complexity
- Level: Medium (150 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to verify RDS databases are not publicly accessible" \
  --body "## Context
Ensure RDS database instances are not exposed to the public internet.

## Requirements
- Check RDS instance settings for PubliclyAccessible flag
- Verify database security groups restrict access appropriately

## Complexity
- Level: Medium (150 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to ensure CloudTrail is enabled across all regions" \
  --body "## Context
Verify that CloudTrail logging is active to maintain audit trails across all AWS regions.

## Requirements
- Check if CloudTrail is enabled organization-wide or per region
- Verify S3 destination and log retention settings

## Complexity
- Level: Medium (150 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to verify MFA is enabled for the root IAM account" \
  --body "## Context
Confirm multi-factor authentication is configured for the AWS account root user.

## Requirements
- Check root account MFA status from IAM credential report
- Recommend enabling MFA immediately if not active

## Complexity
- Level: High (200 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to check if S3 bucket server-side encryption is enabled by default" \
  --body "## Context
Verify that S3 buckets encrypt objects at rest by default.

## Requirements
- Check S3 bucket encryption settings (SSE-S3, SSE-KMS, or DSSE-KMS)
- Identify buckets without default encryption enabled

## Complexity
- Level: Medium (150 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to flag unattached Elastic IP addresses" \
  --body "## Context
Detect unused Elastic IP addresses that incur costs and may indicate misconfiguration.

## Requirements
- List all Elastic IPs not currently associated with instances or network interfaces
- Flag for cleanup to reduce costs

## Complexity
- Level: Trivial (100 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to detect unencrypted EBS volumes" \
  --body "## Context
Identify EBS volumes that are not encrypted at rest.

## Requirements
- Scan all EBS volumes for encryption status
- Report volumes without encryption and recommend enabling encryption

## Complexity
- Level: Medium (150 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(aws-rule): Write rule to verify IAM password policies enforce length and symbols" \
  --body "## Context
Ensure IAM password policies meet strong security standards.

## Requirements
- Check account password policy for minimum length requirements
- Verify policy enforces symbols, numbers, and mixed case requirements

## Complexity
- Level: Medium (150 pts)" \
  --label "aws-rule"

gh issue create \
  --title "feat(core): Build the AWS SDK integration module to authenticate securely" \
  --body "## Context
Create a robust module for secure AWS credential handling and authentication.

## Requirements
- Implement secure AWS SDK initialization with credential chain support
- Add support for IAM roles, environment variables, and profile-based auth
- Implement credential validation and error handling

## Complexity
- Level: High (200 pts)" \
  --label "core"

gh issue create \
  --title "feat(docker-rule): Write rule to verify the Docker socket is not exposed to external IPs" \
  --body "## Context
Detect Docker socket exposure that could allow unauthorized container manipulation.

## Requirements
- Check Docker daemon configuration for socket binding to external interfaces
- Scan for exposed docker.sock on network interfaces (0.0.0.0)

## Complexity
- Level: High (200 pts)" \
  --label "docker-rule"

gh issue create \
  --title "feat(docker-rule): Write rule to flag Dockerfiles that run containers as root" \
  --body "## Context
Identify Dockerfiles without an explicit non-root user declaration.

## Requirements
- Parse Dockerfiles and check for USER directive
- Flag files without USER or those that specify root as the running user

## Complexity
- Level: Medium (150 pts)" \
  --label "docker-rule"

gh issue create \
  --title "feat(linux-rule): Write rule to check if UFW firewall is active on Ubuntu/Linux" \
  --body "## Context
Verify that UFW firewall is enabled and actively protecting the system.

## Requirements
- Check UFW status via system commands (ufw status)
- Verify firewall is active and rules are configured appropriately

## Complexity
- Level: Medium (150 pts)" \
  --label "linux-rule"

gh issue create \
  --title "feat(linux-rule): Write rule to verify root SSH login is disabled in sshd_config" \
  --body "## Context
Ensure direct root login via SSH is disabled to prevent unauthorized access.

## Requirements
- Parse /etc/ssh/sshd_config for PermitRootLogin setting
- Flag if set to yes or not explicitly set to no

## Complexity
- Level: Medium (150 pts)" \
  --label "linux-rule"

gh issue create \
  --title "feat(linux-rule): Write rule to audit .bash_history for plain-text AWS access keys" \
  --body "## Context
Detect inadvertently exposed AWS credentials in shell history.

## Requirements
- Scan .bash_history files for patterns matching AWS access key formats
- Flag users with exposed credentials for immediate rotation

## Complexity
- Level: High (200 pts)" \
  --label "linux-rule"

gh issue create \
  --title "feat(docker-rule): Write rule to flag Docker images running without a defined HEALTHCHECK" \
  --body "## Context
Identify Dockerfiles that lack health check definitions for container monitoring.

## Requirements
- Parse Dockerfiles and check for HEALTHCHECK instruction
- Flag images without health checks and recommend adding monitoring

## Complexity
- Level: Medium (150 pts)" \
  --label "docker-rule"

gh issue create \
  --title "feat(docker-rule): Write rule to detect Docker containers running in --privileged mode" \
  --body "## Context
Identify containers with excessive privilege levels that bypass security restrictions.

## Requirements
- Detect docker run commands or container specs with --privileged flag
- Flag for security review and recommend privilege restriction

## Complexity
- Level: High (200 pts)" \
  --label "docker-rule"

gh issue create \
  --title "feat(linux-rule): Write rule to scan for world-writable system files" \
  --body "## Context
Detect system files with overly permissive write access that could enable privilege escalation.

## Requirements
- Scan file system for world-writable files (chmod 777 or o+w)
- Exclude expected world-writable directories (/tmp, /var/tmp, etc.)

## Complexity
- Level: Medium (150 pts)" \
  --label "linux-rule"

gh issue create \
  --title "feat(linux-rule): Write rule to verify secure file permissions (rwx) on cron jobs" \
  --body "## Context
Ensure cron job files have restricted permissions to prevent unauthorized modifications.

## Requirements
- Check permissions on crontab files and /etc/cron.d entries
- Verify only root or job owner can modify cron jobs

## Complexity
- Level: Medium (150 pts)" \
  --label "linux-rule"

gh issue create \
  --title "feat(docker-rule): Write rule to flag the use of the 'latest' tag in Dockerfiles" \
  --body "## Context
Identify Dockerfile base images using 'latest' tag for reproducibility issues.

## Requirements
- Parse Dockerfiles for FROM statements using 'latest' or no explicit tag
- Recommend pinning to specific stable version tags

## Complexity
- Level: Trivial (100 pts)" \
  --label "docker-rule"

gh issue create \
  --title "feat(linux-rule): Write rule to check for users with passwordless sudo privileges" \
  --body "## Context
Detect users who can run sudo commands without requiring a password.

## Requirements
- Parse /etc/sudoers and related files for NOPASSWD entries
- Flag users with passwordless sudo access for security review

## Complexity
- Level: Medium (150 pts)" \
  --label "linux-rule"

gh issue create \
  --title "feat(docker-rule): Write rule to flag plain-text secrets in Docker environment variables" \
  --body "## Context
Identify hardcoded secrets in Docker environment variable definitions.

## Requirements
- Scan Dockerfiles and compose files for ENV directives containing credentials
- Flag potential API keys, passwords, and tokens for remediation

## Complexity
- Level: Medium (150 pts)" \
  --label "docker-rule"

gh issue create \
  --title "feat(core): Build the Local File System scanning engine module" \
  --body "## Context
Implement a comprehensive module for scanning local file systems for security rules.

## Requirements
- Create abstraction layer for file system traversal and permission checks
- Support recursive scanning with configurable filters and exclusion patterns
- Implement efficient caching for large directory trees

## Complexity
- Level: High (200 pts)" \
  --label "core"

gh issue create \
  --title "feat(frontend): Design the Next.js Tailwind CSS layout for the docs site" \
  --body "## Context
Create a professional, responsive documentation site layout using Next.js and Tailwind CSS.

## Requirements
- Design main layout with navigation sidebar and content area
- Implement responsive design for mobile, tablet, and desktop
- Create reusable component templates for docs pages

## Complexity
- Level: Trivial (100 pts)" \
  --label "frontend"

gh issue create \
  --title "feat(documentation): Write the AWS rules documentation page" \
  --body "## Context
Document all AWS security rules with examples and remediation guidance.

## Requirements
- Write detailed documentation for each AWS rule (11-21)
- Include rule descriptions, what they check, and how to remediate findings
- Add example findings and AWS best practices

## Complexity
- Level: Trivial (100 pts)" \
  --label "documentation"

gh issue create \
  --title "feat(documentation): Write the Linux and Docker rules documentation page" \
  --body "## Context
Document all Linux and Docker security rules with remediation steps.

## Requirements
- Write detailed documentation for each Linux rule (25-27, 30-31, 33)
- Write detailed documentation for each Docker rule (23-24, 28-29, 32, 34)
- Include system hardening guidelines and best practices

## Complexity
- Level: Trivial (100 pts)" \
  --label "documentation"

gh issue create \
  --title "feat(infrastructure): Add automated release binary builds to GitHub Actions" \
  --body "## Context
Automate building and releasing compiled CloudScout binaries across platforms.

## Requirements
- Create GitHub Actions workflow for cross-platform builds (Linux, macOS, Windows)
- Automate binary upload to GitHub Releases on version tags
- Include code signing and release notes generation

## Complexity
- Level: Medium (150 pts)" \
  --label "infrastructure"

gh issue create \
  --title "feat(core): Implement an interactive CLI setup wizard (cloudscout init)" \
  --body "## Context
Create an onboarding wizard to help users configure CloudScout for their environment.

## Requirements
- Implement interactive prompts for AWS credentials, local file paths, and scan settings
- Generate and save configuration file based on user inputs
- Validate configuration before saving and offer guidance on each setting

## Complexity
- Level: Medium (150 pts)" \
  --label "core"

gh issue create \
  --title "feat(core): Add integration tests for the rule execution engine" \
  --body "## Context
Create end-to-end coverage for running rules against representative sample targets.

## Requirements
- Build an integration test harness for executing multiple rules against fixtures
- Verify scan results, failure handling, and exit codes across common scenarios

## Complexity
- Level: High (200 pts)" \
  --label "core"

gh issue create \
  --title "feat(core): Add snapshot tests for JSON and terminal table formatters" \
  --body "## Context
Prevent regressions in the rendered output formats used by users and automation.

## Requirements
- Capture stable snapshots for JSON scan output
- Capture stable snapshots for terminal table formatting across representative findings

## Complexity
- Level: Medium (150 pts)" \
  --label "core"

gh issue create \
  --title "feat(core): Implement configuration validation and schema versioning" \
  --body "## Context
Ensure CloudScout configuration files remain forward-compatible and easy to validate.

## Requirements
- Validate required configuration fields and value ranges before scans run
- Add a versioned schema or migration path for future config changes

## Complexity
- Level: Medium (150 pts)" \
  --label "core"

gh issue create \
  --title "feat(infrastructure): Add end-to-end smoke tests to GitHub Actions" \
  --body "## Context
Run a basic real-world scan in CI to catch regressions before release.

## Requirements
- Execute the compiled CLI against sample fixtures during CI
- Verify the binary starts, scans, and emits expected output without failure

## Complexity
- Level: High (200 pts)" \
  --label "infrastructure"

gh issue create \
  --title "feat(infrastructure): Add dependency audit checks to the CI pipeline" \
  --body "## Context
Automatically detect vulnerable or outdated dependencies during development and release.

## Requirements
- Run dependency vulnerability auditing in GitHub Actions
- Fail CI on high-severity issues or known unsafe dependency states

## Complexity
- Level: Medium (150 pts)" \
  --label "infrastructure"

gh issue create \
  --title "feat(core): Improve CLI error messages and exit code consistency" \
  --body "## Context
Make CloudScout failures easier to understand and automate against.

## Requirements
- Standardize exit codes for common failure categories
- Replace generic errors with actionable, user-facing messages

## Complexity
- Level: Medium (150 pts)" \
  --label "core"

gh issue create \
  --title "feat(core): Add benchmarks for large directory scan performance" \
  --body "## Context
Measure scan performance so large repositories and file trees stay responsive.

## Requirements
- Add benchmark cases for large recursive directory scans
- Track regressions in traversal and rule execution timing over time

## Complexity
- Level: Medium (150 pts)" \
  --label "core"

gh issue create \
  --title "feat(documentation): Expand troubleshooting guidance for common CLI failures" \
  --body "## Context
Help users diagnose common setup and execution problems more quickly.

## Requirements
- Document authentication, permissions, and output formatting failures
- Add fixes for Docker, Linux, and AWS credential-related issues

## Complexity
- Level: Trivial (100 pts)" \
  --label "documentation"

gh issue create \
  --title "feat(frontend): Add docs search and navigation polish" \
  --body "## Context
Make the documentation site easier to browse as the content grows.

## Requirements
- Add search or quick navigation for docs pages
- Improve active section highlighting and mobile navigation behavior

## Complexity
- Level: Trivial (100 pts)" \
  --label "frontend"

gh issue create \
  --title "feat(infrastructure): Automate release artifact verification in GitHub Actions" \
  --body "## Context
Verify release binaries and checksums before publishing them to users.

## Requirements
- Validate generated artifacts exist for each target platform
- Verify checksum generation and release asset completeness in CI

## Complexity
- Level: Medium (150 pts)" \
  --label "infrastructure"
