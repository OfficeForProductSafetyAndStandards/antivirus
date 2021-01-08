# Antivirus server

This project contains the code for an antivirus API. Antivirus is used for [Submit and Search cosmetic product notifications](https://github.com/UKGovernmentBEIS/beis-opss-cosmetics) and [Product safety database](https://github.com/UKGovernmentBEIS/beis-opss-psd) projects.


## Tech Overview

The site is written in [Ruby](https://www.ruby-lang.org/en/) using [Sinatra](http://sinatrarb.com/) and uses the [clamav](https://www.clamav.net/) to scan the files.

## Running locally

* Run `docker build .` from this directory.

## Deployment

The service is deployed automatically when a pull request is opened (to the integration environment) and when merged (to production).


### Deployment from scratch

Set the following environment variables:

    cf set-env antivirus APP_ENV production

This will configure sinatra to run in production mode.

    cf set-env antivirus ANTIVIRUS_USERNAME XXX
    cf set-env antivirus ANTIVIRUS_PASSWORD XXX

This will set HTTP basic auth for the API.

    cf set-env antivirus HEALTH_USERNAME XXX
    cf set-env antivirus HEALTH_PASSWORD XXX

This will set the Sentry configuration

    cf set-env antivirus SENTRY_DSN XXX
    cf set-env antivirus SENTRY_CURRENT_ENV <<SPACE>>

This will set HTTP basic auth for the health check.

Finally, create the following credentials for other applications to consume:

    cf cups antivirus-auth-env -p '{
        "ANTIVIRUS_URL": "XXX",
        "ANTIVIRUS_USERNAME": "XXX",
        "ANTIVIRUS_PASSWORD": "XXX"
    }'
