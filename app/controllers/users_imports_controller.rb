class UsersImportsController < ApplicationController

  def new
    @users_import = UsersImport.new
  end

  def create
    if params[:users_import]
      users_import = UsersImport.new(params[:users_import])
      @result = users_import.save
      flash[:notice] = render_to_string( :partial => "notice")
      redirect_to users_imports_new_path
    else
      redirect_to users_imports_new_path, alert: "Please import execl sheet!"
    end
  end
end