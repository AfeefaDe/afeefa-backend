class MarketEntriesController < ApplicationController
  before_action :set_market_entry, only: [:show, :edit, :update, :destroy]

  # GET /market_entries
  # GET /market_entries.json
  def index
    @market_entries = MarketEntry.all
  end

  # GET /market_entries/1
  # GET /market_entries/1.json
  def show
  end

  # GET /market_entries/new
  def new
    @market_entry = MarketEntry.new
  end

  # GET /market_entries/1/edit
  def edit
  end

  # POST /market_entries
  # POST /market_entries.json
  def create
    @market_entry = MarketEntry.new(market_entry_params)

    respond_to do |format|
      if @market_entry.save
        format.html { redirect_to @market_entry, notice: 'Market entry was successfully created.' }
        format.json { render :show, status: :created, location: @market_entry }
      else
        format.html { render :new }
        format.json { render json: @market_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /market_entries/1
  # PATCH/PUT /market_entries/1.json
  def update
    respond_to do |format|
      if @market_entry.update(market_entry_params)
        format.html { redirect_to @market_entry, notice: 'Market entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @market_entry }
      else
        format.html { render :edit }
        format.json { render json: @market_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /market_entries/1
  # DELETE /market_entries/1.json
  def destroy
    @market_entry.destroy
    respond_to do |format|
      format.html { redirect_to market_entries_url, notice: 'Market entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_market_entry
      @market_entry = MarketEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def market_entry_params
      params.require(:market_entry).permit(:type, :way, :availabilty, :requested_At, :assigned_at, :pending_since)
    end
end
