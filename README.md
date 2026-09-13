# Recruitment Portal

A recruitment/ATS web application with a .NET 8 Web API backend and an Angular 18 frontend.

## Tech Stack

- **Backend:** ASP.NET Core 8 Web API, Dapper, SQL Server (`Microsoft.Data.SqlClient`), JWT authentication, Swagger/OpenAPI, MailKit
- **Frontend:** Angular 18, TypeScript
- **Database:** SQL Server

## Prerequisites

Install the following before you start:

- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Node.js 18+](https://nodejs.org/) (includes npm)
- [Angular CLI](https://angular.dev/tools/cli) — `npm install -g @angular/cli`
- SQL Server (Developer/Express edition, or a local instance) + SQL Server Management Studio (optional, for browsing the DB)

## Project Structure

```
RecruitmentPortal/
├── backend/
│   ├── Database/                       # SQL scripts to create/seed the database
│   └── RecruitmentPortal.API/          # ASP.NET Core Web API project
├── frontend/                           # Angular application
└── docs/                               # Project documentation
```

## 1. Database Setup

1. Make sure your SQL Server instance is running.
2. Open `backend/Database/RecruitmentPortal_Demo.sql` in SQL Server Management Studio (or run it via `sqlcmd`) and execute it. This creates the `RecruitmentPortal_Demo` database along with its schema and demo data.

## 2. Backend Setup (`backend/RecruitmentPortal.API`)

1. Navigate to the API project:
   ```bash
   cd backend/RecruitmentPortal.API
   ```
2. Restore dependencies:
   ```bash
   dotnet restore
   ```
3. Configure your local settings. `appsettings.json` ships with **placeholder values only** — fill in your own before running the API:

   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=server_name;Database=RecruitmentPortal_Demo;User Id=User_Name;Password=*****;TrustServerCertificate=True;Encrypt=True;"
   },
   "Jwt": {
     "Key": "32 charector Key place hear",
     ...
   }
   ```

   - `ConnectionStrings:DefaultConnection` — point this at your local SQL Server instance and the credentials you used in step 1 (server name, database `RecruitmentPortal_Demo`, username/password).
   - `Jwt:Key` — set this to your own random secret string, **at least 32 characters long** (used to sign JWT auth tokens).

   Rather than editing `appsettings.json` directly (to avoid accidentally committing real credentials), you can instead override these via **User Secrets**:
   ```bash
   dotnet user-secrets init
   dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Server=YOUR_SERVER;Database=RecruitmentPortal_Demo;User Id=YOUR_USER;Password=YOUR_PASSWORD;TrustServerCertificate=True;Encrypt=True;"
   dotnet user-secrets set "Jwt:Key" "your-own-signing-key"
   ```
   or an `appsettings.Development.json` entry (already git-ignored if named `appsettings.*.local.json`).

   > ⚠️ Never commit real credentials or signing keys back into `appsettings.json` — keep it filled with placeholders in source control.

4. Run the API:
   ```bash
   dotnet run
   ```
   By default it listens on `http://localhost:5000` and `https://localhost:5001`, with Swagger UI available at `/swagger`.

## 3. Frontend Setup (`frontend/`)

1. Navigate to the frontend project:
   ```bash
   cd frontend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Confirm `src/environments/environment.ts` points `apiUrl` at your running backend (defaults to `https://localhost:5001/api`).
4. Start the dev server:
   ```bash
   npm start
   ```
   The app will be available at `http://localhost:4200`.

## Running Both Together

Run the backend (`dotnet run` from `backend/RecruitmentPortal.API`) and the frontend (`npm start` from `frontend`) in two separate terminals. The Angular dev server on port 4200 calls the API on port 5001; CORS for `http://localhost:4200` is already configured in `appsettings.json`.

## Documentation

Additional project documentation (user guide, handbook) is available in the [docs/](docs/) folder.

## License

This project is licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE) — free to use, modify, and share for any **noncommercial purpose** (personal, educational, research, hobby). Commercial or professional use is **not permitted** under this license.
