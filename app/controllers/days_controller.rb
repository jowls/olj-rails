class DaysController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_day, only: [:show, :edit, :update, :destroy]

  def finish_user_onboard
    @day = Day.create(:date => Day.new, :content => session['day'], :user_id => current_user )
    @day.save
    redirect_to('/journal')
  end

  # GET /days
  # GET /days.json
  def index
    #@days = Day.all
    @day_user = current_user
    @days = @day_user.days
  end

  # GET /days/1
  # GET /days/1.json
  def show
    @day = current_user.days.find(params[:id])
  end

  # GET /days/new
  def new
    @day = Day.new
    @day_user = current_user
    @day.user_id = @day_user.id
  end

  # GET /days/1/edit
  def edit
  end

  # POST /days
  # POST /days.json
  def create
    @day = Day.new(day_params)

    respond_to do |format|
      if @day.save
        format.html { redirect_to @day, notice: 'Day was successfully created.' }
        format.json { render action: 'show', status: :created, location: @day }
      else
        format.html { render action: 'new' }
        format.json { render json: @day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /days/1
  # PATCH/PUT /days/1.json
  def update
    respond_to do |format|
      if @day.update(day_params)
        format.html { redirect_to @day, notice: 'Day was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /days/1
  # DELETE /days/1.json
  def destroy
    @day.destroy
    respond_to do |format|
      format.html { redirect_to days_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_day
      @day = Day.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def day_params
      params.require(:day).permit(:date, :content, :user_id)
    end
end
