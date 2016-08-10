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

class DeploymentKey < ApplicationRecord
end
