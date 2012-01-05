class AdminController < ApplicationController

  before_filter :login_required, :except => [:login]
 
  def login_required
    
    if !session[:admin_user]
      flash[:notice] = "Please login!"
      redirect_to :controller => :admin,:action => :login
      return false
    end
    
  end

  # Home action, used to make value of $edit_domain and $admin_edit_profile as nil

  def home
    
    $edit_domain = nil
    respond_to do |format|
      format.html {redirect_to :controller => :admin, :action => :index}
      format.xml {render :xml => @admin}
    end
    
  end


  # index action

  def index
    
    @admin = Admin.find_by_username(session[:admin_user])
    @domains = Domain.paginate(:page => params[:page], :per_page => 7).order('id DESC')
    respond_to do |format|
      format.html #index.html.haml
      format.xml{render :xml => @admin}
    end

  end

  # User login action

  def login

    if params[:admin].nil?
      respond_to do |format|
        format.html { render :layout => 'admin_login'} #login.html.haml
        format.xml { render :xml => @admin}
      end
    else
      admin_user = Admin.find_by_username_and_password(params[:admin][:username], params[:admin][:password])

      if !admin_user.nil?
        session[:admin_user] = params[:admin][:username]
        redirect_to :controller => :admin, :action => :index
      else
        flash[:notice] = "Username or Password invalid!"
        redirect_to :controller => :admin, :action => :login
      end
      
    end

  end

  # Add domain action, Adds new domain to the database

  def add_domain
    
    if !params[:add_domain][:domain_name].empty? && !params[:add_domain][:imap_server].empty?
    if !Domain.find_by_domain_name_and_imap_server(params[:add_domain][:domain_name], params[:add_domain][:imap_server])
      domain = Domain.new(params[:add_domain])
#      domain.domain_name = params[:add_domain][:domain_name]
#      domain.imap_server = params[:add_domain][:imap_server]
#      domain.company_name = params[:add_domain][:company_name]
#      domain.avatar = params[:add_domain][:avatar]
#      domain.status = params[:add_domain][:status]
      domain.save
      redirect_to :controller => :admin, :action => :index
    else
      redirect_to :controller => :admin, :action => :index
    end
    else
      flash[:notice] = "domain error"
      redirect_to :controller => :admin, :action  => :profile
    end
    
  end

  def edit_domain
    if params[:edit_domain].nil?
      $edit_domain = Domain.find(params[:id])
      redirect_to :controller => :admin, :action => :index
    else
      domain = Domain.find($edit_domain[:id])
      $edit_domain = nil
      domain.update_attributes(params[:edit_domain])      
      redirect_to :controller => :admin, :action => :index
    end
  end

  def active_inactive
    domain = Domain.find(params[:id])
    if domain.status == false
      domain.update_attribute('status', true)
    else
      domain.update_attribute('status', false)
      domain.save
    end
    redirect_to :controller => :admin, :action => :index
  end

  def delete_domain
    domain = Domain.find(params[:id])
    domain.destroy
    redirect_to :controller => :admin, :action => :index
  end

  def profile
    @admin = Admin.find_by_username(session[:admin_user])
    respond_to do |format|
      format.html #profile.html.erb
      format.xml{render :xml => @admin}
    end
  end

  def view_profile
    $admin_edit_profile = nil
    respond_to do |format|
      format.html {redirect_to :controller => :admin, :action => :profile} #profile.html.haml
      format.xml{render :xml => @admin}
    end
  end

  def update_profile
    
    if params[:edit_profile].nil?
      $admin_edit_profile = Admin.find_by_username(session[:admin_user])
      respond_to do |format|
        format.html {redirect_to :controller => :admin, :action => :profile} #profile.html.haml        
        format.xml{render :xml => @admin}
      end
    else
      admin = Admin.find_by_username(session[:admin_user])
      repond_to do |format|
        admin.update_attributes(params[:edit_profile])
        $admin_edit_profile = nil
        format.html {redirect_to :action => :profile} #profile.html.haml
        format.xml{render :xml => @admin}
      end
    end
    
  end

  def reset_password

    if params[:reset_password].nil?
    else
      current_password = params[:reset_password][:current_password]
      new_password = params[:reset_password][:new_password]
      confirm_password = params[:reset_password][:confirm_password]
      admin = Admin.find_by_username(session[:admin_user])
      if admin.password == current_password
        if new_password != current_password
          if new_password == confirm_password
            admin.update_attribute('password', new_password)
            $admin_edit_profile = nil
            redirect_to :controller => :admin, :action => :profile
          else
            flash[:notice] = "New password mismatch!"
          end
        else
          flash[:notice] = "New password and current password are same!"
        end
      else
        flash[:notice] = "password mismatch!"
      end
    end
    
  end

  def destroy
    session[:admin_user] = nil
    reset_session
    flash[:notice] = "Logged out successfully!"
    respond_to do |format|
      format.html {redirect_to :controller => :admin, :action => :login} #login.html.haml
      format.xml {render :xml => @admin}
    end
    
  end
  
end