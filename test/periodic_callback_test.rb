require_relative 'test_helper'

class PeriodicCallbackTest < Minitest::Test
  def setup
    FakeWeb.allow_net_connect = false
    FakeWeb.register_uri(:post, "https://ingest.signalfx.com/v2/datapoint", :status => ["200", "OK"])
    
    client = SignalFx.new('INVALID')
    ScoutSignalfx.configure(client)
  end

  def test_call
    callback = ScoutSignalfx::PeriodicCallback.new
    callback.call(reporting_period, metadata) # would be great to validate the actual reported metrics
  end

  private

  def reporting_period
    rp = ScoutApm::StoreReportingPeriod.new(ScoutApm::AgentContext.new, Time.at(metadata[:agent_time].to_i))
    rp.absorb_metrics!(metrics)
  end

  def metrics
    meta = ScoutApm::MetricMeta.new("Controller/users/index")
    stats = ScoutApm::MetricStats.new
    stats.update!(0.1)
    {
      meta => stats
    }
  end

  def metadata
    {:app_root=>"/srv/rails_app", :unique_id=>"ID", :agent_version=>"2.4.10", :agent_time=>"1523287920", :agent_pid=>21581, :platform=>"ruby"}
  end

end