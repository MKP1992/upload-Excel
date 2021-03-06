class UsersImportsController < ApplicationController

  def new
    @users_import = UsersImport.new
  end

  def create
    if params[:users_import]
    begin
      users_import = UsersImport.new(params[:users_import])
      @result = users_import.save
      flash[:notice] = render_to_string( :partial => "notice")
      redirect_to users_imports_new_path
    rescue => e
      redirect_to users_imports_new_path, alert: "#{e.message}"
    end
    else
      redirect_to users_imports_new_path, alert: "Please import execl sheet!"
    end
  end
end