---
name: transparency-audit
description: >
  Audits transparency requirements per Articles 13 and 50 of the EU AI Act.
  Checks for explainability, user-facing disclosures, AI interaction notices,
  synthetic content labeling, and watermarking for both high-risk and limited-risk systems.
---

# Transparency Audit (Articles 13 + 50)

Audit compliance with transparency and disclosure requirements.

## Article 13 — Transparency for High-Risk Systems

### 13(1) — Sufficient Transparency for Users

**Required**: High-risk AI systems shall be designed and developed to ensure their operation is sufficiently transparent to enable deployers to interpret the system's output and use it appropriately.

**Search patterns**:
```
explainab|interpretab|XAI|explain.*prediction
SHAP|LIME|attention.?map|feature.?importance
saliency|gradient.?explain|counterfactual
decision.?explanation|reasoning|rationale
model.?interpret|output.?explain
```

**Evidence to check**:
- Explainability libraries or tools integrated (SHAP, LIME, etc.)
- Feature importance or attention visualization
- Decision explanation generation
- Model interpretability documentation

### 13(2) — Appropriate Type and Degree of Transparency

**Required**: Transparency appropriate to the complexity and intended audience, including deployer obligations.

**Search patterns**:
```
user.?guide|deployer.?guide|operator.?manual
API.?document|integration.?guide|usage.?instruct
system.?limitation|known.?limitation|boundary
confidence.?score|uncertainty|probability
```

### 13(3)(a) — Provider Identity and Contact

**Required**: Instructions for use with the identity and contact details of the provider.

**Search patterns**:
```
provider|manufacturer|developer|contact
support|helpdesk|email.*support|legal.*contact
company.?name|organization|vendor.?info
```

### 13(3)(b) — System Capabilities and Limitations

**Required**: Description of the system's capabilities and limitations, including:
- Performance levels and known limitations
- Reasonably foreseeable misuse risks
- Deployment specifications

**Search patterns**:
```
capability|limitation|performance.?level
misuse.?risk|intended.?use|deployment.?spec
operating.?condition|environmental.?constraint
minimum.?requirement|system.?requirement
```

### 13(3)(c) — Changes and Modifications

**Required**: Information about changes made to the system.

**Search patterns**:
```
changelog|release.?note|version.?history
update.?log|modification|change.?record
breaking.?change|deprecat|migration.?guide
```

### 13(3)(d) — Human Oversight Measures

**Required**: Description of human oversight measures referenced in Article 14.

**Search patterns**:
```
human.?oversight|human.?review|manual.?review
override|escalat|human.?in.?the.?loop
supervisor|operator.?control|intervention
```

### 13(3)(e) — Expected Lifetime and Maintenance

**Required**: Expected lifetime, necessary maintenance and care measures.

**Search patterns**:
```
lifecycle|maintenance|support.?period
end.?of.?life|deprecation|sunset
update.?schedule|patch.?policy|SLA
```

## Article 50 — Transparency for Limited-Risk Systems

### 50(1) — AI Interaction Disclosure

**Required**: Persons interacting with an AI system shall be informed they are interacting with AI, unless obvious from context.

**Search patterns**:
```
AI.?disclosure|bot.?disclosure|ai.?notice
"powered by AI"|"AI assistant"|"automated"
"you are talking to"|"this is an AI"
chatbot.?disclosure|virtual.?agent.?notice
interaction.?notice|AI.?generated
```

**Evidence to check**:
- User-facing AI disclosure messages
- Terms of service mentioning AI interaction
- Chatbot/assistant identification
- Onboarding flows with AI disclosure

### 50(2) — Synthetic Content Labeling

**Required**: AI-generated content (text, image, audio, video) shall be marked in a machine-readable format as artificially generated or manipulated.

**Search patterns**:
```
watermark|metadata.?tag|content.?label
AI.?generated.?mark|synthetic.?label|provenance
C2PA|content.?credentials|content.?authenticity
EXIF.*AI|metadata.*artificial|machine.?readable.?mark
digital.?watermark|steganograph|invisible.?mark
```

**Evidence to check**:
- Content watermarking implementation
- Metadata tagging for AI-generated content
- C2PA or Content Authenticity Initiative integration
- Machine-readable labeling of synthetic outputs

### 50(3) — Deepfake Disclosure

**Required**: AI systems generating deepfakes shall disclose the content has been artificially generated or manipulated.

**Search patterns**:
```
deepfake|face.?swap|voice.?clone|synthetic.?media
generated.?face|generated.?voice|manipulated.?video
deep.?fake.?disclosure|synthetic.?disclosure
```

### 50(4) — Emotion Recognition and Categorization Disclosure

**Required**: AI systems performing emotion recognition or biometric categorization shall inform affected persons.

**Search patterns**:
```
emotion.?disclosure|emotion.?notice
biometric.?notice|categorization.?notice
affect.?disclosure|sentiment.?notice
```

## Output Format

```markdown
## Transparency Audit (Articles 13 + 50)

### Article 13 — High-Risk Transparency

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| Sufficient transparency | 13(1) | [STATUS] | [evidence] |
| Appropriate type/degree | 13(2) | [STATUS] | [evidence] |
| Provider identity | 13(3)(a) | [STATUS] | [evidence] |
| Capabilities & limitations | 13(3)(b) | [STATUS] | [evidence] |
| Changes documentation | 13(3)(c) | [STATUS] | [evidence] |
| Human oversight info | 13(3)(d) | [STATUS] | [evidence] |
| Expected lifetime | 13(3)(e) | [STATUS] | [evidence] |

### Article 50 — Limited-Risk Transparency

| Requirement | Article | Status | Evidence |
|-------------|---------|--------|----------|
| AI interaction disclosure | 50(1) | [STATUS] | [evidence] |
| Synthetic content labeling | 50(2) | [STATUS] | [evidence] |
| Deepfake disclosure | 50(3) | [STATUS] | [evidence] |
| Emotion/biometric notice | 50(4) | [STATUS] | [evidence] |

**Overall Transparency Compliance**: [PERCENTAGE]%

### Critical Gaps
[List most important missing elements]

### Remediation Priority
1. [Highest priority action]
2. [Second priority]
3. [Third priority]
```
