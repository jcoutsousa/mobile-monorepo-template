---
name: gpai-compliance-audit
description: >
  Audits compliance with General-Purpose AI (GPAI) model obligations per Articles 51-56
  of the EU AI Act. Covers foundation model documentation, copyright compliance,
  systemic risk assessment, and additional obligations for GPAI models with systemic risk.
---

# General-Purpose AI Compliance Audit (Articles 51-56)

Audit compliance with GPAI model obligations. These apply when the system uses or provides a general-purpose AI model (foundation model, large language model, multi-modal model).

## GPAI Detection

**Search patterns for GPAI usage**:
```
# Foundation model / LLM providers
openai|anthropic|cohere|google.?generativeai|mistral
meta.?llama|falcon|bloom|gpt|claude|gemini|palm

# Model hosting
huggingface|transformers|auto.?model|pipeline
model.?hub|model.?registry|model.?download

# Fine-tuning
fine.?tun|PEFT|LoRA|QLoRA|adapter
instruction.?tun|RLHF|DPO|training.?loop

# Self-hosted models
llama.?cpp|vllm|text.?generation.?inference|ollama
triton|TensorRT.?LLM|onnxruntime.*llm

# Multi-modal
CLIP|DALL.?E|Stable.?Diffusion|whisper
vision.?language|multi.?modal|image.?text
```

## Requirements Checklist

### Art. 53(1) — Technical Documentation

**Required**: Providers of GPAI models shall draw up and keep up to date technical documentation including training and testing processes and results, which shall contain at minimum the information set out in Annex XI.

**Search patterns**:
```
model.?card|model.?documentation|technical.?doc
training.?doc|training.?detail|model.?description
architecture.?doc|model.?spec|model.?report
system.?card|AI.?factsheet
```

**Annex XI requirements to check**:
- Model architecture description
- Training methodology
- Data used for training (including sources, scope, characteristics)
- Computational resources used
- Training performance metrics
- Known limitations

### Art. 53(1)(b) — Information for Downstream Providers

**Required**: Draw up and make available information and documentation for downstream providers who integrate the GPAI model into their systems.

**Search patterns**:
```
API.?doc|integration.?guide|developer.?doc
downstream|integrator|deployer.?guide
SDK.?doc|client.?doc|usage.?guide
capability.?doc|limitation.?doc|safety.?guide
acceptable.?use|use.?policy|responsible.?use
```

### Art. 53(1)(c) — Copyright Compliance

**Required**: Put in place a policy to comply with EU copyright law (Directive (EU) 2019/790), in particular regarding the right to opt out of text and data mining.

**Search patterns**:
```
copyright|license|intellectual.?property
text.?data.?mining|TDM|opt.?out|robots.?txt
training.?data.?license|data.?license
creative.?commons|fair.?use|copyright.?compliance
opt.?out.?mechanism|rights.?reservation
data.?source.?license|scraping.?policy
```

**Evidence to check**:
- Copyright policy documented
- Training data licensing documented
- TDM opt-out mechanisms respected
- robots.txt compliance
- Data source attribution

### Art. 53(1)(d) — Training Data Summary

**Required**: Draw up and make publicly available a sufficiently detailed summary about the content used for training, according to a template provided by the AI Office.

**Search patterns**:
```
training.?data.?summary|data.?summary|data.?card
data.?sheet|data.?documentation|data.?report
training.?corpus|dataset.?description
data.?composition|data.?source.?list
public.?summary|transparency.?report
```

### Art. 55 — Systemic Risk Assessment (for GPAI with systemic risk)

**Required**: GPAI models with systemic risk must:
- Perform model evaluation including adversarial testing
- Assess and mitigate systemic risks
- Track and report serious incidents
- Ensure adequate cybersecurity protection

**Systemic risk indicators**:
```
# Compute thresholds (>10^25 FLOPS suggests systemic risk)
FLOPS|compute|training.?cost|GPU.?hours|TPU
parameter.?count|billion.?parameter|trillion
# (Models >10B parameters or >10^25 FLOPS training compute)

# Wide deployment indicators
API.?access|public.?API|million.?user
general.?purpose|multi.?task|foundation
broad.?deployment|mass.?market
```

**Search patterns for systemic risk obligations**:
```
# Adversarial testing
red.?team|adversarial.?test|safety.?eval
jailbreak|prompt.?inject|safety.?benchmark
harmful.?output|toxicity.?test|bias.?eval

# Incident reporting
incident.?report|safety.?incident|serious.?incident
vulnerability.?report|bug.?bounty|responsible.?disclos

# Cybersecurity
security.?audit|pentest|vulnerability.?assess
access.?control|authentication|rate.?limit
DDoS.?protect|abuse.?prevent|safety.?filter
```

### Art. 56 — Codes of Practice

**Required**: Providers should participate in codes of practice that cover:
- Training data transparency
- Copyright compliance
- Risk identification and mitigation
- Responsible deployment practices

**Search patterns**:
```
code.?of.?practice|code.?of.?conduct|ethical.?guide
responsible.?AI|AI.?ethics|AI.?safety
deployment.?guide|safety.?protocol|governance
industry.?standard|self.?regulat|voluntary.?commit
```

## Output Format

```markdown
## GPAI Compliance Audit (Articles 51-56)

### GPAI Detection
- **GPAI model(s) identified**: [list models/providers]
- **Type**: [provider / deployer / fine-tuner]
- **Systemic risk**: [YES / NO / UNCERTAIN]

### Art. 53 — General Obligations

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| Technical documentation | 53(1)(a) | [STATUS] | [evidence] |
| Downstream provider info | 53(1)(b) | [STATUS] | [evidence] |
| Copyright compliance | 53(1)(c) | [STATUS] | [evidence] |
| Training data summary | 53(1)(d) | [STATUS] | [evidence] |

### Art. 55 — Systemic Risk (if applicable)

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| Model evaluation | 55(1)(a) | [STATUS] | [evidence] |
| Systemic risk mitigation | 55(1)(b) | [STATUS] | [evidence] |
| Incident reporting | 55(1)(c) | [STATUS] | [evidence] |
| Cybersecurity protection | 55(1)(d) | [STATUS] | [evidence] |

### Art. 56 — Codes of Practice

| Requirement | Status | Evidence |
|-------------|--------|----------|
| Participation in codes | [STATUS] | [evidence] |

**Overall GPAI Compliance**: [PERCENTAGE]%

### Critical Gaps
[List most important missing elements]

### Remediation Priority
1. [Highest priority action]
2. [Second priority]
3. [Third priority]
```
