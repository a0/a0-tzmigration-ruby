# A0::TZMigration

This gem provides utilities to help with migrations between timezone changes. Please check the official webpage for documentation:
[https://a0.github.io/a0-tzmigration/](https://a0.github.io/a0-tzmigration/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'a0-tzmigration-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install a0-tzmigration-ruby

## Usage

```ruby
require 'a0-tzmigration-ruby'

# calculate changes from America/Santiago 2015a to America/Punta_Arenas 2017a
version_a = A0::TZMigration::TZVersion.new('America/Santiago', '2015a')
version_b = A0::TZMigration::TZVersion.new('America/Punta_Arenas', '2017a')

version_a.changes(version_b)
# =>
[{:ini_str=>"-∞", :fin_str=>"1890-01-01 04:43:40 UTC", :off_str=>"-00:00:54", :ini=>-Infinity, :fin=>-2524504580, :off=>-54},
 {:ini_str=>"1910-01-01 04:42:46 UTC", :fin_str=>"1910-01-10 04:42:46 UTC", :off_str=>"+00:17:14", :ini=>-1893439034, :fin=>-1892661434, :off=>1034},
 {:ini_str=>"1918-09-01 04:42:46 UTC", :fin_str=>"1918-09-10 04:42:46 UTC", :off_str=>"-00:42:46", :ini=>-1619983034, :fin=>-1619205434, :off=>-2566},
 {:ini_str=>"1946-09-01 03:00:00 UTC", :fin_str=>"1947-04-01 04:00:00 UTC", :off_str=>"+01:00:00", :ini=>-736376400, :fin=>-718056000, :off=>3600},
 {:ini_str=>"1947-05-22 04:00:00 UTC", :fin_str=>"1947-05-22 05:00:00 UTC", :off_str=>"+01:00:00", :ini=>-713649600, :fin=>-713646000, :off=>3600},
 {:ini_str=>"1988-10-02 04:00:00 UTC", :fin_str=>"1988-10-09 04:00:00 UTC", :off_str=>"-01:00:00", :ini=>591768000, :fin=>592372800, :off=>-3600},
 {:ini_str=>"1990-03-11 03:00:00 UTC", :fin_str=>"1990-03-18 03:00:00 UTC", :off_str=>"-01:00:00", :ini=>637124400, :fin=>637729200, :off=>-3600},
 {:ini_str=>"2016-05-15 03:00:00 UTC", :fin_str=>"2016-08-14 04:00:00 UTC", :off_str=>"-01:00:00", :ini=>1463281200, :fin=>1471147200, :off=>-3600}]


# get current known versions in the repository
A0::TZMigration::TZVersion.versions
# =>
  { "2013c" =>
    { "released_at" => "2013-04-19 16:17:40 -0700",
      "timezones" => [ "Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", "Africa/Algiers", "Africa/Asmara", …


# get current known timezones in the repository
A0::TZMigration::TZVersion.timezones
# =>
  { "Africa/Abidjan" =>
    { "versions" => [ "2013c", "2013d", "2013e", "2013f", "2013g", …
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/a0/a0-tzmigration-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the A0::TZMigration project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/a0/a0-tzmigration-ruby/blob/master/CODE_OF_CONDUCT.md).
