---
name: prohibited-practices-check
description: >
  Checks for all 8 prohibited AI practices defined in Article 5 of the EU AI Act.
  Scans code for patterns indicating social scoring, subliminal manipulation,
  vulnerability exploitation, real-time biometric identification, predictive policing,
  untargeted facial scraping, workplace emotion recognition, and biometric categorization.
---

# Prohibited Practices Check (Article 5)

Audit the codebase for any of the 8 categories of prohibited AI practices.

## Prohibited Practice 1: Social Scoring (Art. 5(1)(c))

**What's prohibited**: AI systems used by public authorities (or on their behalf) to evaluate or classify natural persons based on social behavior or personal characteristics, leading to detrimental treatment.

**Search patterns**:
```
social.?score|citizen.?score|trustworthiness.?score
behavioral.?rating|social.?credit|reputation.?system
aggregate.?behavior.?score|compliance.?score
public.?authority|government|municipal|federal
```

**Evidence to check**:
- Scoring algorithms that aggregate personal behavior data
- Integration with government or public authority systems
- Detrimental consequences based on scores (access denial, restrictions)
- Cross-context data aggregation for scoring purposes

**Assessment**:
- PASS: No social scoring patterns detected
- FAIL: Social scoring system detected — must be discontinued immediately

## Prohibited Practice 2: Subliminal Manipulation (Art. 5(1)(a))

**What's prohibited**: AI systems that deploy subliminal techniques beyond a person's consciousness to materially distort behavior, causing significant harm.

**Search patterns**:
```
subliminal|below.?threshold|unconscious.?influence
dark.?pattern|manipulat.*behavior|deceptive.?ai
micro.?target.*vulnerab|exploit.*cognitive.?bias
persuasion.?engine|behavioral.?nudge.*harm
```

**Evidence to check**:
- Techniques designed to influence below conscious awareness
- A/B testing targeting psychological vulnerabilities
- Behavioral modification without user awareness
- Persuasion systems that could cause significant harm

**Assessment**:
- PASS: No subliminal manipulation patterns detected
- PARTIAL: Persuasion techniques found but harm potential unclear — needs review
- FAIL: Subliminal manipulation system detected

## Prohibited Practice 3: Vulnerability Exploitation (Art. 5(1)(b))

**What's prohibited**: AI systems exploiting vulnerabilities of persons due to age, disability, or specific social/economic situation to materially distort behavior.

**Search patterns**:
```
age.?target|child.?target|elderly.?target|minor.?target
disability.?detect|cognitive.?impair|mental.?health.?target
economic.?vulnerab|poverty.?target|financial.?distress
exploit.*vulnerable|target.*disadvantaged
segment.*age.*risk|persona.*vulnerable
```

**Evidence to check**:
- User segmentation by vulnerability factors
- Differential treatment targeting vulnerable groups
- Marketing or persuasion adapted to exploit vulnerabilities
- Accessibility features misused for targeting

**Assessment**:
- PASS: No vulnerability exploitation patterns detected
- PARTIAL: Vulnerability-aware features found but purpose appears protective
- FAIL: Exploitation of vulnerable groups detected

## Prohibited Practice 4: Real-time Remote Biometric Identification (Art. 5(1)(h))

**What's prohibited**: Real-time remote biometric identification in publicly accessible spaces for law enforcement (with narrow exceptions).

**Search patterns**:
```
real.?time.*face|live.*facial|streaming.*biometric
surveillance.*camera.*face|cctv.*recognition
public.?space.*identif|crowd.*face.*detect
law.?enforcement.*biometric|police.*facial
remote.*biometric.*identif.*real
```

**Evidence to check**:
- Real-time processing of biometric data from video feeds
- Integration with surveillance camera systems
- Deployment in publicly accessible spaces
- Law enforcement use case without qualifying exemption

**Assessment**:
- PASS: No real-time remote biometric identification in public spaces
- PARTIAL: Biometric system exists but not in real-time/public context
- FAIL: Real-time remote biometric identification in public spaces detected

## Prohibited Practice 5: Predictive Policing (Art. 5(1)(d))

**What's prohibited**: AI systems making risk assessments of natural persons to predict criminal offending based solely on profiling or personality traits.

**Search patterns**:
```
predict.*crim|crime.*predict|recidivism.*predict
risk.*assess.*offend|criminal.*profil|pre.?crime
threat.*assess.*individual|dangerousness.*score
reoffend.*probability|criminal.*risk.*score
```

