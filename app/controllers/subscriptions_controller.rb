class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :update, :destroy]

  # GET /subscriptions
  def index
    @subscriptions = Subscription.all
    render json: @subscriptions
  end

  # GET /subscriptions/1
  def show
    render json: @subscription
  end

  # POST /subscriptions
  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      @invoice = make_invoice(@subscription.id)
      
      if @invoice.save
        render json: @subscription, status: :created, location: @subscription
      else
        puts "invoice error"
        render json: @invoice, status: :unprocessable_entity
      end
    else
      puts "subscription error"
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /subscriptions/1
  def update
    if @subscription.update(subscription_params)
      render json: @subscription
    else
      render json: @subscription.errors, status: :unprocessable_entity
    end
  end

  # DELETE /subscriptions/1
  def destroy
    @all_invoice_children = Invoice.where( :subscription_id => params[:id]).destroy_all
    @subscription.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def subscription_params
        # params.fetch(:subscription, {}).permit(:name)
      myHash = {}
      myHash["name"] = params[:newSubscription][:name]
      myHash["amount"] = params[:newSubscription][:amount]
      return myHash
    end

    def make_invoice(subscriptionId)
      puts "MAKING INVOICE"
      # puts subscriptionId
      myHash = {}
      paymentDateHash = params[:invoiceData][:paymentDate]
      day = paymentDateHash[:day]
      month = paymentDateHash[:month]
      year = paymentDateHash[:year]
      myHash[:PaymentDate] = Time.local(year, month, day)
      puts myHash[:PaymentDate]
      myHash[:subscription_id] = subscriptionId
      myHash
      @invoice = Invoice.new( myHash )
    end
end
