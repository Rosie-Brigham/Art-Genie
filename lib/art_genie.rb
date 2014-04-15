require 'sinatra/base'
require 'arts_gallery_api'
require './lib/gallery'
require './lib/exhibition'
require 'erubis'

class ArtGenie < Sinatra::Base

  gallery_api = ArtsGalleryApi::Gallery.new
  ticket_api = ArtsGalleryApi::Ticket.new

  set :erb, :escape_html => true

  get %r{\A(/galleries)\Z|\A/\Z} do
    @galleries = gallery_api.all
    erb :index
  end

  get '/galleries/:id' do
    @gallery = Gallery.new(gallery_api.retrieve_a_gallery(params[:id]))
    erb :gallery
  end

  get '/galleries/:id/exhibitions' do
    @gallery = gallery_api.retrieve_a_gallery(params[:id])
    @exhibitions = gallery_api.get_gallery_exhibitions(params[:id])
    erb :exhibitions
  end

  get '/galleries/:gallery_id/exhibition/:id' do
    @exhibition = Exhibition.new(gallery_api.get_exhibition(params["id"]))
    # require 'pry'; binding.pry
    erb :exhibition
  end

  get '/galleries/:gallery_id/exhibitions/:id/tickets' do
    exhibition_params = gallery_api.get_exhibition(params[:id])
    gallery_params = gallery_api.retrieve_a_gallery(params[:gallery_id])
    @exhibition = Exhibition.new({ "id" => exhibition_params["id"], "name" => exhibition_params["name"], "gallery" => gallery_params["name"], "gallery_url" => "galleries/#{gallery_params["id"]}", "entry_fee" => exhibition_params["entry_fee"], "opens_on" => exhibition_params["opens_on"], "closes_on" => exhibition_params["closes_on"] })
    # require 'pry'; binding.pry
    erb :ticket_form

  end

  post '/tickets/buy' do
    name = params[:first_name] + " " + params[:last_name]
    date_time = params[:date] + " " + params[:time]
    exhibition_id = params[:exhibition_id]
    response = ticket_api.create_a_ticket(name,exhibition_id,date_time)
    if response.parsed_response["id"]
    redirect 'tickets/confirmation'
      else
        @errors = response.parsed_response
        exhibition_params = gallery_api.get_exhibition(params[:exhibition_id])
        gallery_params = gallery_api.retrieve_a_gallery(params[:gallery_id])
        @exhibition = Exhibition.new({ "id" => exhibition_params["id"], "name" => exhibition_params["name"], "gallery" => gallery_params["name"], "gallery_url" => "galleries/#{gallery_params["id"]}", "entry_fee" => exhibition_params["entry_fee"], "opens_on" => exhibition_params["opens_on"], "closes_on" => exhibition_params["closes_on"] })

        erb :ticket_form
      end


    
  end

  get '/tickets/confirmation' do
    erb :ticket_confirm
  end
end