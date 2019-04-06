require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  context 'user own page' do
    before(:each) do
      user = FactoryGirl.create(:user, name: 'Good Programmer')
      sign_in user
      assign(:user, user)

      assign(:games, [FactoryGirl.build_stubbed(:game, id: 1, created_at: Time.now, current_level: 2)])

      render
    end

    it 'render player name' do
      expect(rendered).to match('Good Programmer')
    end

    it 'render link change password' do
      expect(rendered).to match("Сменить имя и пароль")
    end

    it 'render game show page' do
      stub_template 'users/show.html.erb' => 'User game goes here'
      render

      expect(rendered).to have_content 'User game goes here'
    end
  end

end