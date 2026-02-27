---
name: record-keeping-audit
description: >
  Audits record-keeping and logging requirements per Article 12 of the EU AI Act.
  Checks for automatic event logging, traceability, monitoring capabilities,
  and log retention for high-risk AI systems.
---

# Record-Keeping Audit (Article 12)

Audit compliance with record-keeping and automatic logging requirements.

## Requirements Checklist

### 12(1) — Automatic Logging Capability

**Required**: High-risk AI systems shall technically allow for automatic recording of events (logs) throughout their lifetime.

**Search patterns**:
```
logging|log.?config|log.?setup|logger
log.?level|log.?format|log.?handler
logging.?framework|winston|pino|loguru|structlog
log4j|serilog|bunyan|morgan|ELK|fluentd
```

**Evidence to check**:
- Logging framework configured and active
- Log configuration files
- Structured logging implementation
- Log levels appropriately used

### 12(2) — Traceability Throughout Lifecycle

**Required**: Logging capabilities shall ensure a level of traceability of the AI system's functioning throughout its lifecycle.

**Search patterns**:
```
trace|traceab|correlation.?id|request.?id
span|distributed.?trac|opentelemetry|jaeger|zipkin
audit.?trail|audit.?log|event.?sourc
lineage|provenance|chain.?of.?custody
```

**Evidence to check**:
- Request/correlation ID propagation
- Distributed tracing implementation
- Audit trail for key decisions
- Data lineage tracking

### 12(3) — Specific Logging Requirements

**Required**: Logging shall include at minimum:

#### 12(3)(a) — Period of Use Logging
```
session.?log|usage.?log|access.?log|activity.?log
start.?time|end.?time|session.?duration
user.?session|system.?uptime|operational.?log
```

#### 12(3)(b) — Reference Database
```
reference.?data|training.?data.?version|model.?version
dataset.?version|data.?snapshot|baseline
ground.?truth|reference.?database
```

#### 12(3)(c) — Input Data Logging
```
input.?log|request.?log|inference.?log
input.?data|query.?log|prediction.?request
feature.?log|input.?record
```

#### 12(3)(d) — Identification of Affected Persons
```
user.?id|subject.?id|affected.?person
data.?subject|individual.?identif
impact.?track|decision.?subject
```

### 12(4) — Log Retention and Accessibility

**Required**: Logs shall be kept for an appropriate period and be accessible to relevant authorities.

**Search patterns**:
```
retention|log.?retention|data.?retention
log.?storage|log.?archive|log.?backup
retention.?policy|log.?lifecycle|TTL
compliance.?log|regulatory.?access
export.?log|log.?query|log.?search
```

**Evidence to check**:
- Log retention policies configured
- Log storage and archival systems
- Log accessibility for audit purposes
- Retention period appropriate to risk level

### Additional Monitoring Capabilities

**Search patterns for monitoring**:
```
monitor|alert|dashboard|metric
prometheus|grafana|datadog|cloudwatch|newrelic
health.?check|heartbeat|uptime|SLA
anomaly.?detect|drift.?detect|performance.?monitor
model.?monitor|prediction.?monitor|data.?drift
```

**Evidence to check**:
- Real-time monitoring dashboards
- Alerting for anomalies and degradation
- Model performance monitoring
- Data drift detection

## Output Format

```markdown
## Record-Keeping Audit (Article 12)

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| Automatic logging capability | 12(1) | [STATUS] | [evidence] |
| Lifecycle traceability | 12(2) | [STATUS] | [evidence] |
| Period of use logging | 12(3)(a) | [STATUS] | [evidence] |
| Reference database versioning | 12(3)(b) | [STATUS] | [evidence] |
| Input data logging | 12(3)(c) | [STATUS] | [evidence] |
| Affected person identification | 12(3)(d) | [STATUS] | [evidence] |
| Log retention & accessibility | 12(4) | [STATUS] | [evidence] |

**Overall Art. 12 Compliance**: [PERCENTAGE]%

### Logging Architecture
- **Framework**: [detected logging framework]
- **Storage**: [log storage solution]
- **Retention**: [configured retention period]
- **Monitoring**: [monitoring tools detected]

### Critical Gaps
[List most important missing elements]

### Remediation Priority
1. [Highest priority action]
2. [Second priority]
3. [Third priority]
```
