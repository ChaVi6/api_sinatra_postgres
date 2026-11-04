namespace '/api/v1' do
  get '/applies' do
    collection_to_api(Apply.all)
  end

  get '/applies_read' do
    collection_to_api(Apply.read)
  end

  get '/applies_unread' do
    collection_to_api(Apply.unread)
  end

  post '/applies' do
    begin
      payload = JSON.parse(request.body.read)
      apply = Apply.create(
        job_id: payload['job_id'],
        geek_id: payload['geek_id'],
        read: payload['read'] || false,
        invited: payload['invited'] || false
      )
      status 201
      apply.to_api.to_json
    rescue Sequel::ValidationFailed => e
      status 422
      { errors: e.errors }.to_json
    rescue JSON::ParserError
      status 400
      { error: 'Invalid JSON' }.to_json
    end
  end

  put '/apply/:id' do
    apply = Apply.where(id: params[:id]).first
    halt(404, { message: 'Apply Not Found', status: 404 }.to_json) unless apply

    begin
      payload = JSON.parse(request.body.read)
      apply.update(
        read: payload.key?('read') ? payload['read'] : apply.read,
        invited: payload.key?('invited') ? payload['invited'] : apply.invited
      )
      apply.to_api.to_json
    rescue Sequel::ValidationFailed => e
      status 422
      { errors: e.errors }.to_json
    rescue JSON::ParserError
      status 400
      { error: 'Invalid JSON' }.to_json
    end
  end

  delete '/apply/:id' do
    apply = Apply.where(id: params[:id]).first
    halt(404, { message: 'Apply Not Found', status: 404 }.to_json) unless apply

    apply.destroy
    { deleted_apply: apply.values, code: 200, status: 'success' }.to_json
  end
end