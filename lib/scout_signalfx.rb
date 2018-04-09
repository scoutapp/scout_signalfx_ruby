module ScoutSignalfx
  # Takes a +SignalFxClient+ and configures the ScoutApm SignalFx Payload Plugin.
  def self.configure(signalfx_client)
    @@signalfx_client ||= signalfx_client
    ScoutApm::Extensions::Config.add_periodic_callback(ScoutSignalfx::PeriodicCallback)
  end

  def self.signalfx_client
    @@signalfx_client
  end
end

require "scout_signalfx/version"
require "scout_signalfx/periodic_callback"