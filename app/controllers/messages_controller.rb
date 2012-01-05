class MessagesController < ApplicationController

  before_filter :login_required, :except => [:login]
  uses_tiny_mce

  def login_required
    if $uname == "" || $uname == nil
      $error_msg = "Please login first!"
      redirect_to :controller => :users, :action => :login
    end
  end


  def index

    begin
      @folder_name = params[:folder]
      $imap.examine("#{@folder_name}")
      @envelope = $imap.search(["ALL"]).each do |message_id|
        messag = $imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
        logger.info "******************#{messag}**************************"
      end
      logger.info "*****************#{@envelope}***********************"
      @arr = @envelope.paginate(:per_page=>5, :page=>1)
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @message }
      end
    rescue
      redirect_to :controller => :users, :action => :login
    end

  end

  # Save email to drafts using IMAP

  def savedraft
    redirect_to :controller => :messages, :action => :index, :folder => 'INBOX'
  end

  # Sends email using SMTP

  def email_sent
    MyMailer::deliver_mail(params[:compose][:to])
  end

  # Compose new email

  def new
    
    begin

      if params[:compose].nil?
        respond_to do |format|
          format.html # new.html.erb
          format.xml  { render :xml => @message }
        end
      else
        require 'net/smtp'

        logger.info "********************************"
        logger.debug "else"
        logger.info "********************************"

        @recipient = params[:compose][:to]
        @sender = $uname
        @subject = params[:compose][:subject]
        @mesg = params[:compose][:message]

        @mail_msg = "To : #{@recipient}, From : #{@sender}, Subject : #{@subject}, Message : #{@mesg}"

        @smtp = Net::SMTP.start("#{$domain_name}", 25) do |smtp|
          logger.info "********************************"
          logger.debug $domain_name
          logger.info "********************************"
        end
      end
    end

  end

  # Shows email with details using IMAP

  def show
    
    @folder_name = params[:folder]
    @id = params[:id]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
    
  end
  
  # Deletes email from mailbox using IMAP

  def destroy
    
    @mesg_id = params[:id]
    @folder_nam = params[:folder]
    if "#{@folder_nam}" == "Trash" || "#{@folder_nam}" == "Drafts"
      $imap.select("#{@folder_nam}")
      $imap.search([@mesg_id]).each do |msg|
        $imap.store(msg, "+FLAGS", [:Deleted])
      end
    else
      $imap.select("#{@folder_nam}")
      $imap.search([@mesg_id]).each do |msg|
        $imap.copy(msg, "Trash")
        $imap.store(msg, "+FLAGS", [:Deleted])
      
      end
    end
    $imap.expunge
    $imap.close
    redirect_to :controller => :messages, :action => :index, :folder => @folder_nam

  end

  # Moves email from mailbox to another mailbox using IMAP

  def movemesgs
    
    if params[:move].nil?
      logger.info "*************************************"
      logger.debug params[:move]
      logger.debug "if part"
      logger.info "*************************************"
      redirect_to :controller => :messages, :action => :settings
    else

      logger.info "*************************************"
      logger.debug params[:move]
      logger.info "*************************************"

      redirect_to :controller => :messages, :action => :settings
    end

  end

  # Create, Delete and Rename mailbox using IMAP

  def settings
    
    # Creates new mailbox

    if params[:add].nil?      
    else
      begin
        @new_folder = params[:add][:folder_name]        
        if ! $imap.list('', "#{@new_folder}")
          $imap.create("#{@new_folder.capitalize}")
          $imap.subscribe("#{@new_folder.capitalize}")
          flash[:notice] = "Mailbox Created!"
        else

          redirect_to :controller => :messages, :action => :index, :folder => 'Sent'
        end
      rescue
        $error_msg = "folder name empty"
        redirect_to :controller => :users, :action => :logout
      end
    end
    
    # Deletes mailbox

    if params[:delete].nil?
    else
      begin
        @foldername = params[:delete][:folder_name]
        @foldername = @foldername.capitalize
        $imap.unsubscribe("#{@foldername}")
        $imap.delete("#{@foldername}")
        $imap.close
        flash[:notice] = "Mailbox Deleted!"
        redirect_to :controller => :messages, :action => :settings
      rescue
        $error_msg = "canot delete"
        redirect_to :controller => :users, :action => :logout
      end
    end
    
    # Renames mailbox

    if params[:rename].nil?
    else
      begin
        @oldname = params[:rename][:old_name]
        @newname = params[:rename][:new_name]
        @oldname = @oldname.capitalize
        @newname = @newname.capitalize
        $imap.unsubscribe("#{@oldname}")
        $imap.rename("#{@oldname}","#{@newname}")
        $imap.subscribe("#{@newname}")
        flash[:notice] = "Mailbox Renamed!"
        redirect_to :controller => :messages, :action => :settings
      rescue
        $error_msg = "canot delete"
        redirect_to :controller => :users, :action => :logout
      end
    end
    
  end

  # Subscribe or Un-subscribe mailbox using IMAP

  def sub_unsub
   
    @folder_name = params[:folder]
    if ! $imap.lsub('', "#{@folder_name}")
      $imap.subscribe("#{@folder_name}")
    else
      $imap.unsubscribe("#{@folder_name}")
    end
    redirect_to :controller => :messages, :action => :settings
    
  end
  
end