class MemberSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def login
    if params[:login_as] and logged_in? and current_user.admin?
      @member_session = MemberSession.new(Member.find(params[:login_as]), true)
    else
      @member_session = MemberSession.new(params[:member_session])
    end

    if @member_session.save
      flash[:notice] = "Login successful!"
      return redirect_back_or_default(root_path)
    else
      if params[:member_session]
        flash[:error] = "Wrong username or password!"
      elsif params[:login_as]
        flash[:error] = "Insufficient privileges to login as another user"
      end
    end
  end

  def logout
    if current_user_session
      current_user_session.destroy
      flash[:notice] = "Logout successful!"
    else
      flash[:notice] = "You are not logged in!"
    end
    redirect_to(root_path)
  end
end
