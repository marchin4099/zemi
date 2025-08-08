class TweetsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :mypage]
    
  def index
        @tweets = Tweet.order(created_at: :asc)
  end
  def new
    @tweet = Tweet.new
  end

  def create
    tweet = Tweet.new(tweet_params)

    tweet.user_id = current_user.id

    if tweet.save!
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  

  

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    tweet = Tweet.find(params[:id])
    if tweet.update(tweet_params)
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end

  def outline

  end

  def activity

  end

  def member

  end

  def top
  @tweets = Tweet.order(created_at: :desc).limit(1)
  @letters = Letter.order(created_at: :desc).limit(3)
end

  def question

  end

  def teacher

  end

  def mypage

  end

  def newmypage

  end

def show
     @tweet = Tweet.find(params[:id])
end

 
  private
  def tweet_params
    params.require(:tweet).permit(:name, :about, :day, :place, :image, :body)
  end
 
end
