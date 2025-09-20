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

# app/controllers/tweets_controller.rb
require "image_processing/mini_magick"
MAX_BYTES = 10.megabytes

def create
  @tweet = Tweet.new(tweet_params.except(:image))

  if (img = tweet_params[:image]).present?
    attach_shrunk_image(@tweet, img)  # ここで圧縮
  end

  if @tweet.save
    redirect_to @tweet, notice: "投稿しました"
  else
    flash.now[:alert] = @tweet.errors.full_messages.join("\n")
    render :new, status: :unprocessable_entity
  end
rescue ActiveStorage::IntegrityError
  redirect_back fallback_location: new_tweet_path, alert: "画像が10MBを超えています。サイズを小さくして再投稿してください。"
end

private
def attach_shrunk_image(record, uploaded)
  return record.image.attach(uploaded) if uploaded.size <= MAX_BYTES

  processed = ImageProcessing::MiniMagick
                .source(uploaded.tempfile)
                .auto_orient
                .resize_to_limit(2000, 2000)
                .strip
                .convert("jpg")
                .quality(85)
                .call

  if File.size(processed.path) > MAX_BYTES
    processed = ImageProcessing::MiniMagick
                  .source(processed)
                  .resize_to_limit(1600, 1600)
                  .quality(75)
                  .call
  end

  record.image.attach(
    io: File.open(processed.path),
    filename: "#{File.basename(uploaded.original_filename, '.*')}.jpg",
    content_type: "image/jpeg"
  )
end
