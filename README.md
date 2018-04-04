# ScoutSignalfx

Bring your key Ruby on Rails health metrics into [SignalFx](https://signalfx.com/) with the `scout_signalfx` gem. The gem leverages the [Scout](https://scoutapp.com) Ruby gem, which gathers detailed performance on every web request, and sends those metrics direct to SignalFx.

A Scout account isn't required, but it certainly makes performance investigations more fun.

![signalfx dash](https://s3-us-west-1.amazonaws.com/scout-blog/scout_signalfx/signalfx_dash.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scout_signalfx'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scout_signalfx

## Configuration

### Add a `config/initializers/signalfx.rb` file to your Rails app:

Initialize a `SignalFx` client and pass it through to `ScoutSignalfx#init`:

```ruby
SIGNAL_FX_CLIENT = SignalFx.new("[SIGNAL_FX_TOKEN]")
ScoutSignalfx.init(SIGNAL_FX_CLIENT)
```

Your SignalFx API access token can be obtained from the SignalFx organization you want to report data into.

### Add a `config/scout_apm.yml` file to your Rails app:

```yaml
common: &defaults
  monitor: true

development:
  <<: *defaults
  monitor: false # set to true to test in your development environment

production:
  <<: *defaults
```

[See the Scout docs](http://help.apm.scoutapp.com/#ruby-agent) for advanced configuration instructions.

## Metric Schema

The following metrics are reported once per-minute:

* web.duration_ms
* web.count
* web.errors_count

Each metric has the following dimensions:

* app - The name of the app
* host - The hostname of the running app
* transaction - The name of the transaction. For example, `UsersController#index` becomes `users.index` in SignalFx.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scoutapp/scout_signalfx_ruby.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
