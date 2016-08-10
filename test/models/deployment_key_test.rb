# == Schema Information
#
# Table name: deployment_keys
#
#  id                :integer          not null, primary key
#  encrypted_private :string           not null
#  public            :string           not null
#  iv                :string           not null
#  name              :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require "test_helper"

class DeploymentKeyTest < ActiveSupport::TestCase
  def deployment_key
    @deployment_key ||= DeploymentKey.new
  end

  def test_valid
    assert deployment_key.valid?
  end
end
