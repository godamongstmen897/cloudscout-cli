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

pub trait Rule {
	fn id(&self) -> &'static str;

	fn description(&self) -> &'static str;

	async fn evaluate(&self) -> Result<ScanResult, Box<dyn Error>>;
}
