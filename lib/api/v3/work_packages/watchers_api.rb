#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

module API
  module V3
    module WorkPackages
      class WatchersAPI < ::API::OpenProjectAPI
        get '/available_watchers' do
          authorize(:add_work_package_watchers, context: @work_package.project)

          available_watchers = @work_package.possible_watcher_users
          total = available_watchers.count
          self_link = api_v3_paths.available_watchers(@work_package.id)

          ::API::V3::Users::UserCollectionRepresenter.new(available_watchers,
                                                          total,
                                                          self_link)
        end

        resources :watchers do
          helpers do
            def watchers_collection
              watchers = @work_package.watcher_users
              total = watchers.count
              self_link = api_v3_paths.work_package_watchers(@work_package.id)
              Users::UserCollectionRepresenter.new(watchers,
                                                   total,
                                                   self_link,
                                                   context: { current_user: current_user })
            end
          end

          get do
            authorize(:view_work_package_watchers, context: @work_package.project)

            watchers_collection
          end

          post do
            unless request_body
              fail ::API::Errors::InvalidRequestBody.new(I18n.t('api_v3.errors.missing_request_body'))
            end

            representer = ::API::V3::Watchers::WatcherRepresenter.new(::Hashie::Mash.new)
            representer.from_hash(request_body)
            user_id = representer.represented.user_id.to_i

            if current_user.id == user_id
              authorize(:view_work_packages, context: @work_package.project)
            else
              authorize(:add_work_package_watchers, context: @work_package.project)
            end

            user = User.find user_id

            Services::CreateWatcher.new(@work_package, user).run(
              success: -> (result) { status(200) unless result[:created] },
              failure: -> (watcher) {
                messages = watcher.errors.map do |attribute, message|
                  watcher.errors.full_message(attribute, message) + '.'
                end
                raise ::API::Errors::Validation.new(messages)
              }
            )

            ::API::V3::Users::UserRepresenter.new(user)
          end

          namespace ':user_id' do
            params do
              requires :user_id, desc: 'The watcher\'s user id', type: Integer
            end

            delete do
              if current_user.id == params[:user_id]
                authorize(:view_work_packages, context: @work_package.project)
              else
                authorize(:delete_work_package_watchers, context: @work_package.project)
              end

              user = User.find_by_id params[:user_id]

              raise ::API::Errors::NotFound unless user

              Services::RemoveWatcher.new(@work_package, user).run

              status 204
            end
          end
        end
      end
    end
  end
end
