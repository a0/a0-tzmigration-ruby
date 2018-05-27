# JSON data files

All info is publicly available at the following URL:
[https://a0.github.io/a0-tzmigration-ruby/data/](https://a0.github.io/a0-tzmigration-ruby/data/)

The JSON structure is mostly self explanatory, just don't asume anything: always use a pair of version/timezone to get the data.

There are two folders within data: Timezones and Versions.

## Timezones

For accessing the historical versions of a timezone, each one is saved in an individual JSON file. For example Africa/Cairo is available at [https://a0.github.io/a0-tzmigration-ruby/data/timezones/Africa/Cairo.json](https://a0.github.io/a0-tzmigration-ruby/data/timezones/Africa/Cairo.json).

Some timezones are just alias to a real timezone, like [Chile/Continental](https://a0.github.io/a0-tzmigration-ruby/data/timezones/Chile/Continental.json) is an alias for [America/Santiago](https://a0.github.io/a0-tzmigration-ruby/data/timezones/America/Santiago.json). Don't assume an alias is perpetual, [Africa/Asmera](https://a0.github.io/a0-tzmigration-ruby/data/timezones/Africa/Asmera.json) has switched between [Africa/Asmara](https://a0.github.io/a0-tzmigration-ruby/data/timezones/Africa/Asmara.json) and [Africa/Nairobi](https://a0.github.io/a0-tzmigration-ruby/data/timezones/Africa/Nairobi.json) depending on the version of tzdb.

Also, not every timezone was present at all versions, for example [America/Punta_Arenas](https://a0.github.io/a0-tzmigration-ruby/data/timezones/America/Punta_Arenas.json) has only versions 2017a onwards.

The [data/timezones/00-index.json](https://a0.github.io/a0-tzmigration-ruby/data/timezones/00-index.json) file has all known timezones, including versions.

## Versions

For accessing the data from a version perspective, there is one file for every version released. For example, version 2018e is available at [https://a0.github.io/a0-tzmigration-ruby/data/versions/2018e.json](https://a0.github.io/a0-tzmigration-ruby/data/versions/2018e.json).

The released_at date of each version correspond to the date stamped in the [NEWS](ftp://ftp.iana.org/tz/tzdb-2018e/NEWS) file. We only have data from versions 2013c onwards, because we gather from the [tzinfo-data](https://github.com/tzinfo/tzinfo-data) ruby gem.

The [data/versions/00-index.json](https://a0.github.io/a0-tzmigration-ruby/data/versions/00-index.json) file has all known versions, including timezones.
