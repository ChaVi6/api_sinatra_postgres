Sequel.seed(:development, :test) do
  def run
    DB[:jobs].insert(name: 'Sinatra React', place: 'Remote', company_id: 1)
    DB[:jobs].insert(name: 'Ruby React', place: 'Contract', company_id: 2)
    DB[:jobs].insert(name: 'React', place: 'Remote', company_id: 3)
  end
end