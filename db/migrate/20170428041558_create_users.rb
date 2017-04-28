class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :type
      t.boolean :show, default: true
      t.integer :origin_id

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true

    execute <<-SQL
    INSERT INTO users(username, password, first_name, last_name, type, show, origin_id, created_at, updated_at)
      SELECT username, password, first_name, last_name, 'producers', show, id, created_at, updated_at
      FROM producers
    SQL

    drop_table :producers, force: :cascade

    execute <<-SQL
    INSERT INTO users(username, password, first_name, type, show, origin_id, created_at, updated_at)
      SELECT username, password, name, 'warehouses', show, id, created_at, updated_at
      FROM warehouses
    SQL

    drop_table :warehouses, force: :cascade
  end

  def down
    create_table :warehouses do |t|
      t.string :name
      t.string :username
      t.string :password
      t.boolean :show, default: true

      t.timestamps
    end

    execute <<-SQL
    INSERT INTO warehouses(id, name, username, password, show, created_at, updated_at)
      SELECT origin_id, first_name, username, password, show, created_at, updated_at
      FROM users u
      WHERE u.type = 'warehouses'
    SQL

    create_table :producers do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.boolean :show, default: true

      t.timestamps
    end

    execute <<-SQL
    INSERT INTO producers(id, first_name, last_name, username, password, show, created_at, updated_at)
      SELECT origin_id, first_name, last_name, username, password, show, created_at, updated_at
      FROM users u
      WHERE u.type = 'producers'
    SQL

    remove_index :users, :username
    remove_index :users, :email

    drop_table :users, force: :cascade
  end
end