**Evidence to check**:
- Criminal behavior prediction models
- Risk scoring based on personal characteristics (not objective facts)
- Profiling-based law enforcement systems
- Recidivism prediction without objective, verifiable facts

**Assessment**:
- PASS: No predictive policing patterns detected
- FAIL: Predictive policing system based on profiling detected

## Prohibited Practice 6: Untargeted Facial Scraping (Art. 5(1)(e))

**What's prohibited**: AI systems creating or expanding facial recognition databases through untargeted scraping from the internet or CCTV.

**Search patterns**:
```
scrape.*face|face.*scrape|facial.*scrape|face.*crawl
web.*scrape.*image.*face|bulk.*face.*download
cctv.*collect.*face|surveillance.*face.*database
facial.*database.*build|face.*dataset.*scrape
clearview|faceprint.*collect
```

**Evidence to check**:
- Web scraping targeting facial images
- Bulk collection of facial data from surveillance
- Facial recognition database building from public sources
- APIs or tools for mass facial image collection

**Assessment**:
- PASS: No untargeted facial scraping detected
- FAIL: Untargeted facial scraping system detected

## Prohibited Practice 7: Emotion Recognition in Workplace/Education (Art. 5(1)(f))

**What's prohibited**: AI systems inferring emotions in workplace and educational settings (except for medical or safety reasons).

**Search patterns**:
```
emotion.*recogni.*work|emotion.*detect.*employ
mood.*monitor.*office|stress.*detect.*employ
engagement.*monitor.*student|attention.*track.*class
affect.*comput.*workplace|sentiment.*face.*work
employee.*emotion|student.*emotion|worker.*mood
fatigue.*detect.*work|productivity.*emotion
```

**Evidence to check**:
- Emotion detection in workplace monitoring systems
- Student engagement or attention tracking
- Employee mood or stress monitoring
- Absence of medical/safety justification

**Assessment**:
- PASS: No workplace/education emotion recognition detected
- PARTIAL: Emotion recognition found but has medical/safety justification
- FAIL: Workplace/education emotion recognition without valid exemption

## Prohibited Practice 8: Biometric Categorization of Sensitive Attributes (Art. 5(1)(g))

**What's prohibited**: AI systems categorizing persons based on biometric data to deduce or infer race, political opinions, trade union membership, religious beliefs, sex life, or sexual orientation.

**Search patterns**:
```
race.*classif.*biometric|ethnicity.*detect.*face
gender.*classif.*biometric|sex.*determin.*face
religion.*detect.*biometric|political.*opinion.*infer
sexual.*orient.*detect|union.*member.*infer
sensitive.*attribute.*biometric|protected.*class.*biometric
demographic.*infer.*face|race.*predict.*image
```

**Evidence to check**:
- Biometric data used to infer sensitive characteristics
- Facial analysis for race, gender, or other protected attributes
- Voice or behavioral biometrics for sensitive categorization
- Model outputs that classify sensitive personal attributes

**Assessment**:
- PASS: No sensitive biometric categorization detected
- PARTIAL: Biometric processing exists but doesn't target sensitive attributes
- FAIL: Biometric categorization of sensitive attributes detected

## Output Format

```markdown
## Prohibited Practices Audit (Article 5)

| # | Practice | Status | Evidence |
|---|----------|--------|----------|
| 1 | Social Scoring | [PASS/FAIL] | [files/patterns found] |
| 2 | Subliminal Manipulation | [PASS/FAIL/PARTIAL] | [files/patterns found] |
| 3 | Vulnerability Exploitation | [PASS/FAIL/PARTIAL] | [files/patterns found] |
| 4 | Real-time Biometric ID | [PASS/FAIL/PARTIAL] | [files/patterns found] |
| 5 | Predictive Policing | [PASS/FAIL] | [files/patterns found] |
| 6 | Untargeted Facial Scraping | [PASS/FAIL] | [files/patterns found] |
| 7 | Workplace Emotion Recognition | [PASS/FAIL/PARTIAL] | [files/patterns found] |
| 8 | Sensitive Biometric Categorization | [PASS/FAIL/PARTIAL] | [files/patterns found] |

### Details
[For each non-PASS finding, provide detailed analysis]

### Recommendation
[If any FAIL: System must be discontinued or fundamentally redesigned]
[If any PARTIAL: Requires legal review and documentation of exemption basis]
```
