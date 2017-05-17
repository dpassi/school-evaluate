class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token


  def evaluate
    @surveys = SurveySchema.all
  end

  # GET /evaluations
  # GET /evaluations.json
  def index
    @evaluations = Evaluation.all
  end

  # GET /evaluations/1
  # GET /evaluations/1.json
  def show
  end

  # GET /evaluations/new
  def new
    @evaluation = Evaluation.new
    @survey = SurveySchema.find(params[:survey_id])
    @user_id= params[:survey_id]
  end

  # GET /evaluations/1/edit
  def edit
  end

  # POST /evaluations
  # POST /evaluations.json
  def create
    answers = params[:answers]
    answers.each do |question_id|
      puts question_id + answers[question_id]
      q = Answer.create(name: params[:names][question_id],
                      genre: params[:genres][question_id],
                      text: params[:answers][question_id])
      Evaluation.create(user_id: params[:other_params][:user_id].to_i,
                        survey_schema_id:params[:other_params][:survey_id].to_i,
                        answer_id: q.id)
    end
    redirect_to '/evaluations', notice: 'Evaluation was successfully created.'
  end

  # PATCH/PUT /evaluations/1
  # PATCH/PUT /evaluations/1.json
  def update
    respond_to do |format|
      if @evaluation.update(evaluation_params)
        format.html { redirect_to @evaluation, notice: 'Evaluation was successfully updated.' }
        format.json { render :show, status: :ok, location: @evaluation }
      else
        format.html { render :edit }
        format.json { render json: @evaluation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluations/1
  # DELETE /evaluations/1.json
  def destroy
    @evaluation.destroy
    respond_to do |format|
      format.html { redirect_to evaluations_url, notice: 'Evaluation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evaluation
      @evaluation = Evaluation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def evaluation_params
      params.require(:evaluation).permit(:user_id, :answer_id, :survey_schema_id)
    end
end