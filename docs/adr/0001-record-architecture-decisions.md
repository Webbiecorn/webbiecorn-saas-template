# ADR 0001: Architecture Decision Records gebruiken

## Status
Accepted

## Context
We bouwen meerdere apps/tools. Zonder vaste decision logging raken keuzes en redenen kwijt.
Dat maakt onderhoud, onboarding en refactors duurder dan nodig.

## Decision
We gebruiken ADR’s voor belangrijke technische keuzes:
- auth/billing stack
- database keuzes
- hosting/deploy strategie
- conventions met impact

## Consequences
✅ Voordelen:
- keuzes zijn traceerbaar
- sneller refactoren
- makkelijker samenwerken

⚠️ Nadelen:
- kleine overhead (alleen bij belangrijke keuzes)
