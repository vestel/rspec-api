class ArtistsController < ApplicationController
  before_action :set_artist, only: [:destroy]
  respond_to :json

  def index
    @artists = Artist.all
    @artists.sort_by! &:name
    @artists.reverse! if params[:verse] == 'down'
    respond_with @artists, callback: params.fetch(:method, params[:function])
  end

  def destroy
    @artist.destroy
    head :no_content
  end

private
  def set_artist
    @artist = Artist.find params[:id]
  end
end