---
name: remediation-advisor
description: >
  Provides detailed remediation guidance for EU AI Act compliance gaps.
  Generates fix templates with code examples, documentation templates,
  and implementation steps for each article's requirements.
---

# Remediation Advisor

Provide actionable remediation guidance for each compliance gap identified in the audit.

## Remediation Templates by Article

### Article 9 — Risk Management System

**Gap**: No risk management system documented

**Remediation steps**:
1. Create a risk management framework document
2. Establish a risk register
3. Define risk assessment methodology
4. Implement iterative risk review process

**Documentation template**:
```markdown
# Risk Management System

## 1. Scope and Objectives
- System name: [name]
- Intended purpose: [purpose]
- Risk management objective: Identify, analyze, evaluate, and mitigate risks
  to health, safety, and fundamental rights throughout the AI system lifecycle.

## 2. Risk Identification
### 2.1 Intended Use Risks
| Risk ID | Description | Category | Likelihood | Impact | Score |
|---------|-------------|----------|------------|--------|-------|
| R-001   | [risk]      | Safety   | [L/M/H]    | [L/M/H]| [1-9] |

### 2.2 Foreseeable Misuse Risks
| Risk ID | Misuse Scenario | Mitigation |
|---------|-----------------|------------|
| M-001   | [scenario]      | [mitigation] |

### 2.3 Fundamental Rights Impact
| Right | Potential Impact | Safeguard |
|-------|-----------------|-----------|
| Non-discrimination | [impact] | [safeguard] |
| Privacy | [impact] | [safeguard] |

## 3. Risk Mitigation Measures
[For each identified risk, describe mitigation approach]

## 4. Testing and Validation
[Testing procedures for risk scenarios]

## 5. Review Schedule
- Frequency: [quarterly/after significant changes]
- Responsible: [role]
- Last review: [date]
```

**Code example — risk monitoring integration**:
```python
# risk_monitor.py
import logging
from dataclasses import dataclass
from datetime import datetime
from enum import Enum

class RiskLevel(Enum):
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    CRITICAL = "critical"

@dataclass
class RiskEvent:
    risk_id: str
    description: str
    level: RiskLevel
    timestamp: datetime
    context: dict

class RiskMonitor:
    def __init__(self, logger=None):
        self.logger = logger or logging.getLogger("risk_monitor")
        self.risk_events = []

    def log_risk_event(self, event: RiskEvent):
        self.risk_events.append(event)
        self.logger.warning(
            f"Risk event: {event.risk_id} - {event.description} "
            f"[{event.level.value}]"
        )
        if event.level == RiskLevel.CRITICAL:
            self._trigger_alert(event)

    def _trigger_alert(self, event: RiskEvent):
        self.logger.critical(f"CRITICAL RISK: {event.risk_id} requires immediate review")
```

---

### Article 10 — Data Governance

**Gap**: No data governance practices documented

**Remediation steps**:
1. Document all training data sources and their characteristics
2. Implement bias assessment with fairness metrics
3. Create data quality checks in the pipeline
4. Document data collection methodology and assumptions

**Documentation template**:
```markdown
# Data Governance Documentation

## 1. Data Sources
| Source | Type | Size | License | Update Frequency |
|--------|------|------|---------|-----------------|
| [name] | [type] | [size] | [license] | [frequency] |

## 2. Data Quality
- Completeness: [metric]
- Accuracy: [metric]
- Consistency: [metric]
- Timeliness: [metric]

## 3. Bias Assessment
### Protected Attributes Analyzed
| Attribute | Distribution | Fairness Metric | Result |
|-----------|-------------|-----------------|--------|
| [attr]    | [dist]      | [metric]        | [pass/fail] |

### Mitigation Measures
[Description of bias mitigation approaches]

## 4. Privacy Compliance
- Personal data processed: [yes/no]
- Lawful basis: [basis]
- Anonymization method: [method]
- DPIA conducted: [yes/no, reference]
```

**Code example — bias assessment**:
```python
# bias_assessment.py
from dataclasses import dataclass

@dataclass
class FairnessMetric:
    name: str
    value: float
    threshold: float
    passed: bool

def assess_demographic_parity(predictions, protected_attribute, groups):
    """Assess demographic parity across protected groups."""
    rates = {}
    for group in groups:
        mask = protected_attribute == group
        rates[group] = predictions[mask].mean()

    max_rate = max(rates.values())
    min_rate = min(rates.values())
    ratio = min_rate / max_rate if max_rate > 0 else 0

    return FairnessMetric(
        name="demographic_parity_ratio",
        value=ratio,
        threshold=0.8,  # 80% rule
        passed=ratio >= 0.8
    )
```

