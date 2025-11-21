# db/migrate/XXXXXX_create_initial_financial_structure.rb

class CreateInitialFinancialStructure < ActiveRecord::Migration[7.1]
  def change
    # ==============================================
    # TABLA: Person (Renombrada a 'users' por convención)
    # ==============================================
    create_table :users do |t|
      t.string :name, null: false, limit: 150
      t.string :email, null: false, limit: 150, index: { unique: true }
      t.string :password_hash, null: false, limit: 500

      # Auditoría y Borrado Lógico
      t.string :created_by, limit: 150
      t.string :updated_by, limit: 150
      t.boolean :is_deleted, null: false, default: false

      t.timestamps # Crea created_at y updated_at
    end

    # ==============================================
    # TABLA: Rol (Renombrada a 'roles')
    # ==============================================
    create_table :roles do |t|
      t.string :name, null: false, limit: 100

      # Auditoría y Borrado Lógico
      t.string :created_by, limit: 150
      t.string :updated_by, limit: 150
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end

    # ==============================================
    # TABLA: Permission (Renombrada a 'permissions')
    # ==============================================
    create_table :permissions do |t|
      t.string :name, null: false, limit: 150

      # Auditoría y Borrado Lógico
      t.string :created_by, limit: 150
      t.string :updated_by, limit: 150
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end

    # ==============================================
    # TABLA: Entity (Renombrada a 'entities')
    # ==============================================
    create_table :entities do |t|
      t.string :name, null: false, limit: 150

      # Auditoría y Borrado Lógico
      t.string :created_by, limit: 150
      t.string :updated_by, limit: 150
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end

    # ==============================================
    # TABLA: AccountType (Renombrada a 'account_types')
    # ==============================================
    create_table :account_types do |t|
      t.string :name, null: false, limit: 100

      # Auditoría y Borrado Lógico
      t.string :created_by, limit: 150
      t.string :updated_by, limit: 150
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end

    # ==============================================
    # TABLA: Currency (Renombrada a 'currencies')
    # ==============================================
    create_table :currencies do |t|
      t.string :name, null: false, limit: 50

      # Auditoría y Borrado Lógico
      t.string :created_by, limit: 150
      t.string :updated_by, limit: 150
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end

    # ==============================================
    # TABLA: Status (Renombrada a 'statuses')
    # ==============================================
    create_table :statuses do |t|
      t.string :name, null: false, limit: 50

      # Auditoría y Borrado Lógico
      t.string :created_by, limit: 150
      t.string :updated_by, limit: 150
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end

    # ==============================================
    # TABLA: Account
    # ==============================================
    create_table :accounts do |t|
      t.string :name, null: false, limit: 150

      # Claves Foráneas
      t.references :user, null: false, foreign_key: true # FK_Account_Person (PersonId)
      t.references :entity, null: false, foreign_key: true # FK_Account_Entity
      t.references :account_type, null: false, foreign_key: true # FK_Account_AccountType
      t.references :currency, null: false, foreign_key: true # FK_Account_Currency (CurrencyTypeId)
      t.references :status, null: false, foreign_key: true # FK_Account_Status

      # Auditoría y Borrado Lógico
      t.string :created_by, limit: 150
      t.string :updated_by, limit: 150
      t.boolean :is_deleted, null: false, default: false

      t.timestamps
    end

    # ==============================================
    # TABLA: AccountFeature
    # ==============================================
    create_table :account_features do |t|
      t.references :account_type, null: false, foreign_key: true # FK_AccountFeature_AccountType
      t.decimal :value, precision: 18, scale: 4, null: false
      t.decimal :dimension, precision: 18, scale: 4 # Nullable

      t.timestamps # Crea created_at
    end

    # ==============================================
    # TABLA: PersonRol (N:N)
    # ==============================================
    create_join_table :users, :roles do |t|
      t.index [ :user_id, :role_id ], unique: true
      t.timestamps
    end
    # Nota: Rails crea las claves foráneas por defecto en create_join_table

    # ==============================================
    # TABLA: RolePermission (N:N)
    # ==============================================
    create_join_table :roles, :permissions do |t|
      t.index [ :role_id, :permission_id ], unique: true
      t.timestamps
    end
  end
end
