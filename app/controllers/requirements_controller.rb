class RequirementsController < ApplicationController

  authorize_resource :class => false
  before_filter :set_current_requirement, only: [:show, :edit, :update, :destroy]

  # ------------- before filter methods ------------- #
  def set_current_requirement
    @requirement = Requirement.find(params[:id])
  end
  # ------------- end before filter methods ------------- #

  def index
    @requirements = Requirement.all
  end

  def show
  end

  def new
    @requirement = Requirement.new
  end

  def edit
  end

  def create
    @requirement = Requirement.new(params[:requirement])
    if @requirement.save
      redirect_to(@requirement, notice: 'Requirement was successfully created.')
    else
      render action: "new"
    end
  end

  def update
    if @requirement.update_attributes(params[:requirement])
      redirect_to(@requirement, notice: 'Requirement was successfully updated.')
    else
      render action: "edit"
    end
  end

  def destroy
    @requirement.destroy(:force)
    redirect_to(requirements_url)
  end
end
