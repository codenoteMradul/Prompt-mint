class MessagesController < ApplicationController
  before_action :require_login

  def index
    messages = Message
               .where(sender_id: current_user.id)
               .or(Message.where(recipient_id: current_user.id))
               .includes(:sender, :recipient)
               .order(created_at: :desc)

    @conversations = {}
    messages.each do |message|
      other = message.sender_id == current_user.id ? message.recipient : message.sender
      @conversations[other] ||= message
    end
  end

  def show
    @other_user = User.find(params[:user_id])

    @messages = Message
                .between(current_user.id, @other_user.id)
                .includes(:sender, :recipient)
                .order(:created_at)

    Message.where(sender_id: @other_user.id, recipient_id: current_user.id, read_at: nil).update_all(read_at: Time.current)

    @message = Message.new
  end

  def create
    other_user = User.find(params[:user_id])

    message = current_user.messages_sent.new(recipient: other_user, body: message_params[:body].to_s.strip)

    respond_to do |format|
      if message.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "message_form",
            partial: "messages/form",
            locals: { message: Message.new, other_user: other_user }
          )
        end
        format.html { redirect_to conversation_path(other_user), notice: "Message sent." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "message_form",
            partial: "messages/form",
            locals: { message:, other_user: other_user }
          ), status: :unprocessable_entity
        end
        format.html { redirect_to conversation_path(other_user), alert: message.errors.full_messages.to_sentence }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
