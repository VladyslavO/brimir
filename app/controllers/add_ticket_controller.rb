class Api::V1::AddTicketController < ActionController::Base

  load_and_authorize_resource :ticket

  helper_method :current_user

  def index
    render json: {msg: "hello there"}, status: 200
  end

  def add
    #email, subject, text

    user_token = params[:authorization_token].presence
    user = user_token && User.where(authentication_token: user_token.to_s).first

    ticket = Ticket.new(user_id: user.id, subject: params[:subject], content: params[:text])
    result = ticket.save ? "1" : "0"

    render json: {success: result}, status: 200
  end
end
