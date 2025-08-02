class LettersController < ApplicationController

before_action :authenticate_user!, only: [:new, :create]

def index
    @letters = Letter.order(created_at: :desc) .limit(15)# 新しい順に並べる
end

def new
    @letter = Letter.new
end

def create
    letter = Letter.new(letter_params)

    letter.user_id = current_user.id

    if letter.save!
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
end

def edit
    @letter = Letter.find(params[:id])
  end

  def update
    letter = Letter.find(params[:id])
    if letter.update(letter_params)
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    letter = Letter.find(params[:id])
    letter.destroy
    redirect_to action: :index
  end

def show
     @letter = Letter.find(params[:id])
end

  private
  def letter_params
    params.require(:letter).permit(:name, :about, :day)
  end

end
