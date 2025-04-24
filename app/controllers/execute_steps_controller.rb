class ExecuteStepsController < ApplicationController
  before_action :set_plan, only: %i[ index new create ]
  before_action :set_execute_step, only: %i[ show edit update destroy ]

  # GET /plans/:plan_id/execute_steps
  def index
    @execute_steps = @plan.steps
  end

  # GET /execute_steps/1 or /execute_steps/1.json
  def show
  end

  # GET /plans/:plan_id/execute_steps/new
  def new
    @execute_step = @plan.steps.new
  end

  # GET /execute_steps/1/edit
  def edit
  end

  # POST /plans/:plan_id/execute_steps
  def create
    @execute_step = @plan.steps.new(execute_step_params)

    respond_to do |format|
      if @execute_step.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @execute_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /execute_steps/1 or /execute_steps/1.json
  def update
    respond_to do |format|
      if @execute_step.update(execute_step_params)
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @execute_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /execute_steps/1 or /execute_steps/1.json
  def destroy
    @execute_step.destroy!

    respond_to do |format|
      format.turbo_stream
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_execute_step
      @execute_step = ExecuteStep.find(params.expect(:id))
    end

    def set_plan
      @plan = Plan.find(params.expect(:plan_id))
    end

    # Only allow a list of trusted parameters through.
    def execute_step_params
      params.expect(execute_step: [ :type, :element, :action, :action_value ])
    end
end
