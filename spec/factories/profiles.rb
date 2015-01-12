FactoryGirl.define do
  factory :profile do
    username "MyString"
name "MyString"
avatar "MyString"
about_me "MyText"
about_library "MyText"
account_type 1
privacy 1
language 1
allow_comments false
allow_friends false
email_privacy 1
discoverable_by_email false
receive_newsletters false
user nil
  end

end
