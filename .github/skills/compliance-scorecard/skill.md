---
name: compliance-scorecard
description: >
  Generates a comprehensive EU AI Act compliance scorecard with pass/fail status
  per article, compliance percentages, risk classification summary, and overall
  compliance determination. Aggregates results from all other audit skills.
---

# Compliance Scorecard Generator

Aggregate all audit findings into a comprehensive compliance scorecard.

## Scorecard Generation Process

### Step 1: Collect Audit Results

Gather findings from all applicable audit skills:
- Risk classification result
- Prohibited practices check
- Risk management audit (Art. 9)
- Data governance audit (Art. 10)
- Technical documentation audit (Art. 11)
- Record-keeping audit (Art. 12)
- Transparency audit (Art. 13 + 50)
- Human oversight audit (Art. 14)
- Accuracy & robustness audit (Art. 15)
- GPAI compliance audit (Art. 51-56)

### Step 2: Calculate Compliance Scores

For each article, calculate:
- **Number of requirements checked**
- **Number PASS**: Full compliance evidence found
- **Number PARTIAL**: Some compliance evidence but gaps exist
- **Number FAIL**: No compliance evidence or clear violation
- **Article compliance %**: (PASS + 0.5*PARTIAL) / total * 100

### Step 3: Determine Overall Status

| Overall Score | Status | Meaning |
|---------------|--------|---------|
| 90-100% | COMPLIANT | Meets requirements, minor improvements possible |
| 70-89% | MOSTLY COMPLIANT | Key areas covered, some gaps to address |
| 50-69% | PARTIALLY COMPLIANT | Significant gaps requiring attention |
| 25-49% | LARGELY NON-COMPLIANT | Major compliance work needed |
| 0-24% | NON-COMPLIANT | Fundamental compliance gaps |

### Step 4: Prioritize Findings

Assign priority based on:
- **CRITICAL**: Prohibited practices detected (immediate action required)
- **HIGH**: High-risk requirements with FAIL status
- **MEDIUM**: High-risk requirements with PARTIAL status
- **LOW**: Limited-risk requirements or best practices

## Output Format

```markdown
# EU AI Act Compliance Scorecard

╔══════════════════════════════════════════════════════════════════╗
║                  EU AI ACT COMPLIANCE SCORECARD                 ║
╠══════════════════════════════════════════════════════════════════╣
║  Application: [name]                                            ║
║  Repository:  [owner/repo]                                      ║
║  Scan Date:   [date]                                            ║
║  Risk Level:  [UNACCEPTABLE / HIGH / LIMITED / MINIMAL]         ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  OVERALL COMPLIANCE: [XX]% — [STATUS]                           ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║ Article │ Requirement                    │ Status  │ Score      ║
╠═════════╪════════════════════════════════╪═════════╪════════════╣
║ Art. 5  │ Prohibited Practices           │ [STAT]  │ [XXX]%    ║
║ Art. 6  │ Risk Classification            │ [STAT]  │ [XXX]%    ║
║ Art. 9  │ Risk Management System         │ [STAT]  │ [XXX]%    ║
║ Art. 10 │ Data & Data Governance         │ [STAT]  │ [XXX]%    ║
║ Art. 11 │ Technical Documentation        │ [STAT]  │ [XXX]%    ║
║ Art. 12 │ Record-keeping & Logging       │ [STAT]  │ [XXX]%    ║
║ Art. 13 │ Transparency (High-Risk)       │ [STAT]  │ [XXX]%    ║
║ Art. 14 │ Human Oversight                │ [STAT]  │ [XXX]%    ║
║ Art. 15 │ Accuracy & Robustness          │ [STAT]  │ [XXX]%    ║
║ Art. 50 │ Transparency (Limited-Risk)    │ [STAT]  │ [XXX]%    ║
║ Art. 53 │ GPAI General Obligations       │ [STAT]  │ [XXX]%    ║
║ Art. 55 │ GPAI Systemic Risk             │ [STAT]  │ [XXX]%    ║
╚═════════╧════════════════════════════════╧═════════╧════════════╝

## Detailed Findings

### CRITICAL Issues (Immediate Action Required)
[List any prohibited practice violations]

### HIGH Priority Gaps
[List FAIL findings for applicable high-risk requirements]

### MEDIUM Priority Gaps
[List PARTIAL findings for applicable requirements]

### LOW Priority Improvements
[List optional improvements and best practices]

## Compliance Summary by Category

### Technical Requirements
- Risk Management: [X/Y requirements met]
- Data Governance: [X/Y requirements met]
- Accuracy & Robustness: [X/Y requirements met]
- Record-keeping: [X/Y requirements met]

### Documentation Requirements
- Technical Documentation: [X/Y sections present]
- Transparency: [X/Y disclosures implemented]
- Human Oversight Docs: [X/Y elements documented]

### Organizational Requirements
- Copyright Compliance: [status]
- Incident Reporting: [status]
- Post-Market Monitoring: [status]

## Next Steps

### Immediate Actions (Week 1)
1. [Most critical action]
2. [Second critical action]

### Short-term Actions (Month 1)
1. [Important action]
2. [Second important action]

### Medium-term Actions (Quarter 1)
1. [Improvement action]
2. [Second improvement]

## Disclaimers

1. This is a technical pre-assessment, not legal advice
2. Final compliance requires qualified legal review
3. Some requirements depend on organizational context not visible in code
4. The EU AI Act is subject to ongoing regulatory interpretation
5. High-risk AI systems require conformity assessment by notified bodies
6. This assessment covers code-level evidence only — organizational processes,
   contracts, and governance structures require separate evaluation
```
