# Google Play — Data safety (PromptVault v1)

Use **App content → Data safety**. Answers must match [privacy policy](https://aarunbhardwaj.github.io/prompt-vault/privacy/) and in-app behavior.

## Summary answers

| Question | Answer |
|----------|--------|
| Does your app collect or share any of the required user data types? | **No** |
| Is all of the user data collected by your app encrypted in transit? | N/A (no collection) or **Yes** if Play requires for “data processed on device only” |
| Do you provide a way for users to request that their data is deleted? | **Yes** — uninstalling the app removes local data |

## Data types

For v1, declare **no collection** of personal or sensitive user data sent off-device.

Prompt text and favorites are stored **locally** in SQLite on the device only.

## Data usage (if Console asks about on-device data)

| Data | Collected? | Shared? | Purpose | Optional? |
|------|------------|---------|---------|-----------|
| User-generated content (prompts) | Processed on device | No | App functionality | No (core feature) |

## Third parties

- No analytics SDKs (Firebase Analytics, etc.) in v1.
- No ads SDKs in v1.
- Opening the privacy policy link uses the system browser (user-initiated).

## Security practices

- Data stored in app-private storage on Android.
- No backend server for prompt content in v1.
