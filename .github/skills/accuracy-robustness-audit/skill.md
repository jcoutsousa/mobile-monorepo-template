---
name: accuracy-robustness-audit
description: >
  Audits accuracy, robustness, and cybersecurity requirements per Article 15 of the EU AI Act.
  Checks for model validation, adversarial testing, security measures, resilience mechanisms,
  and model integrity protections for high-risk AI systems.
---

# Accuracy, Robustness & Cybersecurity Audit (Article 15)

Audit compliance with accuracy, robustness, and cybersecurity requirements.

## Requirements Checklist

### 15(1) — Appropriate Levels of Accuracy

**Required**: High-risk AI systems shall be designed and developed to achieve an appropriate level of accuracy, robustness, and cybersecurity, and perform consistently in those respects throughout their lifecycle.

**Search patterns**:
```
accuracy|precision|recall|f1.?score|AUC|ROC
performance.?metric|evaluation.?metric|benchmark
mean.?absolute|mean.?squared|R.?squared
confusion.?matrix|classification.?report
BLEU|ROUGE|perplexity|word.?error.?rate
```

**Evidence to check**:
- Defined accuracy metrics appropriate to the task
- Benchmark results documented
- Performance baselines established
- Accuracy thresholds for deployment decisions

### 15(2) — Accuracy Levels Declared

**Required**: Levels of accuracy and relevant accuracy metrics shall be declared in the instructions for use.

**Search patterns**:
```
accuracy.?report|performance.?report|metric.?report
model.?card|model.?performance|benchmark.?result
evaluation.?result|test.?result|validation.?result
declared.?accuracy|expected.?performance
```

### 15(3) — Resilience to Errors and Inconsistencies

**Required**: High-risk AI systems shall be resilient to errors, faults, or inconsistencies within the system or its operating environment.

**Search patterns**:
```
error.?handl|exception.?handl|fault.?toleran
graceful.?degrad|fallback|retry|circuit.?breaker
input.?validat|output.?validat|sanity.?check
boundary.?check|range.?check|type.?check
data.?quality.?check|schema.?validat|format.?check
```

**Evidence to check**:
- Error handling and exception management
- Input/output validation
- Fallback mechanisms
- Graceful degradation patterns

### 15(4) — Robustness Against Adversarial Attacks

**Required**: High-risk AI systems shall be resilient against attempts by unauthorized third parties to alter use or performance through exploitation of system vulnerabilities.

#### 15(4)(a) — Data Poisoning
```
data.?poison|adversarial.?data|corrupt.?training
data.?integrity|data.?validation.?pipeline
input.?sanitiz|data.?clean|anomaly.?detect.?data
backdoor.?detect|trojan.?detect|trigger.?detect
```

#### 15(4)(b) — Model Evasion
```
adversarial.?example|adversarial.?attack|evasion
perturbation|adversarial.?robust|adversarial.?train
FGSM|PGD|C&W|adversarial.?defense
input.?perturbation|noise.?robust|robust.?model
cleverhans|foolbox|ART|adversarial.?robustness
```

#### 15(4)(c) — Model Extraction/Inversion
```
model.?extract|model.?steal|model.?inversion
membership.?inference|privacy.?attack|data.?leak
rate.?limit|API.?protect|query.?limit
differential.?privacy|federated.?learn|secure.?compute
model.?watermark|model.?fingerprint
```

### 15(5) — Cybersecurity Measures

**Required**: Technical solutions to address AI-specific vulnerabilities, including measures against:
- Data poisoning
- Model manipulation
- Adversarial inputs
- Confidentiality breaches

**Search patterns**:
```
security|cybersecurity|infosec|appsec
authentication|authorization|access.?control
encryption|TLS|SSL|HTTPS|certificate
secret.?manage|vault|KMS|key.?manage
vulnerability.?scan|penetration.?test|security.?audit
OWASP|security.?header|CSP|CORS
dependency.?scan|CVE|vulnerability.?check
snyk|dependabot|trivy|bandit|safety
```

**Evidence to check**:
- Security scanning tools configured
- Dependency vulnerability checking
- Access control and authentication
- Encryption at rest and in transit
- Security audit records

### Model Integrity

**Search patterns**:
```
model.?hash|model.?checksum|model.?signature
model.?versioning|model.?registry|model.?store
MLflow|Weights.?&.?Biases|DVC|model.?artifact
integrity.?check|tamper.?detect|sign.?model
reproducib|deterministic|seed|checkpoint
```

### Continuous Performance Monitoring

**Search patterns**:
```
model.?monitor|prediction.?monitor|performance.?drift
data.?drift|concept.?drift|distribution.?shift
A/B.?test|shadow.?model|canary.?deploy
retraining.?trigger|model.?refresh|update.?policy
evidently|whylabs|nannyml|arize|fiddler
```

## Output Format

```markdown
## Accuracy, Robustness & Cybersecurity Audit (Article 15)

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| Appropriate accuracy levels | 15(1) | [STATUS] | [evidence] |
| Accuracy levels declared | 15(2) | [STATUS] | [evidence] |
| Error/fault resilience | 15(3) | [STATUS] | [evidence] |
| Data poisoning protection | 15(4)(a) | [STATUS] | [evidence] |
| Adversarial robustness | 15(4)(b) | [STATUS] | [evidence] |
| Model extraction protection | 15(4)(c) | [STATUS] | [evidence] |
| Cybersecurity measures | 15(5) | [STATUS] | [evidence] |

**Overall Art. 15 Compliance**: [PERCENTAGE]%

### Security Posture
- **Authentication**: [assessment]
- **Encryption**: [assessment]
- **Vulnerability Management**: [assessment]
- **Adversarial Defenses**: [assessment]

### Critical Gaps
[List most important missing elements]

### Remediation Priority
1. [Highest priority action]
2. [Second priority]
3. [Third priority]
```
