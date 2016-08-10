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

class DeploymentKeysControllerTest < ActionDispatch::IntegrationTest
  def test_index
    get deployment_keys_index_url
    assert_response :success
  end

  def test_new
    get deployment_keys_new_url
    assert_response :success
  end

  def test_edit
    get deployment_keys_edit_url
    assert_response :success
  end

  def test_show
    get deployment_keys_show_url
    assert_response :success
  end

end
