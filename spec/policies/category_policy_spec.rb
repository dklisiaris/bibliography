require 'spec_helper'

describe CategoryPolicy do

  let(:user) { User.new }

  subject { CategoryPolicy }

  permissions ".scope" do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
