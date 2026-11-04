namespace '/api/v1' do
  get '/companies' do
    companies = Company.active
    return collection_to_api(companies) if params.empty?

    if params['name']
      companies_all = companies.by_name(params['name'])
      companies = params['location'] ? companies_all.by_location(params['location']) : companies_all
    elsif params['location']
      companies = companies.by_location(params['location'])
    end
    collection_to_api(companies)
  end

  get '/company/:id' do
    company = Company.where(id: params[:id], deleted: false).first
    halt(404, { message: 'Company Not Found', status: 404 }.to_json) unless company
    company.to_api.to_json
  end

  post '/companies' do
    begin
      payload = JSON.parse(request.body.read)
      company = Company.create(name: payload['name'], location: payload['location'])
      status 201
      company.to_api.to_json
    rescue Sequel::ValidationFailed => e
      status 422
      { errors: e.errors }.to_json
    rescue JSON::ParserError
      status 400
      { error: 'Invalid JSON' }.to_json
    end
  end

  put '/company/:id' do
    company = Company.where(id: params[:id], deleted: false).first
    halt(404, { message: 'Company Not Found', status: 404 }.to_json) unless company

    begin
      payload = JSON.parse(request.body.read)
      company.update(name: payload['name'], location: payload['location'])
      company.to_api.to_json
    rescue Sequel::ValidationFailed => e
      status 422
      { errors: e.errors }.to_json
    rescue JSON::ParserError
      status 400
      { error: 'Invalid JSON' }.to_json
    end
  end

  put '/companies/:id/mark_deleted' do
    company = Company.where(id: params[:id]).first
    halt(404, { message: 'Company Not Found', status: 404 }.to_json) unless company

    if company.deleted
      status 304
      { message: 'Already deleted' }.to_json
    else
      company.delete_company
      { deleted_company: company.to_api, code: 200, status: 'success' }.to_json
    end
  end
end