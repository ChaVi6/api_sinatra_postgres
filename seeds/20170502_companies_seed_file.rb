Sequel.seed(:development, :test) do
  def run
    DB[:companies].insert(name: 'MoGo', location: 'New York')
    DB[:companies].insert(name: 'Wirkkle', location: 'London')
    DB[:companies].insert(name: 'Artesis', location: 'Saint-Petersburg')
    DB[:companies].insert(name: 'BuildEmpire', location: 'London')
  end
end