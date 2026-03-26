---
name: pipedrive
description: Manage Pipedrive CRM — deals, persons, organizations, activities, and pipelines via the Pipedrive REST API. Use when the user asks about leads, deals, contacts, clientes, negócios, or pipeline.
metadata:
  {"openclaw": {"requires": {"bins": ["jq", "curl"], "env": ["PIPEDRIVE_API_TOKEN"]}}}
---

# Pipedrive Skill

Manage your Pipedrive CRM directly from the assistant.

## Setup

Set the environment variable:
```bash
export PIPEDRIVE_API_TOKEN="your-api-token"
```

Base URL: `https://api.pipedrive.com/v1`

---

## Common Operations

### Get current user info
```bash
curl -s "https://api.pipedrive.com/v1/users/me?api_token=$PIPEDRIVE_API_TOKEN" | jq '{name: .data.name, email: .data.email}'
```

### List all pipelines
```bash
curl -s "https://api.pipedrive.com/v1/pipelines?api_token=$PIPEDRIVE_API_TOKEN" | jq '.data[] | {id, name}'
```

### List stages in a pipeline
```bash
curl -s "https://api.pipedrive.com/v1/stages?pipeline_id={pipelineId}&api_token=$PIPEDRIVE_API_TOKEN" | jq '.data[] | {id, name}'
```

### List deals (open)
```bash
curl -s "https://api.pipedrive.com/v1/deals?status=open&limit=50&api_token=$PIPEDRIVE_API_TOKEN" | jq '.data[] | {id, title, value, currency, stage_id, person_name}'
```

### Search deals by title
```bash
curl -s "https://api.pipedrive.com/v1/deals/search?term={query}&api_token=$PIPEDRIVE_API_TOKEN" | jq '.data.items[] | .item | {id, title, value, status}'
```

### Get deal details
```bash
curl -s "https://api.pipedrive.com/v1/deals/{dealId}?api_token=$PIPEDRIVE_API_TOKEN" | jq '.data | {id, title, value, status, stage_id, person_name, org_name}'
```

### Create a deal
```bash
curl -s -X POST "https://api.pipedrive.com/v1/deals?api_token=$PIPEDRIVE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title": "Deal Title", "value": 10000, "currency": "BRL", "pipeline_id": 1}'
```

### Update a deal (e.g. move stage)
```bash
curl -s -X PUT "https://api.pipedrive.com/v1/deals/{dealId}?api_token=$PIPEDRIVE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"stage_id": {newStageId}}'
```

### List persons (contacts)
```bash
curl -s "https://api.pipedrive.com/v1/persons?limit=50&api_token=$PIPEDRIVE_API_TOKEN" | jq '.data[] | {id, name, email: .email[0].value, phone: .phone[0].value}'
```

### Search persons
```bash
curl -s "https://api.pipedrive.com/v1/persons/search?term={query}&api_token=$PIPEDRIVE_API_TOKEN" | jq '.data.items[] | .item | {id, name}'
```

### Create a person
```bash
curl -s -X POST "https://api.pipedrive.com/v1/persons?api_token=$PIPEDRIVE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "Nome", "email": "email@exemplo.com", "phone": "49999999999"}'
```

### List activities (tasks)
```bash
curl -s "https://api.pipedrive.com/v1/activities?done=0&limit=50&api_token=$PIPEDRIVE_API_TOKEN" | jq '.data[] | {id, subject, type, due_date, person_name, deal_title}'
```

### Create an activity
```bash
curl -s -X POST "https://api.pipedrive.com/v1/activities?api_token=$PIPEDRIVE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"subject": "Ligar para cliente", "type": "call", "due_date": "2026-03-25", "deal_id": {dealId}}'
```

### Mark activity as done
```bash
curl -s -X PUT "https://api.pipedrive.com/v1/activities/{activityId}?api_token=$PIPEDRIVE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"done": 1}'
```

### Add note to a deal
```bash
curl -s -X POST "https://api.pipedrive.com/v1/notes?api_token=$PIPEDRIVE_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"content": "Nota aqui", "deal_id": {dealId}}'
```

## Notes

- All monetary values are in the deal's currency (default: BRL for this account)
- Rate limit: 100 requests per 10 seconds per token
- Pagination: use `?start=0&limit=50` and increment `start` by `limit` for next pages
- Date format: `YYYY-MM-DD`
- **TIMEZONE:** Pipedrive stores all timestamps in UTC. The user is in GMT-3 (America/Sao_Paulo).
  Always convert when filtering by "today" or any date: "today in GMT-3" starts at 03:00 UTC.
  Example: to filter deals created today (GMT-3), use `add_time >= "YYYY-MM-DD 03:00:00"` UTC.
  A deal at "2026-03-24 01:00 UTC" is actually March 23rd in Brazil (22:00 GMT-3).
