#!/bin/bash

##############################################################################
# ship-it.sh - Local CI/CD Pipeline for Rust CLI Tools
# 
# This script implements a complete CI/CD pipeline that:
# 1. Runs quality checks (formatting, linting, testing)
# 2. Automatically creates GitHub issues for failures
# 3. Commits and pushes changes if all checks pass
##############################################################################

set -o pipefail

# Color output for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script variables
SCRIPT_NAME="$(basename "$0")"
FAILED_CHECK_NAME=""
FAILED_CHECK_DETAILS=""
FAILED_CHECKS_ARRAY=()

##############################################################################
# Utility Functions
##############################################################################

print_header() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_separator() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

##############################################################################
# Pre-flight Checks
##############################################################################

check_requirements() {
    print_header "Checking prerequisites..."
    
    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        print_error "GitHub CLI (gh) is not installed"
        echo "Please install it: https://cli.github.com"
        exit 1
    fi
    
    # Check if gh is authenticated
    if ! gh auth status &> /dev/null; then
        print_error "GitHub CLI is not authenticated"
        echo "Please run: gh auth login"
        exit 1
    fi
    
    # Check if cargo is available
    if ! command -v cargo &> /dev/null; then
        print_error "Cargo is not installed"
        echo "Please install Rust: https://rustup.rs"
        exit 1
    fi
    
    # Check if git is available
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed"
        exit 1
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        exit 1
    fi
    
    print_success "All prerequisites met"
    log_separator
}

##############################################################################
# Quality Check Functions
##############################################################################

run_formatting_check() {
    print_header "Running formatting check (cargo fmt -- --check)..."
    
    local output
    output=$(cargo fmt -- --check 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_success "Formatting check passed"
        return 0
    else
        print_error "Formatting check failed"
        FAILED_CHECK_NAME="Formatting"
        FAILED_CHECK_DETAILS="$output"
        FAILED_CHECKS_ARRAY+=("Formatting")
        return 1
    fi
}

run_linting_check() {
    print_header "Running linting check (cargo clippy -- -D warnings)..."
    
    local output
    output=$(cargo clippy -- -D warnings 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_success "Linting check passed"
        return 0
    else
        print_error "Linting check failed"
        FAILED_CHECK_NAME="Linting"
        FAILED_CHECK_DETAILS="$output"
        FAILED_CHECKS_ARRAY+=("Linting")
        return 1
    fi
}

run_testing_check() {
    print_header "Running testing check (cargo test)..."
    
    local output
    output=$(cargo test 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_success "Testing check passed"
        return 0
    else
        print_error "Testing check failed"
        FAILED_CHECK_NAME="Testing"
        FAILED_CHECK_DETAILS="$output"
        FAILED_CHECKS_ARRAY+=("Testing")
        return 1
    fi
}

##############################################################################
# Issue Creation Function - Drips Wave Compliant
##############################################################################

determine_complexity_label() {
    local check_type="$1"
    
    case "$check_type" in
        "Formatting"|"Linting")
            echo "Complexity: Trivial"
            ;;
        "Testing")
            echo "Complexity: Medium"
            ;;
        *)
            echo "Complexity: Medium"
            ;;
    esac
}

determine_points() {
    local check_type="$1"
    
    case "$check_type" in
        "Formatting"|"Linting")
            echo "100"
            ;;
        "Testing")
            echo "150"
            ;;
        *)
            echo "150"
            ;;
    esac
}

