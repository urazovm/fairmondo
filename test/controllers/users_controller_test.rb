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
        assert_redirected_to active_articles_user_path
      end

      it 'should render active_articles' do
        get :active_articles, id: @user.id
        assert_response :success
      end

      it 'should render libraries' do
        get :libraries, id: @user.id
        assert_response :success
      end

      it 'should render ratings' do
        get :ratings, id: @user.id
        assert_response :success
      end

      it 'should render profile' do
        get :profile, id: @user.id
        assert_response :success
      end

      it 'should render legal_info' do
        @user.update_attribute :type, 'LegalEntity'
        get :legal_info, id: @user.id
        assert_response :success
      end

      it 'should not render inactive_articles' do
        get :inactive_articles, id: @user.id
        assert_redirected_to new_user_session_path
      end

      it 'should not render dashboard' do
        get :dashboard, id: @user.id
        assert_redirected_to new_user_session_path
      end

      it 'should not render edit_profile' do
        get :edit_profile, id: @user.id
        assert_redirected_to new_user_session_path
      end

      it 'should not render mass_uploads' do
        get :mass_uploads, id: @user.id
        assert_redirected_to new_user_session_path
      end

      it 'should not render sales' do
        get :sales, id: @user.id
        assert_redirected_to new_user_session_path
      end

      it 'should not render purchases' do
        get :purchases, id: @user.id
        assert_redirected_to new_user_session_path
      end

      it 'should not render templates' do
        get :templates, id: @user.id
        assert_redirected_to new_user_session_path
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
        assert_redirected_to dashboard_user_path
      end

      it 'should render active_articles' do
        get :active_articles, id: @user.id
        assert_response :success
      end

      it 'should render libraries' do
        get :libraries, id: @user.id
        assert_response :success
      end

      it 'should render ratings' do
        get :ratings, id: @user.id
        assert_response :success
      end

      it 'should render profile' do
        get :profile, id: @user.id
        assert_response :success
      end

      it 'should render legal_info' do
        @user.update_attribute :type, 'LegalEntity'
        get :legal_info, id: @user.id
        assert_response :success
      end

      it 'should not render inactive_articles' do
        get :inactive_articles, id: @user.id
        assert_response :success
      end

      it 'should not render dashboard' do
        get :dashboard, id: @user.id
        assert_response :success
      end

      it 'should not render edit_profile' do
        get :edit_profile, id: @user.id
        assert_response :success
      end

      it 'should not render mass_uploads' do
        get :mass_uploads, id: @user.id
        assert_response :success
      end

      it 'should not render sales' do
        get :sales, id: @user.id
        assert_response :success
      end

      it 'should not render purchases' do
        get :purchases, id: @user.id
        assert_response :success
      end

      it 'should not render templates' do
        get :templates, id: @user.id
        assert_response :success
      end
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
