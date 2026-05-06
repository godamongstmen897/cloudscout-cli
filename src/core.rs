#![allow(dead_code)]
use async_trait::async_trait;
use aws_sdk_ec2::Client as Ec2Client;
use std::error::Error;

#[derive(Debug, Clone, PartialEq)]
pub enum Severity {
    Critical,
    High,
    Medium,
    Low,
    Informational,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ScanResult {
    pub rule_id: String,
    pub title: String,
    pub description: String,
    pub severity: Severity,
    pub passed: bool,
}

#[async_trait]
pub trait Rule {
    fn id(&self) -> &'static str;

    fn description(&self) -> &'static str;

    async fn evaluate(
        &self,
        client: &Ec2Client,
    ) -> Result<ScanResult, Box<dyn Error + Send + Sync>>;
}
