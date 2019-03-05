require 'spec_helper'

describe Spree::ProductsController do

  let!(:product) { FactoryBot.create(:product) }

  describe 'on :show to a product without any stores' do
    let!(:store) { FactoryBot.create(:store) }

    it 'should raise ActiveRecord::RecordNotFound' do
      # Skiping test for Spree version lower than 3.3
      # due to this commit
      # https://github.com/spree/spree/commit/acf52960f5b9582cdfe01f0cb563766b44aabbd5#diff-68c90f2736e3c896ad980e0cb654b41d
      skip if Spree.version.to_d < 3.3
      expect { spree_get :show, id: product.to_param }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  # Regression test for #75
  describe 'on :show to a product in the wrong store' do
    let!(:store_1) { FactoryBot.create(:store) }
    let!(:store_2) { FactoryBot.create(:store) }

    before(:each) do
      product.stores << store_1
    end

    it 'should raise ActiveRecord::RecordNotFound' do
      # Skiping test for Spree version lower than 3.3
      # due to this commit
      # https://github.com/spree/spree/commit/acf52960f5b9582cdfe01f0cb563766b44aabbd5#diff-68c90f2736e3c896ad980e0cb654b41d
      skip if Spree.version.to_d < 3.3
      controller.stub(current_store: store_2)
      expect { spree_get :show, id: product.to_param }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'on :show to a product w/ store' do
    let!(:store) { FactoryBot.create(:store) }

    before(:each) do
      product.stores << store
    end

    it 'should return 200' do
      controller.stub(current_store: store)
      spree_get :show, id: product.to_param

      expect(response.status).to eq 200
    end
  end

end
