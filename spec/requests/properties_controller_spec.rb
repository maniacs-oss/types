require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature 'PropertiesController' do

  let!(:application)  { FactoryGirl.create :application }
  let!(:user)         { FactoryGirl.create :user }
  let!(:access_token) { FactoryGirl.create :access_token, application: application, scopes: 'resources', resource_owner_id: user.id }

  before { page.driver.header 'Authorization', "Bearer #{access_token.token}" }
  before { page.driver.header 'Content-Type', 'application/json' }

  let(:controller) { 'properties' }
  let(:factory)    { 'property' }

  describe 'GET /properties' do

    let!(:resource)  { FactoryGirl.create :property, resource_owner_id: user.id }
    let(:uri)        { '/properties' }

    it_behaves_like 'a listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }
  end

  context 'GET /properties/public' do

    let!(:resource)  { FactoryGirl.create :property, resource_owner_id: user.id }
    let(:uri)        { '/properties/public' }

    it_behaves_like 'a public listable resource'
    it_behaves_like 'a paginable resource'
    it_behaves_like 'a searchable resource', { name: 'My name is resource' }
  end

  context 'GET /properties/:id' do

    let!(:resource)  { FactoryGirl.create :property, resource_owner_id: user.id }
    let(:uri)        { "/properties/#{resource.id}" }

    context 'when shows a propery with type=range' do
      let!(:resource) { FactoryGirl.create :intensity, resource_owner_id: user.id }

      before { page.driver.get uri }
      it     { has_resource resource }
    end

    it_behaves_like 'a showable resource'
    it_behaves_like 'a proxiable resource'
    it_behaves_like 'a crossable resource'
    it_behaves_like 'a not found resource', 'page.driver.get(uri)'
    it_behaves_like 'a public resource', 'page.driver.get(uri)'
  end

  context 'POST /properties' do

    let(:uri)      { '/properties' }
    let(:params)   { { name: 'Status' } }
    before         { page.driver.post uri, params.to_json }
    let(:resource) { Property.last }

    it_behaves_like 'a creatable resource'
    it_behaves_like 'a validated resource', 'page.driver.post(uri, {}.to_json)', { method: 'POST', error: 'can\'t be blank' }
  end

  context 'PUT /properties/:id' do

    let!(:resource) { FactoryGirl.create :property, resource_owner_id: user.id }
    let(:uri)       { "/properties/#{resource.id}" }
    let(:params)    { {name: 'Updated' } }

    it_behaves_like 'an updatable resource'
    it_behaves_like 'a not owned resource', 'page.driver.put(uri)'
    it_behaves_like 'a not found resource',  'page.driver.put(uri)'
    it_behaves_like 'a validated resource',  'page.driver.put(uri, {name: ""}.to_json)', { method: 'PUT', error: 'can\'t be blank' }
  end

  context 'DELETE /properties/:id' do
    let!(:resource)  { FactoryGirl.create :property, resource_owner_id: user.id }
    let(:uri)        { "/properties/#{resource.id}" }

    it_behaves_like 'a deletable resource'
    it_behaves_like 'a not owned resource', 'page.driver.put(uri)'
    it_behaves_like 'a not found resource', 'page.driver.delete(uri)'
  end
end
