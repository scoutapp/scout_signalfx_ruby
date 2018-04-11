module ScoutSignalfx
  # This is ran after each reporting period (once per-minute).
  class PeriodicCallback
    def call(reporting_period, metadata)
      @reporting_period = reporting_period
      @metadata = metadata

      return if controller_metrics.empty?
      ScoutSignalfx.signalfx_client.send(
        gauges: guages,
        counters: counters,
      )
    end

    private

    def metrics
      @reporting_period.metrics_payload
    end

    # The time associated w/the metrics
    def timestamp
      Time.at(@metadata[:agent_time].to_i)
    end

    def timestamp_ms
      timestamp.to_i*1000
    end

    def transaction_name
      metrics.keys.first.metric_name
    end

    # Renames Scout metric names to a more SignalFx-ish format. 
    # Ex: Controllers/users/index => users.index
    def signalfx_transaction_name(transaction_name)
      @signalfx_transaction_name ||= transaction_name.sub!("Controller/",'').gsub("/",".")
    end

    def controller_metrics
      @controller_metrics ||= metrics.select { |meta,metric| meta.type == 'Controller' }
    end

    def controller_error_metrics
      @controller_error_metrics ||= metrics.select { |meta,metric| meta.type == 'Errors' && meta.name =~ /\AController/ }
    end

    def guages
      controller_metrics.map do |meta,metric|
        {
          metric: 'web.duration_ms',
          value: (metric.total_call_time / metric.call_count.to_f)*1000,
          timestamp: timestamp_ms,
          dimensions: dimensions_for_metric_name(meta.metric_name)
        }
      end
    end

    def counters
      controller_metrics.map do |meta,metric|
          {
            metric: 'web.count',
            value: metric.call_count,
            timestamp: timestamp_ms,
            dimensions: dimensions_for_metric_name(meta.metric_name)
          }
      end + controller_error_metrics.map do |meta,metric|
        {
          metric: 'web.errors.count',
          value: metric.call_count,
          timestamp: timestamp_ms,
          dimensions: dimensions_for_metric_name(meta.name)
        }
      end
    end

    def dimensions_for_metric_name(metric_name)
      [
        {key: 'host', value: ScoutApm::Agent.instance.context.environment.hostname}, 
        {key: 'transaction', value: signalfx_transaction_name(metric_name)},
        {key: 'app', value: ScoutApm::Agent.instance.context.config.value('name')}
      ]
    end

  end
end