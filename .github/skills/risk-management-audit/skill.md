---
name: risk-management-audit
description: >
  Audits the risk management system required by Article 9 of the EU AI Act.
  Checks for risk identification, analysis, evaluation, mitigation, and testing
  throughout the AI system lifecycle.
---

# Risk Management Audit (Article 9)

Audit compliance with the risk management system requirements for high-risk AI systems.

## Requirements Checklist

### 9(1) — Continuous Risk Management System

**Required**: A risk management system established, implemented, documented, and maintained as a continuous iterative process throughout the entire lifecycle.

**Search patterns**:
```
risk.?manage|risk.?assess|risk.?framework
risk.?register|risk.?matrix|risk.?analysis
risk.?policy|risk.?procedure|risk.?lifecycle
```

**Evidence to check**:
- Risk management documentation (policy, procedures, registers)
- Risk assessment files or configurations
- Integration of risk processes into development lifecycle
- Version control history showing iterative updates

**Assessment criteria**:
- PASS: Documented risk management system with lifecycle integration
- PARTIAL: Some risk documentation exists but not systematic
- FAIL: No risk management system identified

### 9(2) — Risk Identification and Analysis

**Required**: Identification and analysis of known and reasonably foreseeable risks to health, safety, and fundamental rights.

**Search patterns**:
```
risk.?identif|threat.?model|hazard.?analysis
impact.?assess|fundamental.?rights|safety.?risk
health.?risk|bias.?risk|discrimination.?risk
foreseeable.?risk|risk.?catalog|risk.?inventory
```

**Evidence to check**:
- Risk identification documents or threat models
- Fundamental rights impact assessments (FRIA)
- Safety risk analyses
- Bias and discrimination risk assessments

**Assessment criteria**:
- PASS: Comprehensive risk identification covering health, safety, and fundamental rights
- PARTIAL: Risk identification exists but doesn't cover all required areas
- FAIL: No systematic risk identification

### 9(2)(a) — Risks from Intended Purpose

**Required**: Risks arising when the system is used in accordance with its intended purpose.

**Search patterns**:
```
intended.?purpose|intended.?use|designed.?for
use.?case.?risk|normal.?operation.?risk
operational.?risk|deployment.?risk
```

### 9(2)(b) — Risks from Reasonably Foreseeable Misuse

**Required**: Risks arising from reasonably foreseeable misuse.

**Search patterns**:
```
misuse|abuse|unintended.?use|off.?label
adversarial|gaming|manipulation.?risk
foreseeable.?misuse|misuse.?scenario
```

### 9(2)(c) — Risks from Post-Market Monitoring

**Required**: Risks identified through post-market monitoring.

**Search patterns**:
```
post.?market|monitoring|feedback.?loop
incident.?report|user.?feedback|field.?data
performance.?monitor|drift.?detect|degradation
```

### 9(4) — Risk Mitigation Measures

**Required**: Appropriate and targeted risk management measures, including:
- Elimination or reduction of risks through design and development
- Adequate mitigation and control measures for unresolvable risks
- Information and training for users

**Search patterns**:
```
mitigat|safeguard|control.?measure|guardrail
content.?filter|safety.?check|input.?valid
output.?filter|boundary|constraint|limit
fallback|graceful.?degrad|fail.?safe
user.?training|user.?guide|documentation
```

**Evidence to check**:
- Safety guardrails and content filters
- Input validation and output filtering
- Fallback mechanisms and fail-safes
- User documentation and training materials

### 9(5) — Testing and Validation

**Required**: Testing of high-risk AI systems to identify the most appropriate and targeted risk management measures.

**Search patterns**:
```
test.*risk|validat|verification|evaluation
benchmark|stress.?test|adversarial.?test
red.?team|safety.?test|robustness.?test
performance.?test|bias.?test|fairness.?test
```

**Evidence to check**:
- Test suites specifically for risk scenarios
- Adversarial testing and red-teaming evidence
- Bias and fairness evaluation reports
- Safety benchmarks and validation results

### 9(6) — Testing Against Real-World Conditions

**Required**: Testing shall be performed against real-world conditions, and specific metrics and probabilistic thresholds appropriate to the intended purpose.

**Search patterns**:
```
real.?world.?test|production.?test|field.?test
A/B.?test|canary|staging|pre.?production
metric.?threshold|performance.?threshold
acceptance.?criteria|deployment.?gate
```

### 9(7) — Impact on Groups of Persons

**Required**: Testing procedures shall ensure consistent behavior and address specific risks to potentially affected groups.

**Search patterns**:
```
group.?impact|demographic.?test|subgroup.?analysis
fairness.?across|equity.?test|disparate.?impact
protected.?group|minority.?impact|vulnerable.?group
disaggregated.?metric|slice.?analysis
```

## Output Format

```markdown
## Risk Management Audit (Article 9)

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| Continuous risk management system | 9(1) | [STATUS] | [evidence] |
| Risk identification & analysis | 9(2) | [STATUS] | [evidence] |
| Intended purpose risks | 9(2)(a) | [STATUS] | [evidence] |
| Foreseeable misuse risks | 9(2)(b) | [STATUS] | [evidence] |
| Post-market monitoring risks | 9(2)(c) | [STATUS] | [evidence] |
| Risk mitigation measures | 9(4) | [STATUS] | [evidence] |
| Testing & validation | 9(5) | [STATUS] | [evidence] |
| Real-world condition testing | 9(6) | [STATUS] | [evidence] |
| Group impact assessment | 9(7) | [STATUS] | [evidence] |

**Overall Art. 9 Compliance**: [PERCENTAGE]%

### Critical Gaps
[List most important missing elements]

### Remediation Priority
1. [Highest priority action]
2. [Second priority]
3. [Third priority]
```
