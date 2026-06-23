# NivassHub

Smart gated community management platform for residential societies.

## Branch Strategy

```text
main                  ← production-ready, protected (no direct pushes)
└── develop           ← integration branch
    ├── feature/authentication
    ├── feature/dashboard
    ├── feature/profile
    └── feature/notifications

react-native          ← all React Native / Expo development
```

**Rules:**

- `main` requires a PR + at least 1 approval before merging
- Direct pushes to `main` are disabled
- All React Native development lives in the `react-native` branch
- General feature work flows through `develop` or `feature/*` branches
- Only authorized team members can merge into `main`
