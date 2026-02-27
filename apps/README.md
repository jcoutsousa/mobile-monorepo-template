# Apps

Mobile applications live here. Each app has its own directory with a framework prefix.

## Naming Convention

| Prefix | Framework | Example |
|--------|-----------|---------|
| `flutter_` | Flutter | `flutter_myapp/` |
| `rn_` | React Native | `rn_myapp/` |
| `kotlin_` | Kotlin/KMP | `kotlin_myapp/` |
| `ios_` | Swift/iOS | `ios_myapp/` |

## Create a New App

```bash
# From the repo root
./scripts/bootstrap.sh flutter myapp
./scripts/bootstrap.sh rn myapp
./scripts/bootstrap.sh kotlin myapp
```

CI automatically detects apps by their prefix — no workflow changes needed.
