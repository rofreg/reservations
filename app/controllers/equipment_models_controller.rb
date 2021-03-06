class EquipmentModelsController < ApplicationController
  before_filter :require_admin
  skip_before_filter :require_admin, :only => [:index, :show]
  
  def index
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @equipment_models = @category.equipment_models
    else
      #@equipment_models = EquipmentModel.find(:all, :order => )
      @equipment_models = EquipmentModel.find(:all, :include => :category, :order => 'categories.name ASC, equipment_models.name ASC')
    end
  end
  
  def show
    @equipment_model = EquipmentModel.find(params[:id])
  end
  
  def new
    @category = Category.find(params[:category_id]) if params[:category_id]
    @equipment_model = EquipmentModel.new(:category => @category)
  end
  
  def create
    @equipment_model = EquipmentModel.new(params[:equipment_model])
    if @equipment_model.save
      flash[:notice] = "Successfully created equipment model."
      redirect_to @equipment_model
    else
      render :action => 'new'
    end
  end
  
  def edit
    @equipment_model = EquipmentModel.find(params[:id])
  end
  
  def update
    @equipment_model = EquipmentModel.find(params[:id])
    @equipment_model.checkout_procedures = nil if params[:clear_checkout_procedures]
    @equipment_model.checkin_procedures = nil if params[:clear_checkin_procedures]
    if @equipment_model.update_attributes(params[:equipment_model])
      flash[:notice] = "Successfully updated equipment model."
      redirect_to @equipment_model
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @equipment_model = EquipmentModel.find(params[:id])
    @equipment_model.destroy
    flash[:notice] = "Successfully destroyed equipment model."
    redirect_to equipment_models_url
  end
end
