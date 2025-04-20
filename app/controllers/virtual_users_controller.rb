class VirtualUsersController < ApplicationController
  before_action :set_virtual_user, only: %i[ show edit update destroy ]

  # GET /virtual_users or /virtual_users.json
  def index
    @virtual_users = VirtualUser.includes(:accounts)
    @virtual_users = @virtual_users.search(params[:keywords]) if params[:keywords].present?
    @virtual_users = @virtual_users.by_mobile(params[:mobile]) if params[:mobile].present?
    @virtual_users = @virtual_users.order(created_at: :desc).page(page_params)
  end

  # GET /virtual_users/1 or /virtual_users/1.json
  def show
  end

  # GET /virtual_users/new
  def new
    @virtual_user = VirtualUser.new
  end

  # GET /virtual_users/1/edit
  def edit
  end

  # POST /virtual_users or /virtual_users.json
  def create
    @virtual_user = VirtualUser.new(virtual_user_params)

    respond_to do |format|
      if @virtual_user.save
        format.html { redirect_to virtual_users_path, notice: "Virtual user was successfully created." }
        format.json { render :show, status: :created, location: @virtual_user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @virtual_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /virtual_users/1 or /virtual_users/1.json
  def update
    respond_to do |format|
      if @virtual_user.update(virtual_user_params)
        format.html { redirect_to virtual_users_path, notice: "Virtual user was successfully updated." }
        format.json { render :show, status: :ok, location: @virtual_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @virtual_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /virtual_users/1 or /virtual_users/1.json
  def destroy
    @virtual_user.destroy!

    respond_to do |format|
      format.html { redirect_to virtual_users_path, status: :see_other, notice: "Virtual user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_virtual_user
      @virtual_user = VirtualUser.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def virtual_user_params
      params.expect(virtual_user: [ :first_name, :last_name, :gender, :birthday, :mobile ])
    end
end
