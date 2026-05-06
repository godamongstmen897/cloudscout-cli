mod aws;
mod core;

use crate::aws::Ec2SshRule;
use crate::core::Rule;
use std::env;
use std::error::Error;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error + Send + Sync>> {
    let mut args = env::args();
    let _program = args.next();

    match args.next().as_deref() {
        Some("scan") => {
            println!("🛡️  CloudScout CLI v0.1.0 - running scan");

            // Initialize AWS SDK and create EC2 client
            let config = aws_config::load_defaults(aws_config::BehaviorVersion::latest()).await;
            let client = aws_sdk_ec2::Client::new(&config);

            // Execute rule (pass the client by reference so it's reused)
            let rule = Ec2SshRule;
            let result = rule.evaluate(&client).await?;

            if result.passed {
                println!("Scan passed: {}", result.title);
            } else {
                println!("CRITICAL: {} - {}", result.title, result.description);
            }

            Ok(())
        }
        _ => {
            println!("🛡️  CloudScout CLI v0.1.0");
            println!("A lightning-fast AWS Security Posture Management tool.\n");
            println!("USAGE:");
            println!("    cloudscout [OPTIONS] <SUBCOMMAND>\n");
            println!("SUBCOMMANDS:");
            println!("    scan      Run security audit on AWS EC2 and IAM environments");
            println!("    report    Generate compliance report");
            println!("    help      Print this message or the help of the given subcommand(s)");
            Ok(())
        }
    }
}
