class SurveySchemasController < ApplicationController
  before_action :set_survey_schema, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:index, :new, :edit, :update, :show]
  before_action :confirm_logged_in
  before_action :def_survey_questions, only: [:show]


  # GET /survey_schemas
  # GET /survey_schemas.json
  def index
    authorize SurveySchema
    @survey_schemas = SurveySchema.all
  end

  # GET /survey_schemas/1
  # GET /survey_schemas/1.json
  def show
    authorize SurveySchema
  end

  # GET /survey_schemas/new
  def new
    authorize SurveySchema
    @survey_schema = SurveySchema.new
    #@questions = Question.all
    @questions_category = [
      Question.where(category: 0).sort{
        |first, second|
        boolean_value = first.skill.downcase <=> second.skill.downcase
        boolean_value
      },
      Question.where(category: 1).sort{
        |first, second|
        boolean_value = first.skill.downcase <=> second.skill.downcase
        boolean_value
      },
      Question.where(category: 2).sort{
        |first, second|
        boolean_value = first.skill.downcase <=> second.skill.downcase
        boolean_value
      }
    ]
  end

  # GET /survey_schemas/1/edit
  def edit
    authorize SurveySchema
    @survey_schema = SurveySchema.find_by(id: params[:id])

    @all_questions_id = Question.pluck(:id)
    @questions_id = @survey_schema.questions.pluck(:id)
    @other_questions_id = @all_questions_id - @questions_id

    @other_questions = Question.where(id:@other_questions_id)
  end

  # POST /survey_schemas
  # POST /survey_schemas.json
  def create
    authorize SurveySchema
    p "szdkjfbndksjfñadjsnfajsdnfjkadsnfajksndfajsd"
    p survey_schema_params

    @survey_schema = SurveySchema.new(survey_schema_params)
    @survey_schema.cycle = params[:cycle]
    @questions = Question.where(id: params[:questions])


    @survey_schema.questions << @questions

    p @survey_schema.questions

    respond_to do |format|
      if @survey_schema.save
        format.html { redirect_to @survey_schema, notice: 'Survey schema was successfully created.' }
        format.json { render :show, status: :created, location: @survey_schema }
      else
        format.html { render :new }
        format.json { render json: @survey_schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survey_schemas/1
  # PATCH/PUT /survey_schemas/1.json
  def update
    authorize SurveySchema
    @survey_schema.questions.delete(Question.where(id:params[:delete_questions]))

    @add_questions = Question.where(id: params[:add_questions])

    @survey_schema.questions << @add_questions


    respond_to do |format|
      if @survey_schema.update(survey_schema_params)
        format.html { redirect_to @survey_schema, notice: 'Survey schema was successfully updated.' }
        format.json { render :show, status: :ok, location: @survey_schema }
      else
        format.html { render :edit }
        format.json { render json: @survey_schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_schemas/1
  # DELETE /survey_schemas/1.json
  def destroy
    authorize SurveySchema
    @survey_schema.destroy
    respond_to do |format|
      format.html { redirect_to survey_schemas_url, notice: 'Survey schema was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_schema
      @survey_schema = SurveySchema.find(params[:id])
    end

    def set_categories
      #@categories = ['INICIO', 'DESARROLLO', 'CIERRE']
      @categories = {0 => 'INICIO', 1 => 'DESARROLLO', 2 => 'CIERRE'}
      @skills = ['Liderazgo', 'Comunicación', 'Responsabilidad', 'Autoridad']
    end

    def def_survey_questions
    @questions_category = [
      @survey_schema.questions.where(category: 0).sort{
        |first, second|
        boolean_value = first.skill.downcase <=> second.skill.downcase
        boolean_value
      },
      @survey_schema.questions.where(category: 1).sort{
        |first, second|
        boolean_value = first.skill.downcase <=> second.skill.downcase
        boolean_value
      },
      @survey_schema.questions.where(category: 2).sort{
        |first, second|
        boolean_value = first.skill.downcase <=> second.skill.downcase
        boolean_value
      }
    ]
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_schema_params
      params.require(:survey_schema).permit(:title,:cycle)
    end
end
