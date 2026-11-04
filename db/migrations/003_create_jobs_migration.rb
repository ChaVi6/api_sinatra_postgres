Sequel.migration do
  change do
    create_table(:jobs, :ignore_index_errors=>true) do
      primary_key :id
      String :name, :text=>true, :null => false
      String :place, :text=>true
      foreign_key :company_id, :companies
      DateTime :created_at
      DateTime :updated_at

      index :id
    end
  end
end