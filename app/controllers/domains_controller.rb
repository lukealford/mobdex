class DomainsController < ApplicationController
  before_filter :admin_authorized, :except => [:index, :show]
  
  def show
    @domain = Domain.find(params[:id])
  end
  
  def index
    @domains, noresults = Domain.search(params[:search])
    @tags = Tag.all
    if noresults
      flash[:notice] = "I could not find any results. Sorry"
    else
      # We do this because flash will some times keep the data for more the one request
      flash[:notice] = nil
    end
  end
  
  def new
    @domain = Domain.new
  end
  
  def edit
    @domain = Domain.find(params[:id])
  end
  
  def update
    @domain = Domain.find(params[:id])

    if @domain.update_attributes(params[:domain])
      redirect_to domains_path
    else
      render :action => "edit"
    end
  end
  
  def create
    @domain = Domain.new(params[:domain])
    
    if @domain.save
      flash[:success] = "Domain #{@domain.url} has been created"
      redirect_to domains_path
    else
      flash[:error] = "Domain could not be created do to a error"
      render :action => :new
    end
  end
  
  def destroy
    @domain = Domain.find(params[:id])
    @domain.delete
    
    redirect_to domains_path
  end
  
  def update_all
    @status = Domain.update_all_domains
    if @status
      flash[:success] = "All information was successfully updated"
    else
      flash[:error] = "Some of the information could not be updated dew to a error. Please contact admin."
    end
    
    redirect_to domains_path
  end
  
  def get_ssl_url
    domain = Domain.find(params[:id])
    @content = ssl_fetch(domain.url)
    
    render :layout => false
  end
end