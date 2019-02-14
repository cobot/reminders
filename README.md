Reminders is a Cobot app that sends an email to each member of a space a number of days before the next invoice is due.

[![Build Status](https://secure.travis-ci.org/cobot/reminders.png?branch=master)](https://travis-ci.org/cobot/reminders)

The official installation runs under <http://reminders.apps.cobot.me>

## Setup

* Rails/Postgres

* run `rake db:create:all` and `rake db:migrate`
* mail server/service
* a cron job must run `rake send_emails` every day to send out the emails
* for OAuth to work an application must be registered on Cobot and the app id and secret must be set via the COBOT_APP_ID/COBOT_APP_SECRET environment variables

For sending emails postmarkapp.com is used by default. You have to set your Postmak API key as an environment variable POSTMARK_API_KEY.
