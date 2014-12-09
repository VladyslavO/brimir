 # Brimir is a helpdesk system to handle email support requests.
# Copyright (C) 2012-2014 Ivaldi http://ivaldi.nl
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
class Api::V1::TicketsController < Api::V1::ApplicationController

  load_and_authorize_resource :ticket, except: :create
  skip_authorization_check only: :create

  def index
    @tickets = Ticket.by_status(:open).viewable_by(current_user)
  end

  def show
    @ticket = Ticket.find(params[:id])
  end

  def create
    @ticket = Ticket.new(:from => params[:from], :subject => params[:subject], :content => params[:content],
                         :content_type => params[:contentType])

    assignee = User.find_by_email("a.ladygin@crmtronic.com")
    @ticket.assignee = assignee unless assignee.nil?

    if @ticket.save
      Rule.apply_all(@ticket)

      # where user notifications added?
      if @ticket.notified_users.count == 0
        @ticket.set_default_notifications!(@ticket.user)
      end

      if @ticket.assignee.nil?
        NotificationMailer.new_ticket(@ticket).deliver
      else
        TicketMailer.notify_assigned(@ticket).deliver
      end

      render :json => {:message => "Ticket created successfully"}, :status => 200
    else
      render :json => {:ticketErrors => @ticket.errors.full_messages}, :status => 422
    end
  end
end