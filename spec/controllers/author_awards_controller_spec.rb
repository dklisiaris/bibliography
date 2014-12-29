require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe AuthorAwardsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # AuthorAward. As you add validations to AuthorAward, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AuthorAwardsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all author_awards as @author_awards" do
      author_award = AuthorAward.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:author_awards)).to eq([author_award])
    end
  end

  describe "GET show" do
    it "assigns the requested author_award as @author_award" do
      author_award = AuthorAward.create! valid_attributes
      get :show, {:id => author_award.to_param}, valid_session
      expect(assigns(:author_award)).to eq(author_award)
    end
  end

  describe "GET new" do
    it "assigns a new author_award as @author_award" do
      get :new, {}, valid_session
      expect(assigns(:author_award)).to be_a_new(AuthorAward)
    end
  end

  describe "GET edit" do
    it "assigns the requested author_award as @author_award" do
      author_award = AuthorAward.create! valid_attributes
      get :edit, {:id => author_award.to_param}, valid_session
      expect(assigns(:author_award)).to eq(author_award)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AuthorAward" do
        expect {
          post :create, {:author_award => valid_attributes}, valid_session
        }.to change(AuthorAward, :count).by(1)
      end

      it "assigns a newly created author_award as @author_award" do
        post :create, {:author_award => valid_attributes}, valid_session
        expect(assigns(:author_award)).to be_a(AuthorAward)
        expect(assigns(:author_award)).to be_persisted
      end

      it "redirects to the created author_award" do
        post :create, {:author_award => valid_attributes}, valid_session
        expect(response).to redirect_to(AuthorAward.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved author_award as @author_award" do
        post :create, {:author_award => invalid_attributes}, valid_session
        expect(assigns(:author_award)).to be_a_new(AuthorAward)
      end

      it "re-renders the 'new' template" do
        post :create, {:author_award => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested author_award" do
        author_award = AuthorAward.create! valid_attributes
        put :update, {:id => author_award.to_param, :author_award => new_attributes}, valid_session
        author_award.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested author_award as @author_award" do
        author_award = AuthorAward.create! valid_attributes
        put :update, {:id => author_award.to_param, :author_award => valid_attributes}, valid_session
        expect(assigns(:author_award)).to eq(author_award)
      end

      it "redirects to the author_award" do
        author_award = AuthorAward.create! valid_attributes
        put :update, {:id => author_award.to_param, :author_award => valid_attributes}, valid_session
        expect(response).to redirect_to(author_award)
      end
    end

    describe "with invalid params" do
      it "assigns the author_award as @author_award" do
        author_award = AuthorAward.create! valid_attributes
        put :update, {:id => author_award.to_param, :author_award => invalid_attributes}, valid_session
        expect(assigns(:author_award)).to eq(author_award)
      end

      it "re-renders the 'edit' template" do
        author_award = AuthorAward.create! valid_attributes
        put :update, {:id => author_award.to_param, :author_award => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested author_award" do
      author_award = AuthorAward.create! valid_attributes
      expect {
        delete :destroy, {:id => author_award.to_param}, valid_session
      }.to change(AuthorAward, :count).by(-1)
    end

    it "redirects to the author_awards list" do
      author_award = AuthorAward.create! valid_attributes
      delete :destroy, {:id => author_award.to_param}, valid_session
      expect(response).to redirect_to(author_awards_url)
    end
  end

end
