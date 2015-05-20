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

  def item_name
    params[:action].to_sym
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

  def own_legal_profile_templates
    [:dashboard, :sales, :purchases, :active_articles, :inactive_articles, :templates,
    :mass_uploads, :libraries, :ratings, :legal_info, :profile, :edit_profile]
  end

  def own_private_profile_templates
    [:dashboard, :sales, :purchases, :active_articles, :inactive_articles, :templates,
     :libraries, :ratings, :profile, :edit_profile]
  end

  def public_private_profile_templates
    [:active_articles, :libraries, :ratings, :profile]
  end

  def public_legal_profile_templates
    public_private_profile_templates << :legal_info
  end

  def navpoints_other
    @user.is_a?(LegalEntity) ? public_legal_profile_templates : public_private_profile_templates
  end

  def navpoints_own
    @user.is_a?(LegalEntity) ? own_legal_profile_templates : own_private_profile_templates
  end
end
