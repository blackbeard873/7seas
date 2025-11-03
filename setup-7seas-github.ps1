$ProjectPath = "C:\projects\7seas"

# Ensure project folder exists

if (-not (Test-Path $ProjectPath)) {
Write-Host "Project folder does not exist: $ProjectPath"
exit
}

# ------------------------

# Create .gitignore

# ------------------------

$GitignoreContent = @"
.venv/
**pycache**/
*.pyc
*.pyo
*.pyd
*.sqlite3
.env

# IDE-specific

.vscode/
.idea/
*.sublime-project
*.sublime-workspace
"@
$GitignorePath = Join-Path $ProjectPath ".gitignore"
$GitignoreContent | Out-File -FilePath $GitignorePath -Encoding utf8 -Force
Write-Host ".gitignore created at $GitignorePath"

# ------------------------

# Create README.md

# ------------------------

$ReadmeContent = @"

# 7seas

FastAPI MMORPG project.

## Setup

1. Create and activate virtual environment:

   ```powershell
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   ```
2. Install dependencies:

   ```powershell
   pip install fastapi uvicorn sqlalchemy aiosqlite pydantic httpx
   ```
3. Run server:

   ```powershell
   uvicorn app.main:app --reload
   ```

## Testing

```powershell
pytest -v
```

"@
$ReadmePath = Join-Path $ProjectPath "README.md"
$ReadmeContent | Out-File -FilePath $ReadmePath -Encoding utf8 -Force
Write-Host "README.md created at $ReadmePath"

# ------------------------

# Create LICENSE (MIT)

# ------------------------

$Year = (Get-Date).Year
$Author = "blackbeard873"
$LicenseContent = @"
MIT License

Copyright (c) $Year $Author

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
$LicensePath = Join-Path $ProjectPath "LICENSE"
$LicenseContent | Out-File -FilePath $LicensePath -Encoding utf8 -Force
Write-Host "LICENSE created at $LicensePath"

Write-Host "`n✅ GitHub essentials (.gitignore, README.md, LICENSE) created successfully!"
