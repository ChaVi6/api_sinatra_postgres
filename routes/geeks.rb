namespace '/api/v1' do
  get '/geeks' do
    collection_to_api(Geek.all)
  end

  post '/geeks' do
    payload = JSON.parse(request.body.read)
    geek = Geek.create(name: payload['name'], stack: payload['stack'], resume: payload['resume'] || false)
    status 201
    geek.to_api.to_json
  end

  put '/geek/:id' do
    geek = Geek.where(id: params[:id]).first
    halt(404, { message: 'Geek Not Found', status: 404 }.to_json) unless geek

    payload = JSON.parse(request.body.read)
    geek.update(name: payload['name'], stack: payload['stack'], resume: payload['resume'])
    geek.to_api.to_json
  end

  delete '/geek/:id' do
    geek = Geek.where(id: params[:id]).first
    halt(404, { message: 'Geek Not Found', status: 404 }.to_json) unless geek

    geek.destroy
    { deleted_geek: geek.values, code: 200, status: 'success' }.to_json
  end
end