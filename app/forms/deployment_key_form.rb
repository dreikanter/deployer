class DeploymentKeyForm < Reform::Form
  property :name

  validates :name, length: { maximum: Const::Limits::DEPLOYMENT_KEY_NAME_MAX }
end
