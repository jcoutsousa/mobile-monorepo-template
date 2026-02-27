---
name: technical-documentation-audit
description: >
  Audits technical documentation required by Article 11 and Annex IV of the EU AI Act.
  Checks for all 7 required documentation sections including system description, design,
  monitoring, risk management, and change management documentation.
---

# Technical Documentation Audit (Article 11 + Annex IV)

Audit compliance with technical documentation requirements for high-risk AI systems.

## Requirements Checklist

### 11(1) — Documentation Before Market Placement

**Required**: Technical documentation shall be drawn up before the system is placed on the market or put into service, and kept up to date.

**Search patterns for documentation files**:
```
README|DOCUMENTATION|TECHNICAL_DOC|SYSTEM_DOC
docs/|documentation/|doc/|wiki/
model.?card|system.?card|data.?sheet
ARCHITECTURE|DESIGN|SPECIFICATION
```

### Annex IV Section 1 — General Description

**Required**:
- Intended purpose
- Name and contact of the provider
- Version history
- Interaction with other systems (hardware/software)
- Relevant standards applied

**Search patterns**:
```
intended.?purpose|product.?description|system.?overview
version.?history|changelog|CHANGES
provider.?info|manufacturer|contact
hardware.?requirement|software.?requirement|dependency
standard.?compliance|ISO|IEC|IEEE
```

### Annex IV Section 2 — Design Specifications

**Required**:
- General logic and algorithms
- Key design choices and rationale
- System architecture description
- Computational resources
- Data requirements

**Search patterns**:
```
architecture|design.?doc|system.?design|ADR
algorithm.?description|model.?description
design.?decision|design.?rationale|trade.?off
computational.?resource|infrastructure
data.?requirement|input.?specification|output.?specification
```

### Annex IV Section 3 — Development Process

**Required**:
- Design and development methodology
- Pre-trained systems and third-party tools used
- Training and testing procedures and results
- Data management practices

**Search patterns**:
```
development.?process|methodology|agile|mlops
pre.?trained|transfer.?learn|fine.?tun
third.?party|external.?model|vendor
training.?procedure|testing.?procedure
training.?result|evaluation.?result|benchmark
data.?management|data.?pipeline|data.?process
```

### Annex IV Section 4 — Monitoring and Functioning

**Required**:
- Capabilities and limitations
- Degree of accuracy and metrics
- Foreseeable unintended outcomes and risks
- Human-machine interface specifications

**Search patterns**:
```
capability|limitation|known.?issue|constraint
accuracy|precision|recall|f1.?score|AUC|metric
performance.?report|evaluation.?report|benchmark.?result
unintended.?outcome|side.?effect|edge.?case
human.?machine|user.?interface|API.?spec
```

### Annex IV Section 5 — Validation and Testing

**Required**:
- Validation and testing procedures
- Metrics used and test results
- Testing against specific persons or groups affected

**Search patterns**:
```
validation.?report|test.?report|evaluation
test.?suite|test.?plan|test.?strategy
metric.?report|performance.?metric
group.?test|demographic.?test|subgroup.?analysis
```

### Annex IV Section 6 — Risk Management

**Required**: Description of the risk management system per Article 9.

**Search patterns**:
```
risk.?management.?doc|risk.?register|risk.?report
risk.?assessment.?doc|risk.?policy|risk.?framework
FRIA|fundamental.?rights.?impact
```

### Annex IV Section 7 — Changes and Lifecycle

**Required**:
- Description of changes made during the lifecycle
- Post-market monitoring plan
- Change management procedures

**Search patterns**:
```
change.?log|change.?management|version.?control
post.?market.?monitor|lifecycle.?management
update.?procedure|maintenance.?plan
incident.?response|corrective.?action
```

## Documentation Quality Assessment

For each documentation section found, assess:

1. **Completeness**: Does it cover all required elements?
2. **Currency**: Is it up to date with the current system version?
3. **Clarity**: Is it understandable by the intended audience?
4. **Traceability**: Can requirements be traced to implementation?

## Output Format

```markdown
## Technical Documentation Audit (Article 11 + Annex IV)

| Section | Annex IV | Status | Files Found |
|---------|----------|--------|-------------|
| General Description | Section 1 | [STATUS] | [files] |
| Design Specifications | Section 2 | [STATUS] | [files] |
| Development Process | Section 3 | [STATUS] | [files] |
| Monitoring & Functioning | Section 4 | [STATUS] | [files] |
| Validation & Testing | Section 5 | [STATUS] | [files] |
| Risk Management | Section 6 | [STATUS] | [files] |
| Changes & Lifecycle | Section 7 | [STATUS] | [files] |

**Overall Art. 11 Compliance**: [PERCENTAGE]%

### Documentation Quality
- **Completeness**: [assessment]
- **Currency**: [assessment]
- **Clarity**: [assessment]
- **Traceability**: [assessment]

### Missing Documentation
[List specific documents that need to be created]

### Remediation Priority
1. [Highest priority documentation to create]
2. [Second priority]
3. [Third priority]
```
