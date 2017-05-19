class AddTokenCreatedAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token_created_at, :datetime
    remove_index :users, :auth_token
    add_index :users, [:auth_token, :token_created_at]
  end
end
