---
name: risk-classification
description: >
  Classifies the AI system's risk level according to EU AI Act Articles 5, 6, and Annex III.
  Determines if the system is unacceptable, high-risk, limited, or minimal risk.
---

# Risk Classification Skill

Classify the AI system's risk level following the EU AI Act decision tree.

## Step 1: Identify AI Components

Search the codebase for AI framework usage:

```
# Python ML/DL frameworks
import tensorflow|from tensorflow|import keras|from keras
import torch|from torch|import pytorch
from transformers|import transformers
from sklearn|import sklearn|from scikit-learn
import xgboost|import lightgbm|import catboost

# LLM/GenAI frameworks
from langchain|import langchain|from llama_index
from openai|import openai|from anthropic|import anthropic
from cohere|import cohere|from google.generativeai

# Computer Vision
import cv2|from cv2|import mediapipe|from mediapipe
from ultralytics|import detectron2|from detectron2
from diffusers|import diffusers

# NLP
import spacy|from spacy|import nltk|from nltk
from sentence_transformers|import gensim

# Reinforcement Learning
import gym|from gym|import stable_baselines
from ray.rllib|import ray
```

Search dependency files:
```
# requirements.txt, setup.py, pyproject.toml, Pipfile
tensorflow|torch|transformers|sklearn|langchain|openai

# package.json
@tensorflow|onnxruntime|@huggingface|openai|langchain

# go.mod
github.com/sashabaranov/go-openai|gorgonia.org
```

## Step 2: Check Prohibited Practices (Art. 5)

Look for indicators of prohibited use cases:

### Social Scoring
```
social.?score|citizen.?score|trust.?score|behavioral.?score
credit.?social|social.?rating|reputation.?score
government.?scoring|authority.?rating
```

### Subliminal Manipulation
```
subliminal|manipulat|dark.?pattern|deceptive.?design
nudge.?engine|behavioral.?manipulation|unconscious.?influence
```

### Vulnerability Exploitation
```
age.?target|disability.?target|child.?target
vulnerable.?group|exploit.?vulnerab|economic.?situation
```

### Real-time Biometric Identification
```
face.?recognition|facial.?recognition|face.?detect
biometric.?identif|real.?time.?identif|live.?identif
remote.?biometric|surveillance.?camera
```

### Predictive Policing
```
predict.?crime|crime.?predict|recidivism|risk.?assess.?offend
criminal.?profil|policing.?predict|pre.?crime
```

### Facial Scraping
```
scrape.?face|face.?scrape|facial.?scrape
web.?scrape.*face|crawl.*face|untargeted.*biometric
```

### Emotion Recognition (workplace/education)
```
emotion.?recogni|sentiment.?face|affect.?comput
mood.?detect|stress.?detect|engagement.?monitor
employee.?emotion|student.?emotion|worker.?mood
```

### Biometric Categorization (sensitive attributes)
```
race.?classif|ethnicity.?detect|gender.?classif
religion.?detect|sexual.?orient|political.?opinion
biometric.?categori.*sensitive
```

## Step 3: Check Annex III High-Risk Categories

Analyze the application domain:

### Biometrics (Annex III, 1)
```
biometric|face.?id|fingerprint|iris.?scan|voice.?id
identity.?verif|person.?identif|authentication.?bio
```

### Critical Infrastructure (Annex III, 2)
```
traffic.?manage|energy.?grid|water.?supply|power.?grid
transport.?system|infrastructure.?control|scada|ics
digital.?infrastructure|network.?manage
```

### Education (Annex III, 3)
```
student.?assess|grade.?predict|admission|enrollment
learning.?assess|education.?score|academic.?eval
exam.?proctor|plagiarism.?detect|student.?monitor
```

### Employment (Annex III, 4)
```
recruit|hiring|resume.?screen|cv.?screen|candidate.?rank
employee.?perform|worker.?eval|promotion.?decision
termination.?decision|workforce.?manage|talent.?assess
```

### Essential Services (Annex III, 5)
```
credit.?scor|loan.?decision|insurance.?pricing
benefit.?eligib|social.?benefit|welfare.?assess
emergency.?dispatch|triage|priority.?dispatch
```

### Law Enforcement (Annex III, 6)
```
law.?enforce|police|criminal.?justice
risk.?assess.*offend|evidence.?analysis|profiling
lie.?detect|polygraph|deception.?detect
```

### Migration (Annex III, 7)
```
border.?control|migration|asylum|visa.?assess
travel.?document|immigration|refugee
```

### Justice & Democracy (Annex III, 8)
```
legal.?research|sentencing|judicial|court.?decision
election|voting|political.?campaign|democratic
```

## Step 4: Check Limited Risk Indicators (Art. 50)

### Human Interaction
```
chatbot|conversational|dialog|assistant
customer.?service|support.?bot|virtual.?agent
interactive|user.?facing|natural.?language.?interface
```

### Synthetic Content Generation
```
generat.*text|generat.*image|generat.*audio|generat.*video
synthetic|deepfake|text.?to.?speech|text.?to.?image
image.?generat|content.?generat|creative.?ai
stable.?diffusion|dall.?e|midjourney
```

## Step 5: Check GPAI Indicators (Art. 51-56)

```
foundation.?model|large.?language|pre.?train
fine.?tun|transfer.?learn|general.?purpose
multi.?modal|multi.?task|base.?model
```

## Output Format

```markdown
## Risk Classification Report

### AI Components Detected
- **Frameworks**: [list detected frameworks with file locations]
- **Models**: [list detected model types and architectures]
- **Data Pipelines**: [list data processing components]
- **Deployment**: [list deployment configurations]

### Classification Result

**Risk Level: [UNACCEPTABLE / HIGH / LIMITED / MINIMAL]**

**Reasoning**:
- [Step-by-step classification logic]
- [Annex III category if high-risk: category name and number]
- [Art. 50 applicability if limited-risk]

### Applicable Articles
- [List of articles that apply based on risk classification]

### Confidence Level
- [HIGH / MEDIUM / LOW] — [explanation of confidence factors]

### Caveats
- [Areas where classification depends on deployment context]
- [Factors that could change the classification]
```
