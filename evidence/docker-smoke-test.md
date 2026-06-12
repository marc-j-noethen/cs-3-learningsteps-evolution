# Docker Smoke Test

Date: 2026-06-12

## Purpose

This smoke test verifies that the LearningSteps API runs successfully as a Docker container and can connect to PostgreSQL over a Docker bridge network.

## Setup

- API image: `learningsteps-api:local`
- API container: `learningsteps-api`
- PostgreSQL container: `learningsteps-postgres`
- Docker network: `learningsteps-net`
- API URL: `http://localhost:8000`
- Container `DATABASE_URL`: `postgresql://postgres:postgres@learningsteps-postgres:5432/learning_journal`

## Docker Build Evidence

```text
[+] Building 21.4s (11/11) FINISHED
naming to docker.io/library/learningsteps-api:local
```

```text
IMAGE                     ID             DISK USAGE   CONTENT SIZE   EXTRA
learningsteps-api:local   de34fb6bdfe9        294MB         70.2MB
```

## Docker Runtime Evidence

```text
CONTAINER ID   IMAGE                     COMMAND                  CREATED          STATUS          PORTS                                         NAMES
a3a7d4d57f7d   learningsteps-api:local   "uvicorn main:app --..."   43 seconds ago   Up 42 seconds   0.0.0.0:8000->8000/tcp, [::]:8000->8000/tcp   learningsteps-api
```

```text
INFO:     Started server process [1]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
```

## API Evidence

```powershell
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> $response = Invoke-RestMethod -Method Post -Uri 'http://localhost:8000/entries' -ContentType 'application/json' -Body '{"work":"Tested Dockerized FastAPI container","struggle":"Understanding container networking","intention":"Document Docker evidence next"}'
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> $response

detail                     entry
------                     -----
Entry created successfully @{id=a1eda49c-3383-4362-9675-051167f8ccff; work=Tested Dockerized FastAPI container; struggle=Understanding container networking; intention=Document Docker evidence next; created...


PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> $entryId = $response.entry.id
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> $entryId
a1eda49c-3383-4362-9675-051167f8ccff
PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> Invoke-RestMethod -Method Get -Uri "http://localhost:8000/entries/$entryId"


id         : a1eda49c-3383-4362-9675-051167f8ccff
work       : Tested Dockerized FastAPI container
struggle   : Understanding container networking
intention  : Document Docker evidence next
created_at : 2026-06-12T11:18:50.084306+00:00
updated_at : 2026-06-12T11:18:50.084306+00:00



PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> Invoke-RestMethod -Method Delete -Uri "http://localhost:8000/entries/$entryId"

detail
------
Entry deleted


PS C:\Users\lukas\Desktop\Workspace\Github-Path\01-Uploaded-Repos\cs-projects\cs-3-learningsteps-evolution> Invoke-RestMethod -Method Get -Uri "http://localhost:8000/entries/$entryId"
Invoke-RestMethod : {"detail":"Entry not found"}
In Zeile:1 Zeichen:1
+ Invoke-RestMethod -Method Get -Uri "http://localhost:8000/entries/$en ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: (System.Net.HttpWebRequest:HttpWebRequest) [Invoke-RestMethod], WebException
    + FullyQualifiedErrorId : WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeRestMethodCommand
```

## Result

The Dockerized FastAPI application works successfully with the PostgreSQL container over the `learningsteps-net` Docker bridge network.
