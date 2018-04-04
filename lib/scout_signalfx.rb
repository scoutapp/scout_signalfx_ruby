module ScoutSignalfx
  # Takes a +SignalFxClient+ and configures the ScoutApm SignalFx Payload Plugin.
  def self.init(signalfx_client)
    @@signalfx_client ||= signalfx_client
    ScoutApm::Plugins.add_payload_callback(ScoutSignalfx::PayloadReporter)
  end

  def self.signalfx_client
    @@signalfx_client
  end
end

require "scout_signalfx/version"
require "scout_signalfx/payload_reporter.rb"