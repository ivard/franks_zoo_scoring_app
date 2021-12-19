# franks_zoo_scoring_app

Scoring app for the Frank's Zoo card game (by Doris Matthaus and Frank Nestel).
It is a progressive web application being built using the Flutter framework.

A hosted version can be found [here](https://drksn.nl/frankszoo/). For now, the only supported language is Dutch (nl).

## Developing

Please follow the [getting started of Flutter](https://docs.flutter.dev/get-started/install) first.

Then you can run the application like this:

    flutter run

When running this, Google Chrome will be opened in debug mode automatically.

Developing can be done using [one of the editors supported by Flutter](https://docs.flutter.dev/get-started/editor).

## Running with Docker

    docker build -t frankszoo:edge .
    docker run -p 8080:80 frankszoo:edge
