---
version: 2.0.0
title: "Setting Active Directory User Expiration"
date: 2026-09-30
description: Sets an Active Directory user account expiration date.
tags: [powershell, activedirectory, snippet]
post_url: https://www.johnjheisler.net/2026/10/activedir-expiration.html
---
## Overview
Sets an Active Directory user account expiration date.

`Set-UserExpiration` sets the expiration date for one or more Active Directory user accounts. If no date is specified, the account is configured to expire in 90 days. If a date greater than 90 days in the future is provided, the date is automatically capped at 90 days.

Supports pipeline input and `-WhatIf`.

## Parameters

### Identities
The user account(s) to modify.

### Date
Optional expiration date.

- Defaults to 90 days from today.
- Dates greater than 90 days in the future are capped at 90 days.

### Server
Optional domain controller to query and update.

## Examples

### Expire an account in 90 days

```powershell
Set-UserExpiration -Identities JHeisler
```

### Set a specific expiration date

```powershell
Set-UserExpiration -Identities JHeisler -Date "12/15/2026"
```

### Process multiple users

```powershell
Set-UserExpiration -Identities JHeisler,JSmith,JDoe
```

### Pipeline input

```powershell
'JHeisler','JSmith','JDoe' | Set-UserExpiration
```

### Preview changes

```powershell
Set-UserExpiration -Identities JHeisler -Date "12/15/2026" -WhatIf
```

## Output

Returns a custom object containing:

- SamAccountName
- Name
- ExpirationDate
- Success

## Notes

- Requires the Active Directory PowerShell module.
- Supports `-WhatIf` and `-Confirm`.
- Designed for use in automation workflows and bulk account management tasks.
