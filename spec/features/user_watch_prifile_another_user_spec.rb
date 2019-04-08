require 'rails_helper'

RSpec.feature 'USER watch profile of another user', type: :feature do
  let(:user1) { FactoryGirl.create :user, name: 'Петя' }
  let(:user2) { FactoryGirl.create :user, name: 'Вася' }

  let!(:game) do [
        FactoryGirl.create(
            :game, id: 15, user: user2, created_at: Time.parse('2019.04.08, 09:00'), current_level: 2, prize: 1000),
        FactoryGirl.create(
            :game, id: 20, user: user2, created_at: Time.parse('2019.04.08, 10:00'), current_level: 10, prize: 30000)
    ]
  end

  before(:each) do
    login_as user1
  end


  scenario 'successfully' do
    visit '/'

    click_link 'Вася'

    expect(page).to have_current_path('/users/2')
    expect(page).not_to have_content('Сменить имя и пароль')

    expect(page).to have_content('15')
    expect(page).to have_content('Вася')
    expect(page).to have_content('08 апреля, 09.00')
    expect(page).to have_content('2')
    expect(page).to have_content('1 000 ₽')

    expect(page).to have_content('20')
    expect(page).to have_content('Вася')
    expect(page).to have_content('08 апреля, 10.00')
    expect(page).to have_content('10')
    expect(page).to have_content('30 000 ₽')
  end
end
