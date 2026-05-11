mod aws;
mod core;

use std::env;
use std::error::Error;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error + Send + Sync>> {
    let mut args = env::args();
    let _program = args.next();

    match args.next().as_deref() {
        Some("scan") => {
            println!("🛡️  CloudScout CLI v0.1.0 - running scan\n");

            // Load AWS configuration from environment
            println!("📋 Loading AWS configuration...");
            let config = aws_config::load_defaults(aws_config::BehaviorVersion::latest()).await;
            let client = aws_sdk_ec2::Client::new(&config);
            println!("✓ AWS configuration loaded\n");

            // Scan for exposed SSH ports
            println!("🔍 Scanning AWS environment for exposed SSH ports...\n");

            match aws::check_open_ssh(&client).await {
                Ok(vulnerable_groups) => {
                    if vulnerable_groups.is_empty() {
                        println!(
                            "✅ \x1b[32mSecure: No Security Groups are exposing Port 22 to the public internet.\x1b[0m\n"
                        );
                    } else {
                        println!(
                            "⚠️  \x1b[33mWARNING: The following Security Groups are exposing SSH (Port 22) to the public internet:\x1b[0m\n"
                        );
                        for (index, group) in vulnerable_groups.iter().enumerate() {
                            println!("  {}. \x1b[31m{}\x1b[0m", index + 1, group);
                        }
                        println!();
                        println!(
                            "🔒 Recommendation: Restrict SSH access to specific IP addresses or use AWS Systems Manager Session Manager.\n"
                        );
                    }
                    Ok(())
                }
                Err(err) => {
                    eprintln!(
                        "❌ \x1b[31mError scanning Security Groups:\x1b[0m {}\n",
                        err
                    );
                    Err(err)
                }
            }
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
