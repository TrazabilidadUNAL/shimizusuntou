class AddShowToRouteLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :route_logs, :show, :boolean, default: true
  end
end