---

### Article 11 — Technical Documentation (Annex IV)

**Gap**: Missing technical documentation sections

**Template — Model Card**:
```markdown
# Model Card: [Model Name]

## Model Details
- **Developer**: [organization]
- **Model version**: [version]
- **Model type**: [architecture]
- **License**: [license]

## Intended Use
- **Primary use cases**: [list]
- **Out-of-scope uses**: [list]
- **Users**: [target users]

## Training Data
- **Dataset**: [name, size, source]
- **Preprocessing**: [steps]
- **Known limitations**: [limitations]

## Evaluation
| Metric | Value | Dataset |
|--------|-------|---------|
| [metric] | [value] | [dataset] |

## Ethical Considerations
- **Bias risks**: [identified risks]
- **Mitigation**: [approaches taken]

## Limitations and Risks
- [Known limitation 1]
- [Known limitation 2]

## Recommendations
- [Usage recommendation 1]
- [Usage recommendation 2]
```

---

### Article 12 — Record-Keeping

**Gap**: Insufficient logging and traceability

**Code example — structured AI logging**:
```python
# ai_logger.py
import json
import logging
from datetime import datetime, timezone

class AIAuditLogger:
    def __init__(self, system_name: str):
        self.logger = logging.getLogger(f"ai_audit.{system_name}")
        self.system_name = system_name

    def log_prediction(self, request_id, input_data, output, model_version,
                       confidence=None, user_id=None):
        record = {
            "event_type": "prediction",
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "system": self.system_name,
            "request_id": request_id,
            "model_version": model_version,
            "input_hash": hash(json.dumps(input_data, sort_keys=True)),
            "output": output,
            "confidence": confidence,
            "affected_person_id": user_id,
        }
        self.logger.info(json.dumps(record))

    def log_override(self, request_id, original_output, overridden_output,
                     operator_id, reason):
        record = {
            "event_type": "human_override",
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "request_id": request_id,
            "original_output": original_output,
            "overridden_output": overridden_output,
            "operator_id": operator_id,
            "reason": reason,
        }
        self.logger.warning(json.dumps(record))
```

---

### Article 13 + 50 — Transparency

**Gap**: No AI disclosure or explainability

**Code example — AI disclosure middleware**:
```python
# ai_disclosure.py

AI_DISCLOSURE_HEADER = "X-AI-Generated"
AI_DISCLOSURE_MESSAGE = (
    "This response was generated by an AI system. "
    "For more information about how this system works, "
    "its capabilities, and limitations, visit [documentation URL]."
)

def add_ai_disclosure(response):
    """Add AI disclosure headers and metadata to API responses."""
    response.headers[AI_DISCLOSURE_HEADER] = "true"
    response.headers["X-AI-Model-Version"] = get_model_version()
    response.headers["X-AI-Confidence"] = str(get_confidence_score())

    if hasattr(response, "json_body"):
        response.json_body["_ai_metadata"] = {
            "ai_generated": True,
            "model_version": get_model_version(),
            "disclosure": AI_DISCLOSURE_MESSAGE,
        }
    return response
```

---

### Article 14 — Human Oversight

**Gap**: No override or stop mechanism

**Code example — human oversight interface**:
```python
# human_oversight.py
from enum import Enum

class OversightLevel(Enum):
    HITL = "human_in_the_loop"   # Human approves every decision
    HOTL = "human_on_the_loop"   # Human monitors, can intervene
    HICC = "human_in_command"    # Human sets boundaries

class HumanOversightController:
    def __init__(self, level: OversightLevel):
        self.level = level
        self.active = True

    def request_decision(self, ai_output, context):
        if self.level == OversightLevel.HITL:
            return self._require_approval(ai_output, context)
        elif self.level == OversightLevel.HOTL:
            self._notify_operator(ai_output, context)
            return ai_output
        else:
            return ai_output

    def override(self, request_id, new_decision, operator_id, reason):
        """Allow human operator to override AI decision."""
        log_override(request_id, new_decision, operator_id, reason)
        return new_decision

    def emergency_stop(self, operator_id, reason):
        """Kill switch — immediately halt AI system operations."""
        self.active = False
        log_emergency_stop(operator_id, reason)
        notify_all_operators("EMERGENCY STOP ACTIVATED")

    def is_active(self):
        return self.active
```

