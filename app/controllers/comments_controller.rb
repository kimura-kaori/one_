class CommentsController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    @contact = Contact.find(params[:contact_id])
    @comment = @contact.comments.build(comment_params)
    url = request.headers[:referer]
    respond_to do |format|
      #コメントの相手にメールが飛ぶ条件分岐をしたい
      if current_user.try(:admin?)
        @comment.save
        format.js { render :index }
        ReportMailer.alert_comment(current_user, url).deliver #投稿者が保護者なら学校へ
      elsif
        @comment.save
        format.js { render :index }
        ReportMailer.notice_comment(current_user, url).deliver #投稿者が学校なら保護者へ
      else
        format.html { redirect_to user_contact_path(@contact), notice: '投稿できませんでした...' }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content).merge(user_id: current_user.id)
  end
end
