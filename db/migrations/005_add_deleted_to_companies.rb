Sequel.migration do
  change do
    add_column :companies, :deleted, TrueClass, default: false
  end
end