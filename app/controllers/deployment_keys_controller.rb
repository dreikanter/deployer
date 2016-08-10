class DeploymentKeysController < ApplicationController
  def index
    @operation = Operations::DeploymentKey::Index.call(params)
  end

  def create
    @deployment_key = Operations::DeploymentKey::Create.call(params)
  end

  def edit
    @form = DeploymentKeyForm.new(DeploymentKey.find(id))
  end

  def update
    @deployment_key = Operations::DeploymentKey::Update.call(params)
  end

  private

  def id
    params.require(:id)
  end
end
