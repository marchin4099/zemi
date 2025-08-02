class StudentsController < ApplicationController
 
before_action :authenticate_user!, only: [:new, :create]

def index
    @students = Student.all
end

def new
    @student = Student.new
end

def create
    student = Student.new(student_params)

    student.user_id = current_user.id

    if student.save!
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
end

def edit
    @student = Student.find(params[:id])
  end

  def update
    student = Student.find(params[:id])
    if student.update(student_params)
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    student = Student.find(params[:id])
    student.destroy
    redirect_to action: :index
  end

def show
     @student = Student.find(params[:id])
end

  private
  def student_params
    params.require(:student).permit(:name, :about, :image)
  end
end