---

### Article 15 — Accuracy & Robustness

**Gap**: No adversarial testing or security measures

**Code example — input validation and adversarial defense**:
```python
# input_guard.py
import re
from dataclasses import dataclass

@dataclass
class ValidationResult:
    valid: bool
    reason: str = ""

class AIInputGuard:
    def __init__(self, max_length=10000):
        self.max_length = max_length

    def validate(self, input_data) -> ValidationResult:
        if isinstance(input_data, str):
            return self._validate_text(input_data)
        return ValidationResult(valid=True)

    def _validate_text(self, text: str) -> ValidationResult:
        if len(text) > self.max_length:
            return ValidationResult(False, f"Input exceeds max length {self.max_length}")

        # Check for common prompt injection patterns
        injection_patterns = [
            r"ignore\s+(previous|above|all)\s+instructions",
            r"system\s*:\s*you\s+are",
            r"<\|.*?\|>",
        ]
        for pattern in injection_patterns:
            if re.search(pattern, text, re.IGNORECASE):
                return ValidationResult(False, "Potentially adversarial input detected")

        return ValidationResult(valid=True)
```

---

### GPAI — Articles 53-56

**Gap**: Missing GPAI documentation or copyright compliance

**Documentation template — GPAI model documentation**:
```markdown
# GPAI Model Documentation (Annex XI)

## 1. Model Identity
- **Model name**: [name]
- **Version**: [version]
- **Provider**: [organization]
- **Release date**: [date]

## 2. Architecture
- **Type**: [transformer / diffusion / etc.]
- **Parameters**: [count]
- **Training compute**: [FLOPS estimate]

## 3. Training Data
- **Sources**: [list of data sources]
- **Size**: [tokens / images / hours]
- **Languages**: [list]
- **Copyright compliance**: [TDM opt-out respected: yes/no]
- **Summary**: [public summary per Art. 53(1)(d)]

## 4. Capabilities & Limitations
- **Intended capabilities**: [list]
- **Known limitations**: [list]
- **Risks identified**: [list]

## 5. Evaluation Results
| Benchmark | Score | Date |
|-----------|-------|------|
| [benchmark] | [score] | [date] |

## 6. Downstream Provider Information
- **Integration guide**: [link]
- **API documentation**: [link]
- **Acceptable use policy**: [link]
- **Known risks for integrators**: [list]
```

## Remediation Priority Framework

```
CRITICAL (Fix immediately):
├── Prohibited practice violations (Art. 5)
├── No risk classification performed (Art. 6)
└── No human override/stop capability (Art. 14(3)(d-e))

HIGH (Fix within 30 days):
├── No risk management system (Art. 9)
├── No data governance (Art. 10)
├── No logging/traceability (Art. 12)
└── No transparency/disclosure (Art. 13/50)

MEDIUM (Fix within 90 days):
├── Incomplete technical documentation (Art. 11)
├── Partial bias assessment (Art. 10(5))
├── Incomplete adversarial testing (Art. 15(4))
└── GPAI documentation gaps (Art. 53)

LOW (Continuous improvement):
├── Enhanced explainability features (Art. 13)
├── Additional fairness metrics (Art. 10)
├── Extended monitoring capabilities (Art. 12)
└── Codes of practice participation (Art. 56)
```

## Output Format

```markdown
## Remediation Plan

### Overview
- **Total gaps identified**: [count]
- **Critical**: [count] | **High**: [count] | **Medium**: [count] | **Low**: [count]
- **Estimated effort**: [assessment]

### Remediation Actions

#### [PRIORITY] — [Article] — [Gap Description]

**Requirement**: [What the EU AI Act requires]

**Current state**: [What was found in the codebase]

**Action items**:
1. [Specific step]
2. [Specific step]
3. [Specific step]

**Implementation guidance**:
[Code example or documentation template]

**Verification**: [How to verify compliance after fix]

---
[Repeat for each gap]

### Implementation Timeline

| Phase | Actions | Timeline | Effort |
|-------|---------|----------|--------|
| Immediate | [critical fixes] | Week 1 | [hours] |
| Short-term | [high priority] | Month 1 | [hours] |
| Medium-term | [medium priority] | Quarter 1 | [hours] |
| Ongoing | [improvements] | Continuous | [hours/quarter] |
```
