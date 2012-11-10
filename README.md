Reminders is an Cobot app that sends an email to each member of a space a number of days before the next invoice is due.

## Setup

* Rails/Postgres
* mail server/service
* a process must be set up that POSTs to `/reminder_notifications?token=<api token>` once a day to send out the emails
* the API token should be set via the API_TOKEN environment variable
* for OAuth to work an application must be registered on Cobot and the app id and secret must be set via the COBOT_APP_ID/COBOT_APP_SECRET environment variables


# Sending Email

If you want to use iron.io's IronWorker for triggering the emails there is a worker at `workers/notification_worker`.

Schedule it like this (run the app's Rails console from the workers directory):

    client = IronWorkerNG::Client.new
    client.schedules.create('notification',
      {callback_url: app.reminder_notifications_url(api_token: Reminders::Config.api_token))},
      {
        start_at: Time.now,
        run_every: 60 * 60 * 24}) # every day
    client.tasks.schedule("notification",

For sending emails if you want to use Mailgun.org you have to set up the environment variables from `production.rb`.
