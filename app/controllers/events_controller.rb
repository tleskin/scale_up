class EventsController < ApplicationController
  def index
    @items = Item.active.not_in_cart(session[:cart]).paginate(:page => params[:page], :per_page => 10)
    @category = Category.find_by(name: params[:category])
    @categories = Category.all

    if @category
      @events ||= Event.where(category: @category).paginate(:page => params[:page], :per_page => 10)
    else
      @events ||= Event.all.paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    @items = @event.items.active.not_in_cart(session[:cart])
  end

  def random
    if Event.count > 0
      # offset = rand(Event.active.count)
      # event = Event.active.offset(offset).first
      offset = rand(1..Event.all.count)
      event = Event.find(offset)
      redirect_to event
    else
      redirect_to root_path
    end
  end
end
