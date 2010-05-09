class CausesController < BaseController

  require 'htmlentities'
 
  #These two methods make it easy to use helpers in the controller.
  #This could be put in application_controller.rb if we want to use
  #helpers in many controllers
  def help
    Helper.instance
  end

  class Helper
    include Singleton
    include ActionView::Helpers::SanitizeHelper
    extend ActionView::Helpers::SanitizeHelper::ClassMethods
  end

  uses_tiny_mce(:only => [:new, :edit, :create, :update, :clone ]) do
    AppConfig.default_mce_options
  end
  
  uses_tiny_mce(:only => [:show]) do
    AppConfig.simple_mce_options
  end

  def show
    @cause = Cause.find(params[:id])
#     @comments = @cause.comments.find(:all, :limit => 20, :order => 'created_at DESC', :include => :user)
  end

  def index
    @causes = Causes.find(:all, :page => {:current => params[:page]})
  end

  def new
    @cause = Cause.new(params[:cause])
    @metro_areas, @states = setup_metro_area_choices_for(current_user)
    @metro_area_id, @state_id, @country_id = setup_location_for(current_user)
  end
  
  def edit
    @cause = Cause.find(params[:id])
    @metro_areas, @states = setup_metro_area_choices_for(@cause)
    @metro_area_id, @state_id, @country_id = setup_location_for(@cause)
  end
    
  def create
    @cause = Cause.new(params[:cause])
    @cause.user = current_user
    if params[:metro_area_id]
      @cause.metro_area = MetroArea.find(params[:metro_area_id])
    else
      @cause.metro_area = nil
    end
    respond_to do |format|
      if @cause.save
        flash[:notice] = "Cause was successfully created"
        
        format.html { redirect_to cause_path(@cause) }
      else
        format.html { 
          @metro_areas, @states = setup_metro_area_choices_for(@cause)
          if params[:metro_area_id]
            @metro_area_id = params[:metro_area_id].to_i
            @state_id = params[:state_id].to_i
            @country_id = params[:country_id].to_i
          end
          render :action => "new"
        }
      end
    end    
  end

  def update
    @cause = Cause.find(params[:id])
    if params[:metro_area_id]
      @cause.metro_area = MetroArea.find(params[:metro_area_id])
    else
      @cause.metro_area = nil
    end
        
    respond_to do |format|
      if @cause.update_attributes(params[:cause])
        format.html { redirect_to cause_path(@cause) }
      else
        format.html { 
          @metro_areas, @states = setup_metro_area_choices_for(@cause)
          if params[:metro_area_id]
            @metro_area_id = params[:metro_area_id].to_i
            @state_id = params[:state_id].to_i
            @country_id = params[:country_id].to_i
          end
          render :action => "edit"
        }
      end
    end
  end
  
  # DELETE /homepage_features/1
  # DELETE /homepage_features/1.xml
  def destroy
    @cause = Cause.find(params[:id])
    @cause.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def clone
    @cause = Cause.find(params[:id]).clone
    @metro_areas, @states = setup_metro_area_choices_for(@cause)
    @metro_area_id, @state_id, @country_id = setup_location_for(@cause)
    render :template => 'causes/new'
  end

  protected

  def setup_metro_area_choices_for(object)
    metro_areas = states = []
    if object.metro_area
      if object.is_a? Cause
        states = object.metro_area.country.states
        if object.metro_area.state
          metro_areas = object.metro_area.state.metro_areas.all(:order=>"name")
        else
          metro_areas = object.metro_area.country.metro_areas.all(:order=>"name")
        end        
      elsif object.is_a? User
        states = object.country.states if object.country
        if object.state
          metro_areas = object.state.metro_areas.all(:order => "name")
        else
          metro_areas = object.country.metro_areas.all(:order => "name")
        end
      end
    end
    return metro_areas, states
  end

  def setup_location_for(object)
    metro_area_id = state_id = country_id = nil
    if object.metro_area
      metro_area_id = object.metro_area_id
      if object.is_a? Cause
        state_id = object.metro_area.state_id
        country_id = object.metro_area.country_id
      elsif object.is_a? User
        state_id = object.state_id
        country_id = object.country_id
      end
    end
    return metro_area_id, state_id, country_id
  end

end
