Sequel.seed(:development, :test) do
  def run
    DB[:applies].insert(job_id: 1, geek_id: 1, read: true, invited: false)
    DB[:applies].insert(job_id: 2, geek_id: 2, read: false, invited: true)
  end
end