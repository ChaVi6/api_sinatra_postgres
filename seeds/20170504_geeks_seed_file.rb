Sequel.seed(:development, :test) do
  def run
    DB[:geeks].insert(name: 'Mike', stack: 'Ruby, JS', resume: true)
    DB[:geeks].insert(name: 'John', stack: 'Python', resume: false)
  end
end