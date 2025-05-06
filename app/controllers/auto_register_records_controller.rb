class AutoRegisterRecordsController < ApplicationController
  before_action :set_auto_register_record, only: %i[ show edit update destroy ]

  # GET /auto_register_records or /auto_register_records.json
  def index
    @auto_register_records = AutoRegisterRecord.all
  end

  # GET /auto_register_records/1 or /auto_register_records/1.json
  def show
  end

  # GET /auto_register_records/new
  def new
    @auto_register_record = AutoRegisterRecord.new
  end

  # GET /auto_register_records/1/edit
  def edit
  end

  # POST /auto_register_records or /auto_register_records.json
  def create
    @auto_register_record = AutoRegisterRecord.new(auto_register_record_params)

    respond_to do |format|
      if @auto_register_record.save
        format.html { redirect_to @auto_register_record, notice: "Auto register record was successfully created." }
        format.json { render :show, status: :created, location: @auto_register_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @auto_register_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auto_register_records/1 or /auto_register_records/1.json
  def update
    respond_to do |format|
      if @auto_register_record.update(auto_register_record_params)
        format.html { redirect_to @auto_register_record, notice: "Auto register record was successfully updated." }
        format.json { render :show, status: :ok, location: @auto_register_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @auto_register_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auto_register_records/1 or /auto_register_records/1.json
  def destroy
    @auto_register_record.destroy!

    respond_to do |format|
      format.html { redirect_to auto_register_records_path, status: :see_other, notice: "Auto register record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auto_register_record
      @auto_register_record = AutoRegisterRecord.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def auto_register_record_params
      params.expect(auto_register_record: [ :company_id, :virtual_user_id, :address_id, :state, :error_message, :properties ])
    end
end
