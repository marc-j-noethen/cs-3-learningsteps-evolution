# Local Smoke Test

Date: 2026-06-12

## Purpose

This smoke test verifies the most important local end-to-end path of the LearningSteps API:

```text
PowerShell client
  -> FastAPI application running with uvicorn
  -> EntryService
  -> PostgresDB repository
  -> PostgreSQL container
  -> entries table
```

A smoke test is not a complete test suite. It does not prove every validation rule, edge case, security control, concurrency behavior, or failure mode. It is still valuable because it quickly proves that the main system path is alive and that the core components can work together.

## Setup

- PostgreSQL container image: `postgres:16-alpine`
- Database: `learning_journal`
- API runtime: FastAPI via uvicorn
- API URL: `http://localhost:8000`
- Database URL used locally: `postgresql://postgres:postgres@localhost:5432/learning_journal`

## Tested Endpoints

- `POST /entries`
- `GET /entries`
- `GET /entries/{entry_id}`
- `DELETE /entries/{entry_id}`
- `GET /entries/{entry_id}` after delete

## Original PowerShell Output

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. Alle Rechte vorbehalten.

Installieren Sie die neueste PowerShell für neue Funktionen und Verbesserungen! https://aka.ms/PSWindows

PS C:\Users\lukas> $response = Invoke-RestMethod -Method Post -Uri 'http://localhost:8000/entries' -ContentType 'application/json' -Body '{"work":"Tested local FastAPI startup","struggle":"Understanding app to database flow","intention":"Containerize the API next"}'
PS C:\Users\lukas> $response

detail                     entry
------                     -----
Entry created successfully @{id=ec7102aa-6752-4c97-a2a5-3827fadbcd1f; work=Tested local FastAPI startup; struggle=Understanding app to database flow; intention=Containerize the API next; created_at=2026-06...


PS C:\Users\lukas> $entryId = $response.entry.id
PS C:\Users\lukas> $entryId
ec7102aa-6752-4c97-a2a5-3827fadbcd1f
PS C:\Users\lukas> Invoke-RestMethod -Method Get -Uri 'http://localhost:8000/entries'

entries
-------
{@{id=ec7102aa-6752-4c97-a2a5-3827fadbcd1f; work=Tested local FastAPI startup; struggle=Understanding app to database flow; intention=Containerize the API next; created_at=2026-06-12T10:30:18.079499+00:00;...


PS C:\Users\lukas> Invoke-RestMethod -Method Get -Uri "http://localhost:8000/entries/$entryId"


id         : ec7102aa-6752-4c97-a2a5-3827fadbcd1f
work       : Tested local FastAPI startup
struggle   : Understanding app to database flow
intention  : Containerize the API next
created_at : 2026-06-12T10:30:18.079499+00:00
updated_at : 2026-06-12T10:30:18.079499+00:00



PS C:\Users\lukas> Invoke-RestMethod -Method Delete -Uri "http://localhost:8000/entries/$entryId"

detail
------
Entry deleted


PS C:\Users\lukas> Invoke-RestMethod -Method Get -Uri "http://localhost:8000/entries/$entryId"
Invoke-RestMethod : {"detail":"Entry not found"}
In Zeile:1 Zeichen:1
+ Invoke-RestMethod -Method Get -Uri "http://localhost:8000/entries/$en ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke-RestMethod], WebException
    + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeRestMethodCommand
PS C:\Users\lukas> Set-Location -LiteralPath 'C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution'
```

## Result

The local FastAPI to PostgreSQL flow works successfully. The smoke test proves that entries can be created, listed, retrieved by ID, deleted by ID, and that a deleted entry returns `404` with `{"detail":"Entry not found"}`.