create_issue_for_failure() {
    print_warning "Creating GitHub issue for pipeline failure (Drips Wave compliant)..."
    
    # Use the first failed check for the issue (or the most recent one)
    local check_name="${FAILED_CHECKS_ARRAY[-1]}"
    local complexity_label=$(determine_complexity_label "$check_name")
    local points=$(determine_points "$check_name")
    
    # Build the issue title
    local issue_title="[Automated QA] Resolve $check_name Failure"
    
    # Build the Drips Wave compliant issue body using a heredoc
    local issue_body
    read -r -d '' issue_body << 'EOF' || true
## 🤖 Automated Pipeline Failure

The automated CI/CD pipeline caught an error during the quality checks phase. This issue requires resolution to maintain codebase health and ensure all contributions meet our quality standards.

### 📋 Error Details

```
EOF
    
    # Append the actual error output
    issue_body="${issue_body}${FAILED_CHECK_DETAILS}"
    
    # Complete the issue body with remaining sections
    read -r -d '' remaining_body << 'EOF' || true
```

### 📚 Requirements & Context

Resolving this quality check failure is **required** to maintain:
- **Code Quality**: Ensures consistent formatting and adherence to Rust best practices
- **Project Health**: Prevents technical debt and improves maintainability
- **Contributor Standards**: Maintains the quality bar for all community contributions

### 🚀 Suggested Execution

Follow these steps to resolve this issue:

1. **Fork and Setup**
   - Fork the repository to your GitHub account
   - Clone your fork locally: `git clone https://github.com/<your-username>/cloudscout-cli.git`
   - Add upstream remote: `git remote add upstream https://github.com/douglas/cloudscout-cli.git`

2. **Create a Feature Branch**
   - Create a branch for your fix: `git checkout -b fix/pipeline-error`

3. **Reproduce and Fix Locally**
   - Run the failing command to verify the error:
   ```bash
   cargo fmt -- --check  # For formatting errors
   cargo clippy -- -D warnings  # For linting errors
   cargo test  # For testing errors
   ```
   - Apply necessary fixes to pass the quality check

4. **Verify the Fix**
   - Re-run the failing command to confirm it now passes

5. **Commit and Push**
   - Stage your changes: `git add .`
   - Commit with a clear message: `git commit -m "fix: resolve quality check failure"`
   - Push to your fork: `git push origin fix/pipeline-error`

6. **Submit a Pull Request**
   - Open a PR against the main repository
   - **Important:** Your PR description must include `Closes #<issue_id>`
   - Example: `Closes #42 - This PR resolves the formatting check failure`

### 📍 Labels & Complexity

- **Complexity**: 
EOF
    
    issue_body="${issue_body}${remaining_body}${complexity_label} (${points} points)"
    
    # Add final footer
    read -r -d '' footer << 'EOF' || true

### 💡 Need Help?

- Check the [Rust Documentation](https://www.rust-lang.org/learn)
- Review our [CONTRIBUTING.md](../CONTRIBUTING.md) guide
- Join our community discussions

---
*🤖 This issue was automatically created by the ship-it.sh CI/CD pipeline.*
EOF
    
    issue_body="${issue_body}${footer}"
    
    # Create the GitHub issue with proper labels
    local labels="bug,${complexity_label}"
    
    if gh issue create \
        --title "$issue_title" \
        --label "bug" \
        --label "$complexity_label" \
        --body "$issue_body" > /dev/null 2>&1; then
        print_success "GitHub issue created successfully (ID tracked in remote)"
    else
        print_error "Failed to create GitHub issue"
        print_warning "You may need to check your GitHub authentication"
        return 1
    fi
}

##############################################################################
# Git Operations Functions
##############################################################################

stage_changes() {
    print_header "Staging changes (git add .)..."
    
    if git add . 2> /dev/null; then
        print_success "Changes staged"
        return 0
    else
        print_error "Failed to stage changes"
        return 1
    fi
}

commit_changes() {
    print_header "Preparing to commit changes..."
    
    # Check if there are staged changes
    if ! git diff --cached --quiet; then
        echo ""
        echo "Enter your commit message:"
        read -r commit_message
        
        if [ -z "$commit_message" ]; then
            print_error "Commit message cannot be empty"
            return 1
        fi
        
        if git commit -m "$commit_message" > /dev/null 2>&1; then
            print_success "Changes committed with message: \"$commit_message\""
            return 0
        else
            print_error "Failed to commit changes"
            return 1
        fi
    else
        print_warning "No staged changes to commit"
        return 0
    fi
}

push_changes() {
    print_header "Pushing changes to repository..."
    
    # Get current branch
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    
    if git push origin "$current_branch" 2> /dev/null; then
        print_success "Changes pushed to $current_branch"
        return 0
    else
        print_error "Failed to push changes to $current_branch"
        print_warning "Please check your git configuration and network connection"
        return 1
    fi
}

##############################################################################
# Main Pipeline
##############################################################################

main() {
    echo ""
    print_header "Starting CI/CD Pipeline (ship-it.sh)"
    log_separator
    echo ""
    
    # Pre-flight checks
    check_requirements
    
    # Run quality checks
    local all_passed=true
    
    run_formatting_check || all_passed=false
    echo ""
    
    run_linting_check || all_passed=false
    echo ""
    
    run_testing_check || all_passed=false
    echo ""
    
    log_separator
    echo ""
    
    # Handle results
    if [ "$all_passed" = true ]; then
        print_success "All quality checks passed! ✨"
        echo ""
        
        # Proceed with git operations
        stage_changes || exit 1
        echo ""
        
        commit_changes || exit 1
        echo ""
        
        push_changes || exit 1
        echo ""
        
        log_separator
        print_success "Pipeline completed successfully! 🚀"
        exit 0
    else
        print_error "Pipeline failed due to quality check failures"
        echo ""
        echo "Failed checks:"
        for check in "${FAILED_CHECKS_ARRAY[@]}"; do
            echo "  • $check"
        done
        echo ""
        
        # Create GitHub issue
        create_issue_for_failure || exit 1
        echo ""
        
        log_separator
        print_error "Pipeline failed. GitHub issue created for tracking."
        exit 1
    fi
}

##############################################################################
# Error Trap
##############################################################################

trap 'print_error "Pipeline interrupted"; exit 130' INT TERM

##############################################################################
# Execute Main
##############################################################################

main "$@"
