require 'arts_gallery_api'


class Exhibition

  attr_reader :id, :name, :gallery, :gallery_url, :entry_fee, :closes_on, :opens_on

  def initialize(args)
    @id = args["id"]
    @name = args["name"]
    @gallery = args["gallery"]
    @gallery_url = args["gallery_url"]
    @entry_fee = args["entry_fee"]
    @opens_on = args["opens_on"]
    @closes_on = args["closes_on"]
  end

  def ticket_url
    "#{@gallery_url}/exhibitions/#{@id}/tickets"
  end

end
