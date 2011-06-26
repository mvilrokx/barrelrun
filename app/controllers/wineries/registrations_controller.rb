class Wineries::RegistrationsController < Devise::RegistrationsController

  def new
#    super
    @winery = Winery.new
    @winery.credit_cards.build
    @winery.build_subscription
  end

  def create
    puts "Custom Registration Controller"
    super    
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end

end
