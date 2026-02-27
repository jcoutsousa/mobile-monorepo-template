---
name: data-governance-audit
description: >
  Audits data and data governance practices required by Article 10 of the EU AI Act.
  Checks training data quality, bias assessment, representativeness, data documentation,
  and GDPR compliance for high-risk AI systems.
---

# Data Governance Audit (Article 10)

Audit compliance with data and data governance requirements for high-risk AI systems.

## Requirements Checklist

### 10(1) — Data Governance Practices

**Required**: High-risk AI systems using data training techniques shall be developed with training, validation, and testing datasets subject to appropriate data governance practices.

**Search patterns**:
```
data.?governance|data.?policy|data.?management
data.?quality|data.?standard|data.?procedure
data.?catalog|data.?lineage|data.?steward
```

**Evidence to check**:
- Data governance policies and procedures
- Data quality standards and enforcement
- Data stewardship assignments
- Data management frameworks

### 10(2) — Data Quality Requirements

**Required**: Training, validation, and testing datasets shall be subject to data management practices concerning:

#### 10(2)(a) — Design Choices
```
design.?choice|data.?collection.?method|sampling
data.?source.?selection|feature.?select|data.?strategy
annotation.?guide|labeling.?protocol|data.?spec
```

#### 10(2)(b) — Data Collection Processes
```
data.?collect|data.?acquisit|data.?ingest|data.?pipeline
ETL|extract.?transform|data.?source|data.?provider
web.?scrape|API.?collect|survey|sensor.?data
```

#### 10(2)(c) — Relevant Assumptions
```
assumption|limitation|constraint|caveat
data.?scope|population.?represent|generalizab
domain.?limit|temporal.?scope|geographic.?scope
```

#### 10(2)(d) — Availability, Quantity, Suitability
```
dataset.?size|sample.?size|data.?volume
data.?sufficiency|coverage|completeness
data.?suitability|fitness.?for.?purpose
train.?test.?split|validation.?split
```

#### 10(2)(e) — Properties and Characteristics
```
data.?schema|feature.?description|data.?dictionary
metadata|data.?type|data.?format|data.?range
statistical.?summary|distribution|data.?profile
```

#### 10(2)(f) — Gaps and Shortcomings
```
missing.?data|null|NaN|incomplete|gap.?analysis
data.?imbalance|class.?imbalance|underrepresent
data.?limitation|known.?issue|data.?gap
outlier|anomal|noise|corrupt
```

### 10(3) — Relevance and Representativeness

**Required**: Datasets shall be relevant, sufficiently representative, and to the best extent possible free of errors and complete in view of the intended purpose.

**Search patterns**:
```
represent|relevant|free.?of.?error|complete
data.?clean|data.?valid|error.?correct
population.?represent|demographic.?coverage
domain.?coverage|use.?case.?coverage
```

### 10(4) — Statistical Properties

**Required**: Datasets shall take into account the characteristics or elements particular to the specific geographical, contextual, behavioral, or functional setting.

**Search patterns**:
```
geographic|regional|cultural|contextual
behavioral.?pattern|functional.?setting
locale|language|demographic.?represent
deployment.?context|target.?population
```

### 10(5) — Bias Assessment

**Required**: Examination of possible biases that are likely to affect health, safety, and fundamental rights, and appropriate measures to detect, prevent, and mitigate bias.

**Search patterns**:
```
bias.?detect|bias.?assess|bias.?audit|bias.?mitigat
fairness|discrimination|disparate|equity
demographic.?parity|equal.?opportunity|calibration
fairness.?metric|bias.?metric|group.?fairness
aequitas|fairlearn|aif360|responsible.?ai
protected.?attribute|sensitive.?attribute
```

**Evidence to check**:
- Bias detection tools or frameworks integrated
- Fairness metrics computed and documented
- Bias mitigation strategies implemented
- Protected attribute analysis

### 10(6) — Personal Data Processing

**Required**: For personal data, appropriate data governance and management practices shall be implemented, including GDPR considerations.

**Search patterns**:
```
personal.?data|PII|personally.?identif
GDPR|data.?protection|privacy
consent|lawful.?basis|legitimate.?interest
anonymiz|pseudonymiz|de.?identif
data.?subject.?rights|right.?to.?erasure
DPIA|data.?protection.?impact
```

**Evidence to check**:
- Privacy impact assessments (DPIA)
- Data anonymization/pseudonymization
- Consent mechanisms
- Data subject rights implementation
- Lawful basis documentation

## Output Format

```markdown
## Data Governance Audit (Article 10)

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| Data governance practices | 10(1) | [STATUS] | [evidence] |
| Design choices documented | 10(2)(a) | [STATUS] | [evidence] |
| Data collection processes | 10(2)(b) | [STATUS] | [evidence] |
| Assumptions documented | 10(2)(c) | [STATUS] | [evidence] |
| Availability & quantity | 10(2)(d) | [STATUS] | [evidence] |
| Properties documented | 10(2)(e) | [STATUS] | [evidence] |
| Gaps & shortcomings | 10(2)(f) | [STATUS] | [evidence] |
| Representativeness | 10(3) | [STATUS] | [evidence] |
| Statistical properties | 10(4) | [STATUS] | [evidence] |
| Bias assessment | 10(5) | [STATUS] | [evidence] |
| Personal data / GDPR | 10(6) | [STATUS] | [evidence] |

**Overall Art. 10 Compliance**: [PERCENTAGE]%

### Critical Gaps
[List most important missing elements]

### Bias Assessment Summary
- **Protected attributes identified**: [list]
- **Fairness metrics used**: [list or "none found"]
- **Known biases**: [list or "not assessed"]
- **Mitigation measures**: [list or "none found"]

### Remediation Priority
1. [Highest priority action]
2. [Second priority]
3. [Third priority]
```
