namespace '/api/v1' do
  get '/jobs' do
    jobs = Job
    [:place, :name].each do |filter|
      jobs = jobs.send(filter, params[filter]) if params[filter]
    end
    collection_to_api(jobs)
  end

  get '/jobs_company/:name' do
    company = Company.where(name: params[:name]).first
    halt(404, { message: 'Company Not Found', status: 404 }.to_json) unless company
    jobs = Job.where(company_id: company.id)
    halt(404, { message: 'Jobs Not Found', status: 404 }.to_json) unless jobs
    collection_to_api(jobs)
  end

  get '/job/:id' do
    job = Job.where(id: params[:id]).first
    halt(404, { message: 'Job Not Found', status: 404, params_id: params[:id] }.to_json) unless job
    job.values.to_json
  end

  post '/jobs' do
    begin
      payload = JSON.parse(request.body.read)
      job = Job.create(
        name: payload['name'],
        place: payload['place'],
        company_id: payload['company_id']
      )
      status 201
      job.to_api.to_json
    rescue Sequel::ValidationFailed => e
      status 422
      { errors: e.errors }.to_json
    rescue JSON::ParserError
      status 400
      { error: 'Invalid JSON' }.to_json
    end
  end

  put '/job/:id' do
    job = Job.where(id: params[:id]).first
    halt(404, { message: 'Job Not Found', status: 404 }.to_json) unless job

    payload = JSON.parse(request.body.read)
    job.update(name: payload['name'], place: payload['place'], company_id: payload['company_id'])
    job.to_api.to_json
  end

  delete '/job/:id' do
    job = Job.where(id: params[:id]).first
    halt(404, { message: 'Job Not Found', status: 404 }.to_json) unless job

    job.destroy
    { deleted_job: job.values, code: 200, status: 'success' }.to_json
  end
end