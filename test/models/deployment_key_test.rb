require "test_helper"

class DeploymentKeyTest < ActiveSupport::TestCase
  def deployment_key
    @deployment_key ||= DeploymentKey.new
  end

  def test_valid
    assert deployment_key.valid?
  end
end
