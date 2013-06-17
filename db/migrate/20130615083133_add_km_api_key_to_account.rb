class AddKmApiKeyToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :km_api_key, :string
  end
end
