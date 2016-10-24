#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

set :stage, :staging

server '78.109.61.137', user: 'deploy', roles: %w{web app db console}

set :branch, ENV['BRANCH_NAME'] || 'develop'
