class EventsController < ApplicationController
    protect_from_forgery
  
    def index
      render json: Event.all
    end
  
    def show
      render json: event
    end
  
    def create
      render json: Event.create!(event_params)
    end
  
    def update
      event.update!(event_params)
      render json: event
    end
  
    def destroy
      destroyed_event = event.destroy!
      render json: destroyed_event
    end
  
    private
  
    def event
      Event.find(params[:id])
    end
  
    def event_params
      params.require(:event).permit(:title, :venue, :event_date)
    end
  end
  