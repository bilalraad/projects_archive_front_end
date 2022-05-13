# Projects Archiving System

A college project for storing students graduation projects with report files as pdf and docs

## Features

- Bulk upload from excel sheet.

- Create & Edit a project.

- The ability to create a backup for all the data.

- Download backup data (files and sql data).

- Restore data from the backup list or from downloaded file.

- Authentication with email and password.

- Authorization with JWT.

- Forgot password with email.

## Getting Started

To get started you need to clone the Laravel server to your machine and run the command `php artisan serve`.

Also clone this repo to your computer
then create a file int the `assets` folder named `e.env` and paste this in it:

``` #env
BASE_URL="http://127.0.0.1:8000/api"
```

Then open the terminal and run `flutter pub get` followed by the command `flutter run web -d chrome --web-port 8001 --web-renderer html`

## And congrats
