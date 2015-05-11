#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

describe UsersController do
  describe "GET 'show'" do
    describe 'for non-signed-in users' do
      before :each do
        @user = FactoryGirl.create(:user, type: 'PrivateUser')
      end

      it 'should be successful' do
        get :show, id: @user
        assert_response :success
      end

      it 'should render active_articles' do
        xhr :get, :show, id: @user.id, type: :active_articles
        assert_template partial: 'users/show/_articles', count: 1
      end

      it 'should render libraries' do
        xhr :get, :show, id: @user.id, type: :libraries
        assert_template partial: 'users/show/_libraries', count: 1
      end

      it 'should render ratings' do
        xhr :get, :show, id: @user.id, type: :ratings
        assert_template partial: 'users/show/_ratings', count: 1
      end

      it 'should render profile' do
        xhr :get, :show, id: @user.id, type: :profile
        assert_template partial: 'users/show/_profile', count: 1
      end

      it 'should render legal_info' do
        @user.update_attribute :type, 'LegalEntity'
        xhr :get, :show, id: @user.id, type: :legal_info
        assert_template partial: 'users/show/_legal_info', count: 1
      end

      it 'should not render inactive_articles' do
        xhr :get, :show, id: @user.id, type: :inactive_articles
        assert_template partial: 'users/show/_articles'
      end

      it 'should not render dashboard' do
        xhr :get, :show, id: @user.id, type: :dashboard
        assert_template partial: 'users/show/_dashboard', count: 0
        assert_template partial: 'users/show/_articles'
      end

      it 'should not render edit_profile' do
        xhr :get, :show, id: @user.id, type: :edit_profile
        assert_template partial: 'users/show/_edit_profile', count: 0
        assert_template partial: 'users/show/_articles'
      end

      it 'should not render mass_uploads' do
        xhr :get, :show, id: @user.id, type: :mass_uploads
        assert_template partial: 'users/show/_mass_uploads', count: 0
        assert_template partial: 'users/show/_articles'
      end

      it 'should not render sales' do
        xhr :get, :show, id: @user.id, type: :sales
        assert_template partial: 'users/show/_line_item_groups', count: 0
        assert_template partial: 'users/show/_articles'
      end

      it 'should not render purchases' do
        xhr :get, :show, id: @user.id, type: :purchases
        assert_template partial: 'users/show/_line_item_groups', count: 0
        assert_template partial: 'users/show/_articles'
      end

      it 'should render articles partial for templates' do
        xhr :get, :show, id: @user.id, type: :templates
        assert_template partial: 'users/show/_articles'
      end

      it 'render deleted user for banned users' do
        @user.update_attribute(:banned, true)
        get :show, id: @user
        assert_response :success
        assert_template :user_deleted
      end
    end

    describe 'for signed-in users' do
      before :each do
        @user = FactoryGirl.create(:user, type: 'PrivateUser')
        sign_in @user
      end

      it 'should be successful' do
        get :show, id: @user
        assert_response :success
      end

      it 'should render active_articles' do
        xhr :get, :show, id: @user.id, type: :active_articles
        assert_template partial: 'users/show/_articles', count: 1
      end

      it 'should render libraries' do
        xhr :get, :show, id: @user.id, type: :libraries
        assert_template partial: 'users/show/_libraries', count: 1
      end

      it 'should render ratings' do
        xhr :get, :show, id: @user.id, type: :ratings
        assert_template partial: 'users/show/_ratings', count: 1
      end

      it 'should render profile' do
        xhr :get, :show, id: @user.id, type: :profile
        assert_template partial: 'users/show/_profile', count: 1
      end

      it 'should render inactive_articles' do
        xhr :get, :show, id: @user.id, type: :inactive_articles
        assert_template partial: 'users/show/_articles'
      end

      it 'should render dashboard' do
        xhr :get, :show, id: @user.id, type: :dashboard
        assert_template partial: 'users/show/_dashboard', count: 1
      end

      it 'should render edit_profile' do
        xhr :get, :show, id: @user.id, type: :edit_profile
        assert_template partial: 'users/show/_edit_profile', count: 1
      end

      it 'should render sales' do
        xhr :get, :show, id: @user.id, type: :sales
        assert_template partial: 'users/show/_line_item_groups', count: 1
      end

      it 'should render purchases' do
        xhr :get, :show, id: @user.id, type: :purchases
        assert_template partial: 'users/show/_line_item_groups', count: 1
      end

      it 'should render templates (articles)' do
        xhr :get, :show, id: @user.id, type: :templates
        assert_template partial: 'users/show/_articles', count: 1
      end

      it 'should render mass_uploads' do
        @user.update_column :type, 'LegalEntity'
        xhr :get, :show, id: @user.id, type: :mass_uploads
        assert_template partial: 'users/show/_mass_uploads', count: 1
      end

      it 'should render legal_info' do
        @user.update_column :type, 'LegalEntity'
        xhr :get, :show, id: @user.id, type: :legal_info
        assert_template partial: 'users/show/_legal_info', count: 1
      end
    end
  end

  describe "GET 'profile'" do
    before :each do
      @user = FactoryGirl.create(:legal_entity)
    end

    it 'should be successful' do
      get :profile, id: @user, format: :pdf, print: 'terms'
      assert_response :success
    end
  end

  describe 'GET contact' do
    let(:user) { FactoryGirl.create :user }

    it 'should be successful' do
      xhr :get, :contact, id: user.id
      assert_response :success
      assert_template :contact
    end
  end
end
