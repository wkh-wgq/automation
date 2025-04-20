class ChildEmailsController < ApplicationController
  before_action :set_parent_email, only: %i[ index create new ]
  before_action :set_email, only: %i[ show edit update destroy ]

  # GET /emails/:email_id/child_emails
  def index
    @emails = @parent_email.children.includes(:accounts).order(created_at: :desc).page(page_params)
  end

  # GET /child_emails/1
  def show
  end

  # GET /emails/:email_id/child_emails/new
  def new
    @email = @parent_email.children.new
  end

  # GET /child_emails/1/edit
  def edit
  end

  # POST /emails/:email_id/child_emails
  def create
    @email = @parent_email.children.new(email_params)

    respond_to do |format|
      if @email.save
        format.html { redirect_to email_child_emails_path(email_id: @email.parent_id), notice: "Email was successfully created." }
        format.json { render :show, status: :created, location: @email }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /child_emails/1
  def update
    respond_to do |format|
      if @email.update(email_params)
        format.html { redirect_to email_child_emails_path(email_id: @email.parent_id), notice: "Email was successfully updated." }
        format.json { render :show, status: :ok, location: @email }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /child_emails/1
  def destroy
    parent_id = @email.parent_id
    @email.destroy!

    respond_to do |format|
      format.html { redirect_to email_child_emails_path(email_id: parent_id), status: :see_other, notice: "Email was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = Email.find(params.expect(:id))
    end

    def set_parent_email
      @parent_email = Email.find(params[:email_id])
    end

    # Only allow a list of trusted parameters through.
    def email_params
      params.expect(email: [ :email, :mobile ])
    end
end
