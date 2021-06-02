class AdmintempController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  layout "admin"


  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      flash[:warning] = "This job already archieved"
      redirect_to root_path
    end
  end

  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 6)
    when 'by_upper_bound'
      Job.published.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 6)
    else
      Job.published.recent.paginate(:page => params[:page], :per_page => 6)
    end


  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_upper_bound, :wage_lower_bound, :contact_email, :is_hidden)
  end
end