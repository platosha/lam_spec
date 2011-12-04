module DefaultInheritedResource
  def edit
    render :new
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to(where_to_redirect) }
      failure.html { render :new }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to(where_to_redirect) }
      failure.html { render :new }
    end
  end
  
  def change
    resource.send(params[:event_method])
    redirect_to where_to_redirect
  end
  
  # def move
  #   resource.send("move_#{params[:direction]}")
  #   redirect_to where_to_redirect
  # end  
  
  def destroy
    destroy! {collection_url}
  end
  
  def where_to_redirect
    resource_url
  end
    
end