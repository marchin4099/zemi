class PlansController < ApplicationController

before_action :authenticate_user!, only: [:new, :create]

def index
    @plans = Plan.all
end

def new
    @plan = Plan.new
end

def create
    plan = Plan.new(plan_params)

    plan.user_id = current_user.id

    if plan.save!
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
end

def edit
    @plan = Plan.find(params[:id])
  end

  def update
    plan = Plan.find(params[:id])
    if plan.update(plan_params)
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    plan = Plan.find(params[:id])
    plan.destroy
    redirect_to action: :index
  end

def show
     @plan = Plan.find(params[:id])
end

  private
  def plan_params
    params.require(:plan).permit(:name, :about, :image)
  end

end



