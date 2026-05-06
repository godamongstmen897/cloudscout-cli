#![allow(dead_code)]
#![allow(deprecated)]
use crate::core::{Rule, ScanResult, Severity};
use async_trait::async_trait;
use aws_sdk_ec2::Client as Ec2Client;

pub struct Ec2SshRule;

#[async_trait]
impl Rule for Ec2SshRule {
    fn id(&self) -> &'static str {
        "AWS-EC2-001"
    }

    fn description(&self) -> &'static str {
        "Checks if EC2 Security Groups allow SSH (Port 22) from anywhere (0.0.0.0/0)"
    }

    async fn evaluate(
        &self,
        client: &Ec2Client,
    ) -> Result<ScanResult, Box<dyn std::error::Error + Send + Sync>> {
        let response = client.describe_security_groups().send().await?;

        let mut violations: Vec<String> = Vec::new();

        for security_group in response.security_groups() {
            let sg_id = security_group.group_id().unwrap_or_default().to_string();
            let sg_name = security_group.group_name().unwrap_or_default().to_string();

            for permission in security_group.ip_permissions() {
                let is_tcp = permission
                    .ip_protocol()
                    .map(|protocol| protocol.eq_ignore_ascii_case("tcp"))
                    .unwrap_or(false);

                let allows_port_22 = match (permission.from_port(), permission.to_port()) {
                    (Some(from_port), Some(to_port)) => from_port <= 22 && to_port >= 22,
                    (Some(port), None) | (None, Some(port)) => port == 22,
                    (None, None) => false,
                };

                let exposes_world_wide = permission
                    .ip_ranges()
                    .iter()
                    .any(|ip_range| ip_range.cidr_ip() == Some("0.0.0.0/0"));

                if is_tcp && allows_port_22 && exposes_world_wide {
                    let label = if !sg_name.is_empty() {
                        format!("{} ({})", sg_name, sg_id)
                    } else {
                        sg_id.clone()
                    };
                    violations.push(label);
                    break;
                }
            }
        }

        if !violations.is_empty() {
            let description = format!(
                "{} Violating security groups: {}",
                self.description(),
                violations.join(", ")
            );

            return Ok(ScanResult {
                rule_id: self.id().to_string(),
                title: "EC2 Security Groups allow SSH from anywhere".to_string(),
                description,
                severity: Severity::Critical,
                passed: false,
            });
        }

        Ok(ScanResult {
            rule_id: self.id().to_string(),
            title: "EC2 Security Group SSH exposure check".to_string(),
            description: self.description().to_string(),
            severity: Severity::Informational,
            passed: true,
        })
    }
}
