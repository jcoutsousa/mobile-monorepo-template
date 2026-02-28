#!/usr/bin/env bash
set -euo pipefail

# ─── Branch Protection Setup ────────────────────────────────
# Configures branch protection rules for the monorepo.
# Requires: gh CLI authenticated with admin access.
#
# Usage: ./scripts/setup-branch-protection.sh [owner/repo]

REPO="${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)}"

if [ -z "$REPO" ]; then
  echo "Usage: $0 <owner/repo>"
  echo "Example: $0 jcoutsousa/my-mobile-app"
  exit 1
fi

echo "Setting up branch protection for $REPO..."
echo ""

# ─── Create branch ruleset via API ──────────────────────────
echo "Creating branch ruleset for 'main'..."

gh api repos/$REPO/rulesets \
  --method POST \
  --field name="Main Branch Protection" \
  --field target="branch" \
  --field enforcement="active" \
  --field 'conditions[ref_name][include][]=refs/heads/main' \
  --field 'rules[][type]=pull_request' \
  --field 'rules[0][parameters][required_approving_review_count]=1' \
  --field 'rules[0][parameters][dismiss_stale_reviews_on_push]=true' \
  --field 'rules[0][parameters][require_last_push_approval]=true' \
  --field 'rules[][type]=required_status_checks' \
  --field 'rules[1][parameters][strict_required_status_checks_policy]=true' \
  --field 'rules[1][parameters][required_status_checks][][context]=CI Gate' \
  --field 'rules[1][parameters][required_status_checks[][context]=Code Quality Sweep' \
  --field 'rules[1][parameters][required_status_checks[][context]=Security Scan' \
  --field 'rules[1][parameters][required_status_checks[][context]=Copilot Review Status' \
  --field 'rules[][type]=deletion' \
  --field 'rules[][type]=non_fast_forward' \
  2>/dev/null && echo "✅ Ruleset created" || echo "⚠️  Ruleset creation via API failed — set up manually (see below)"

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  Manual Setup Steps (if API call failed)"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "1. Go to: https://github.com/$REPO/settings/rules"
echo ""
echo "2. Create a new Branch Ruleset:"
echo "   - Name: Main Branch Protection"
echo "   - Enforcement: Active"
echo "   - Target: Include default branch (main)"
echo ""
echo "3. Add these rules:"
echo "   ✅ Restrict deletions"
echo "   ✅ Require a pull request before merging"
echo "      - Required approvals: 1"
echo "      - Dismiss stale reviews on push"
echo "      - Require approval of most recent push"
echo "   ✅ Require status checks to pass"
echo "      - Required checks:"
echo "        • CI Gate"
echo "        • Code Quality Sweep"
echo "        • Security Scan"
echo "        • Copilot Review Status"
echo "   ✅ Block force pushes"
echo ""
echo "4. Enable Copilot auto-review:"
echo "   - Go to: https://github.com/$REPO/settings/rules"
echo "   - Add rule: 'Automatically request Copilot code review'"
echo "   - Check: 'Review new pushes'"
echo "   - Check: 'Review draft pull requests' (optional)"
echo ""
echo "5. (Optional) For AI apps, also require:"
echo "   • EU AI Act Compliance Check"
echo ""
echo "═══════════════════════════════════════════════════════"
