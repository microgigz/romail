class UsersController < ApplicationController
  
  def login
    @domain = Domain.find_by_status(true)
    $uname = nil
    if params[:users].nil?
    else
      $uname = params[:users][:username]
      $pass = params[:users][:password]
      if($uname == "" && $pass == "")
        $error_msg = "Username and Password missing!"
      elsif($uname == "")
        $error_msg = "Username missing!"
        $pass = nil
        $uname = nil
        redirect_to :controller => :users, :action => :login
      elsif($pass == "")
        $uname = nil
        $pass = nil
        $error_msg = "Password missing!"
        redirect_to :controller => :users, :action => :login
      else
        $domain = $uname.split("@")
        $username = $domain[0]
        $name = $username.split('.')
        $domain_name = "mail."+$domain[1]

        if Domain.find_by_imap_server($domain_name)
          domain = Domain.find_by_imap_server($domain_name)
          if domain.status == true
            require 'net/imap'
            require 'net/http'
            begin
              $imap = Net::IMAP.new("#{$domain_name}")
              $check = $imap.authenticate('LOGIN', $uname, $pass)
              redirect_to :action => :index, :controller => :messages, :folder => "INBOX"
            rescue
              $error_msg = "Invalid Username or Password!"
              redirect_to :action => :login, :controller => :users
            end
          else
            $error_msg = "In-active Domain!"
            redirect_to :action => :login, :controller => :users
          end
          
        else
          $error_msg = "Invalid Domain!"
          redirect_to :action => :login, :controller => :users
        end
        
      end
    end
  end

  def logout
    begin
      $imap.expunge
      $imap.logout
      $imap.disconnect
      $uname = nil
      $pass = nil
      redirect_to :action => 'login'
    rescue
      redirect_to :action => 'login'
    end
    
  end
  
end