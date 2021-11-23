# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "ff/ruby/server/sdk"
require "minitest/autorun"

class Ff::Ruby::Server::SdkTest < Minitest::Test

  def test_version_number

    refute_nil ::Ff::Ruby::Server::Sdk::VERSION
  end

  def test_client_singleton_inst

    instance = CfClient.instance
    (0..5).each {

      compare_equal = CfClient.instance
      assert_equal(instance, compare_equal)
    }
  end

  def test_client_constructor_inst

    test_string = "test"
    instance_with = Client.new(test_string)
    instance_with_no_config = Client.new(test_string, test_string)

    assert(instance_with != nil)
    assert(instance_with_no_config != nil)
    assert(instance_with != instance_with_no_config)
  end

  def test_config_constructor_inst

    config = Config.new
    config_not_equal = Config.new

    assert(config != nil)
    assert(config_not_equal != nil)
    assert(config != config_not_equal)
  end

  def test_config_properties

    config = Config.new

    assert(Config.min_frequency >= 0)
    assert(config.get_frequency == Config.min_frequency)
    assert(config.config_url == "https://config.ff.harness.io/api/1.0")
    assert(config.event_url == "https://events.ff.harness.io/api/1.0")
    assert(config.stream_enabled)
    assert(config.analytics_enabled)
    assert(config.frequency == Config.min_frequency)
    assert(!config.all_attributes_private)
    assert(config.private_attributes == Set[])
    assert(config.connection_timeout == 10 * 1000)
    assert(config.read_timeout == (Config.min_frequency * 1000) / 2)
    assert(config.write_timeout == config.connection_timeout)
    assert(!config.debug)
    assert(config.metrics_service_acceptable_duration == config.connection_timeout)

    # TODO: Assert cache and storage

    number = 100
    bool = false
    string = "test"

    config.frequency = number
    config.config_url = string
    config.event_url = string
    config.stream_enabled = bool
    config.analytics_enabled = bool
    config.all_attributes_private = !bool
    config.private_attributes = Set[string]
    config.connection_timeout = number
    config.read_timeout = number
    config.write_timeout = number
    config.debug = !bool
    config.metrics_service_acceptable_duration = number

    assert(config.get_frequency == number)
    assert(config.config_url == string)
    assert(config.event_url == string)
    assert(!config.stream_enabled)
    assert(!config.analytics_enabled)
    assert(config.frequency == number)
    assert(config.all_attributes_private)
    assert(config.private_attributes == Set[string])
    assert(config.connection_timeout == number)
    assert(config.read_timeout == number)
    assert(config.write_timeout == number)
    assert(config.debug)
    assert(config.metrics_service_acceptable_duration == number)
  end
end