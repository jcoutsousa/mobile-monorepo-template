---
name: human-oversight-audit
description: >
  Audits human oversight requirements per Article 14 of the EU AI Act.
  Checks for human-in-the-loop, human-on-the-loop, and human-in-command mechanisms,
  override capabilities, and kill switch functionality for high-risk AI systems.
---

# Human Oversight Audit (Article 14)

Audit compliance with human oversight requirements for high-risk AI systems.

## Requirements Checklist

### 14(1) — Designed for Human Oversight

**Required**: High-risk AI systems shall be designed and developed to be effectively overseen by natural persons during the period of use.

**Search patterns**:
```
human.?oversight|human.?control|human.?supervision
oversight.?design|oversight.?mechanism|oversight.?interface
operator|supervisor|reviewer|moderator
```

### 14(2) — Minimize Automation Bias

**Required**: Human oversight shall aim to prevent or minimize risks to health, safety, or fundamental rights, particularly automation bias.

**Search patterns**:
```
automation.?bias|over.?reliance|over.?trust
confirmation.?bias|anchoring.?bias|decision.?support
advisory.?only|recommendation.?only|not.?deterministic
human.?judgment|human.?decision|human.?final
calibration.?warning|confidence.?display|uncertainty
```

**Evidence to check**:
- Warnings about automation bias in documentation
- Confidence scores presented to users
- System positioned as advisory, not deterministic
- Training materials about appropriate reliance

### 14(3)(a) — HITL: Understand Capabilities and Limitations

**Required**: Persons overseeing the system must be able to fully understand the system's capabilities and limitations, and properly monitor its operation.

**Search patterns**:
```
operator.?training|user.?training|oversight.?training
capability.?document|limitation.?document
monitoring.?dashboard|operator.?interface|admin.?panel
system.?status|health.?indicator|performance.?display
```

### 14(3)(b) — HITL: Awareness of Automation Bias

**Required**: Overseers must remain aware of the possible tendency of automatically relying on or over-relying on the output.

**Search patterns**:
```
automation.?bias.?warning|reliance.?warning
training.*automation.?bias|awareness.*over.?reliance
decision.?fatigue|alert.?fatigue|monitoring.?fatigue
```

### 14(3)(c) — HITL: Interpret Output Correctly

**Required**: Overseers must be able to correctly interpret the system's output, taking into account the tools and methods of interpretation.

**Search patterns**:
```
interpret.*output|output.*explain|result.*interpret
visualization|dashboard|report.?generat
explainab|SHAP|LIME|feature.?importance
decision.?rationale|reasoning.?display|explain.?why
```

### 14(3)(d) — HITL: Override or Disregard

**Required**: Overseers must be able to decide not to use the system or to disregard, override, or reverse its output.

**Search patterns**:
```
override|disregard|reverse.?decision|reject.?output
manual.?override|human.?override|operator.?override
opt.?out|decline|dismiss|ignore.?recommendation
veto|countermand|overrule|bypass
```

**Evidence to check**:
- Override mechanisms in the UI/API
- Ability to reject AI recommendations
- Manual decision path available
- Override logging and accountability

### 14(3)(e) — HITL: Interrupt or Stop

**Required**: Overseers must be able to interrupt or stop the system through a "stop" button or similar procedure.

**Search patterns**:
```
stop.?button|kill.?switch|emergency.?stop|e.?stop
interrupt|halt|shutdown|abort|terminate
circuit.?breaker|dead.?man|watchdog
graceful.?shutdown|safe.?stop|pause
```

**Evidence to check**:
- Emergency stop mechanism implemented
- Kill switch or circuit breaker pattern
- Graceful shutdown procedures
- Interrupt handlers for critical processes

### 14(4) — Specific Oversight for Identification Systems

**Required**: For high-risk AI systems used for biometric identification, human oversight ensures:
- No action based solely on AI output without independent verification
- At least two qualified persons verify results
- Geographic and temporal limits are respected

**Search patterns**:
```
dual.?review|two.?person|four.?eyes|independent.?verif
human.?confirm|manual.?confirm|second.?opinion
geographic.?limit|temporal.?limit|scope.?restrict
verification.?required|confirmation.?required
```

### 14(5) — Provider Documentation for Oversight

**Required**: Provider shall identify appropriate human oversight measures and include them in instructions for use.

**Search patterns**:
```
oversight.?instruction|oversight.?guide|oversight.?manual
deployer.?guide|operator.?manual|user.?guide
human.?oversight.?section|oversight.?procedure
```

## Oversight Architecture Assessment

Evaluate the level of human oversight:

| Level | Description | Pattern |
|-------|-------------|---------|
| **HITL** (Human-in-the-Loop) | Human approves every decision | `approval.?required\|manual.?confirm\|queue.?review` |
| **HOTL** (Human-on-the-Loop) | Human monitors and can intervene | `monitor\|dashboard\|alert\|override` |
| **HICC** (Human-in-Command) | Human sets boundaries, AI operates within | `policy\|constraint\|boundary\|rule.?engine` |

## Output Format

```markdown
## Human Oversight Audit (Article 14)

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| Designed for oversight | 14(1) | [STATUS] | [evidence] |
| Automation bias prevention | 14(2) | [STATUS] | [evidence] |
| Understand capabilities | 14(3)(a) | [STATUS] | [evidence] |
| Automation bias awareness | 14(3)(b) | [STATUS] | [evidence] |
| Interpret output | 14(3)(c) | [STATUS] | [evidence] |
| Override/disregard | 14(3)(d) | [STATUS] | [evidence] |
| Interrupt/stop | 14(3)(e) | [STATUS] | [evidence] |
| Identification oversight | 14(4) | [STATUS] | [evidence] |
| Provider documentation | 14(5) | [STATUS] | [evidence] |

**Oversight Architecture**: [HITL / HOTL / HICC / NONE]

**Overall Art. 14 Compliance**: [PERCENTAGE]%

### Critical Gaps
[List most important missing elements]

### Remediation Priority
1. [Highest priority action]
2. [Second priority]
3. [Third priority]
```
