---
name: security-hardening
description: Check and harden code that touches user input, auth, secrets, permissions, files, external services or production data. Use before you ship such a change, or for "security", "harden", "is this safe" or "threat model".
metadata:
  track: engineering
  tier: 4
  tagline: Treat every input as hostile until proven safe.
---

# Security hardening

Find how an attacker or bad input can misuse the change. Close each path before you ship.

## 1. Map the boundaries

List each place where data from outside enters the change: requests, forms, files, URLs, environment, other services, model output, logs, config. Treat all of it as untrusted.

## 2. Always do

- Validate all input at the boundary, with a schema. Reject what does not match.
- Use parameters for database queries. Never build a query or shell command from strings.
- Encode output. Use the escape functions of the framework. Do not bypass it.
- Check permission on every endpoint and every object. A user gets only their own data.
- Hash passwords with bcrypt, scrypt or argon2.
- Use `httpOnly`, `secure` and `sameSite` cookies for sessions.
- Set security headers: CSP, HSTS, X-Content-Type-Options, frame options.
- Use HTTPS for all external calls.
- Run the dependency audit (`npm audit`, `pip-audit` or equivalent). Fix critical issues that the code can reach.

## 3. Ask the user first

- New or changed login or auth logic.
- A new type of sensitive data to store (personal or payment data).
- A new external service or a new dependency.
- CORS changes, file uploads, rate-limit changes.
- New roles or higher permissions.

## 4. Never do

- Commit secrets. Keep them in an ignored `.env`. Commit only `.env.example`.
- Log passwords, tokens or full card numbers.
- Trust client-side checks as security.
- Use `eval`, `innerHTML` or a shell with user data.
- Keep auth tokens in `localStorage`.
- Show stack traces or internal errors to users.
- Turn off a security header or check to make something work.

## 5. Check before you commit

```bash
git diff --cached | grep -inE "password|secret|api[_-]?key|token|BEGIN .*PRIVATE KEY"
```

Read every hit.

## 6. Prove the risky paths

For each real risk, try the attack. Write a test or script that runs the real code with bad input. Examples: an injection string, the ID of a different user, an expired token, an oversize file. Paste the result.

## Checklist

| Area | Check |
|---|---|
| Auth | Hashed passwords, safe cookies, rate limit on login, reset tokens expire |
| Access | Every endpoint checks the user and the object |
| Input | Schema at the boundary, parameter queries, encoded output |
| Data | No secrets in code or history, sensitive fields not in responses |
| Infra | Headers set, CORS to known origins only, dependencies audited, errors hide internals |

## Report

- Each risk: where it is (`file:line`), how it breaks, how likely, how bad, the fix.
- The proof you ran for each risk that matters.
- What you checked and found safe.
