FactoryBot.define do
  factory :jwt_allowlist do
    jti { "MyString" }
    exp { "2024-05-02 09:41:10" }
  end
end
