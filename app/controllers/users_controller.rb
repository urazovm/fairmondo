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
class UsersController < ApplicationController
  include NoticeHelper
  respond_to :html
  respond_to :js, if: lambda { request.xhr? }
  respond_to :pdf, only: :profile

  before_action :set_user
  before_action :check_for_complete_mass_uploads, only: [:show], if: -> { own? }
  before_action :dont_cache, only: [:show]
  before_action :sanitize_print_param, only: [:legal_info]
  skip_before_action :authenticate_user!,
    only: [:show, :contact, :active_articles, :profile, :ratings, :libraries,
           :legal_info]

  rescue_from Pundit::NotAuthorizedError, with: :user_deleted

  def show
    authorize @user
    if own?
      redirect_to dashboard_user_path(@user)
    else
      redirect_to active_articles_user_path(@user)
    end
  end

  def contact
    render layout: false
  end

  def dashboard
    authorize @user
    render :dashboard
  end

  def active_articles
    authorize @user
    @articles = set_active_articles.page(params[:active_articles_page]).per(12)
    render :articles
  end

  def inactive_articles
    authorize @user
    @articles = set_inactive_articles.page(params[:active_articles_page]).per(12)
    render :articles
  end

  def templates
    authorize @user
    @articles = set_templates.page(params[:active_articles_page]).per(12)
    render :articles
  end

  def legal_info
    authorize @user
    render :legal_info
  end

  def ratings
    authorize @user
    @ratings = @user.ratings.includes(rating_user: [:image]).page(params[:page]).per(20)
    render :ratings
  end

  def profile
    authorize @user
    render :profile
  end

  def libraries
    authorize @user
    @libraries = set_user_libraries.page(params[:page]).per(12)
    @library = @user.libraries.build
    render :libraries
  end

  def sales
    authorize @user
    @line_item_groups = set_sold_line_item_groups.page(params[:page]).per(12)
    render :line_item_groups
  end

  def purchases
    authorize @user
    @line_item_groups = set_bought_line_item_groups.page(params[:page]).per(12)
    render :line_item_groups
  end

  def mass_uploads
    authorize @user
    render :mass_uploads
  end

  def edit_profile
    authorize @user
    render :edit_profile
  end

  private

  def own?
    @user == current_user
  end

  def user_deleted
    render :user_deleted
  end

  def set_user
    @user = User.find(params[:id])
  end

  def check_for_complete_mass_uploads
    if user_signed_in?
      current_user.mass_uploads.processing.each do |mu|
        mu.finish
      end
    end
  end

  def sanitize_print_param
    if params[:print] && %w(terms cancellation).include?(params[:print])
      @print = params[:print]
    end
  end

  def set_active_articles
    if own?
      @user.articles
        .where('state = ?', :active)
        .includes(:title_image, :seller)
    else
      @articles = ActiveUserArticles.new(@user)
        .paginate(params[:active_articles_page])
    end
  end

  def set_inactive_articles
    @user.articles
      .where('state = ? OR state = ? OR state = ?', :preview, :locked, :inactive)
      .includes(:title_image, :seller)
  end

  def set_templates
    @articles = @user.article_templates
  end

  def set_bought_line_item_groups
    @user.buyer_line_item_groups
      .sold
      .includes(:seller, :rating, business_transactions: [article: [:seller, :title_image]])
      .order(updated_at: :desc)
  end

  def set_sold_line_item_groups
    @user.seller_line_item_groups
      .sold
      .includes(:buyer, :rating, business_transactions: [article: [:title_image]])
      .order(updated_at: :desc)
  end

  def set_user_libraries
    if own?
      @user.libraries
        .includes(:library_elements)
    else
      @user.libraries.where(public: true)
        .includes(:library_elements)
    end
  end
end
