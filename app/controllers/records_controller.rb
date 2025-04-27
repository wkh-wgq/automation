class RecordsController < ApplicationController
  before_action :set_plan, only: %i[ index new create ]
  before_action :set_record, only: %i[ show edit update destroy execute ]

  # GET /plans/:plan_id/records
  def index
    @records = @plan.records
  end

  # GET /records/1 or /records/1.json
  def show
  end

  # GET /plans/:plan_id/records/new
  def new
    @record = @plan.records.new
  end

  # GET /records/1/edit
  def edit
  end

  # POST /plans/:plan_id/records
  def create
    @record = @plan.records.new(record_params)

    respond_to do |format|
      if @record.save
        format.html { redirect_to plan_records_path(plan_id: @plan.id), notice: "Record was successfully created." }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1 or /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to plan_records_path(plan_id: @record.plan_id), notice: "Record was successfully updated." }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1 or /records/1.json
  def destroy
    plan_id = @record.plan_id
    @record.destroy!

    respond_to do |format|
      format.html { redirect_to plan_records_path(plan_id: plan_id), status: :see_other, notice: "Record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PUT /records/{id}/execute
  def execute
    @record.execute!
    respond_to do |format|
      format.html { redirect_to plan_records_path(plan_id: @record.plan_id), notice: "Record was successfully executed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params.expect(:id))
    end

    def set_plan
      @plan = Plan.find(params.expect(:plan_id))
    end

    # Only allow a list of trusted parameters through.
    def record_params
      params.expect(record: [ :plan_id, :account_id, :state, :failed_step, :error_message ])
    end
end
