Reminders is a Cobot app that sends an email to each member of a space a number of days before the next invoice is due.

[![Build Status](https://secure.travis-ci.org/cobot/reminders.png?branch=master)](https://travis-ci.org/cobot/reminders)

The official installation runs under <http://reminders.apps.cobot.me>

## Setup

* Rails/Postgres
* mail server/service
* a process must be set up that POSTs to `/reminder_notifications?token=<api token>` once a day to send out the emails
* the API token should be set via the API_TOKEN environment variable
* for OAuth to work an application must be registered on Cobot and the app id and secret must be set via the COBOT_APP_ID/COBOT_APP_SECRET environment variables


# Sending Email

If you want to use iron.io's IronWorker for triggering the emails there is a worker at `workers/notification_worker`.

First download and copy `iron.json` into the workers directory.

Schedule the worker like this (run the app's Rails console from the workers directory):

    client = IronWorkerNG::Client.new

    code = IronWorkerNG::Code::Base.new(workerfile: "notification.worker")
    client.codes.create(code)

    client.schedules.create('notification_worker',
      {callback_url: app.reminder_notifications_url(host: '<hostname of the app>', token: <your api token>))},
      {
        start_at: Time.now,
        run_every: 60 * 60 * 24}) # every day


For sending emails postmarkapp.com is used by default. You have to set your Postmak API key as an environment variable POSTMARK_API_KEY.
