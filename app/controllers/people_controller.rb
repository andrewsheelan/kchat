class PeopleController < ApplicationController
  before_action :set_person, only: [:show]
  before_action :authenticate_user!

  respond_to :html

  def index
    @users = User.all
    render json: @users
  end

  def show
    respond_with(@person)
  end

  private
    def set_person
      @person = User.find(params[:id])
    end
end
