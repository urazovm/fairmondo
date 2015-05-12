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
module UsersHelper
  def user_resource
    @user
  end

  def active_articles
    if @user == current_user
      resource.articles.where('state = ?', :active).includes(:images, :seller).page(params[:active_articles_page])
    else
      @articles
    end
  end

  def inactive_articles
    resource.articles.where('state = ? OR state = ? OR state = ?', :preview, :locked, :inactive).includes(:images, :seller).page(params[:inactive_articles_page])
  end

  def bought_line_item_groups
    resource.buyer_line_item_groups.sold.includes(:seller, :rating, business_transactions: [article: [:seller, :images]]).order(updated_at: :desc).page(params[:buyer_line_item_groups_page])
  end

  def sold_line_item_groups
    resource.seller_line_item_groups.sold.includes(:buyer, :rating, business_transactions: [article: [:images]]).order(updated_at: :desc).page(params[:seller_line_item_groups_page])
  end

  def bank_account_line seller, attribute
    heading = content_tag(:div, class: 'heading') do
      "#{t("formtastic.labels.user.#{attribute}")}: "
    end
    value = content_tag(:div, class: 'value') do
      seller.send(attribute)
    end
    content_tag(:div, class: 'line') do
      safe_join([heading, value])
    end
  end

  def user_profile_partial_for params
    if in_policy_scope?
      send("render_#{ params['type'] }")
    elsif show_private_template?(params)
      send("render_#{ params['type'] }")
    elsif show_legal_template?(params)
      send("render_#{ params['type'] }")
    else
      render_active_articles
    end
  end

  def in_policy_scope?
    policy(@user).show_private_for_legal? || policy(@user).show_private_for_private?
  end

  def show_private_template?(params)
    !in_policy_scope? && @user.is_a?(PrivateUser) && public_private_profile_templates.include?(params['type'])
  end

  def show_legal_template?(params)
    !in_policy_scope? && @user.is_a?(LegalEntity) && public_legal_profile_templates.include?(params['type'])
  end

  def public_private_profile_templates
    %w(active_articles libraries ratings profile)
  end

  def public_legal_profile_templates
    public_private_profile_templates << 'legal_info'
  end

  def render_dashboard
    render 'users/show/dashboard',
      item_name: :dashboard
  end

  def render_sales
    render 'users/show/line_item_groups',
      line_item_groups: sold_line_item_groups,
      item_name: :seller_line_item_groups
  end

  def render_purchases
    render 'users/show/line_item_groups',
      line_item_groups: bought_line_item_groups,
      item_name: :buyer_line_item_groups
  end

  def render_active_articles
    render 'users/show/articles',
      articles: active_articles.page(params[:page]).per(20),
      item_name: :active_articles,
      item_link: new_article_path
  end

  def render_inactive_articles
    render 'users/show/articles',
      articles: inactive_articles.page(params[:page]).per(20),
      item_name: :inactive_articles,
      item_link: new_article_path
  end

  def render_templates
    render 'users/show/articles',
      articles: @user.article_templates.page(params[:page]).per(20),
      item_name: :templates
  end

  def render_ratings
    render 'users/show/ratings',
      item_name: :ratings,
      ratings: @user.ratings.includes(rating_user: [:image]).page(params[:page]).per(20)
  end

  def render_libraries
    render 'users/show/libraries',
      item_name: :libraries,
      libraries: @user.libraries.page(params[:page]).per(12),
      library: @user.libraries.build
  end

  def render_profile
    render 'users/show/profile',
      item_name: :profile
  end

  def render_edit_profile
    if @user == current_user
      render 'users/show/edit_profile',
        item_name: :edit_profile
    else
      render 'users/show/profile',
        item_name: :profile
    end
  end

  def render_mass_uploads
    render 'users/show/mass_uploads',
      item_name: :mass_uploads
  end

  def render_legal_info
    render 'users/show/legal_info',
      item_name: :legal_info
  end
end
