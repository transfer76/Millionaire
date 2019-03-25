FactoryGirl.define do
  factory :users do
    name { "Жора_#{rand(999)}" }

    sequence(:email) { |n| "someguy_#{n}@exempl.com" }

    is_admin false
    balance 0

    after(:build) { |u| u.password_confirmation = u.password = "123456" }
  end
end

