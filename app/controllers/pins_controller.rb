class PinsController < ApplicationController
  before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :pin_owner, only: [:edit, :update, :destroy]
  before_action :logged_user, only: [:index, :show, :new, :edit, :mypins]

  def index
    @pins = Pin.all.order("created_at DESC")
  end

  def show
  end

  def new
    #@pin = Pin.new
    @pin = current_user.pins.build
  end

  def create
    #@pin = Pin.new(pin_params)
    @pin = current_user.pins.build(pin_params)

    if @pin.save
      redirect_to @pin, notice: "Successfully created new Pin!"
    else
      render 'new'
    end
  end

  def edit
  end

  # Aby zablokować edycję i usuwanie pinów innym użytkownikom niż autor
  def pin_owner
   unless @pin.user_id == current_user.id
    flash[:notice] = 'Access denied as you are not owner of this Pin'
    redirect_to pins_path
   end
  end

  def userpin
    @pins = current_user.pins
    @users = User.all
    @user = User.find(params[:user])
    @pin = @user.pins
  end

  def mypins
    @pins = current_user.pins
  end

  def update
    if @pin.update(pin_params)
      redirect_to @pin, notice: "Pin was successfully updated!"
    else
      render 'edit'
    end
  end

  def destroy
    @pin.destroy
    redirect_to root_path
  end

  def upvote
    @pin.upvote_by current_user
    redirect_to :back
  end

  private
  def pin_params
    params.require(:pin).permit(:title, :description, :image)
  end

  def find_pin
    @pin = Pin.find(params[:id])
  end

  def logged_user
    @user = current_user
  end

end
