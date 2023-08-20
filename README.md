# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
gclud init
docker tag api-paiva-lima-web  us-east1-docker.pkg.dev/paiva-lima-empreendimentos/paiva-lima/paiva-lima-api:latest
gcloud artifacts repositories describe paiva-lima --project=paiva-lima-empreendimentos --location=us-east1
* ...
