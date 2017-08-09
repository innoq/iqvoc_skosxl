# encoding: UTF-8

# Copyright 2011-2013 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class XlDashboardController < DashboardController

  def label_index
    authorize! :use, :dashboard

    labels = Iqvoc::XLLabel.base_class.for_dashboard.load

    if params[:sort] && params[:sort].include?('state ')
      sort = params[:sort].split(',').select { |s| s.include? 'state ' }.last.gsub('state ', '')
      labels = labels.to_a.sort_by { |c| c.state }
      labels = sort == 'DESC' ? labels.reverse : labels
    elsif params[:sort]
      #FIXME: how to order by state in database?
      order_params = sanatize_order params[:sort]
      order_params = order_params.gsub('locking_user', 'users.surname')

      labels = labels.includes(:locking_user).references(:locking_user).order(order_params)
    end

    @items = Kaminari.paginate_array(labels).page(params[:page])

    render 'dashboard/index', locals: { active_class: Iqvoc::XLLabel.base_class }
  end

end
