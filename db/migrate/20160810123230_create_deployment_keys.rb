class CreateDeploymentKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :deployment_keys do |t|
      t.string :encrypted_private, null: false
      t.string :public, null: false
      t.string :iv, null: false
      t.string :name, null: false, default: ''
      t.string :cipher_algorithm, null: false

      t.timestamps
    end
  end
end
