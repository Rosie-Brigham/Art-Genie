require 'arts_gallery_api'

class Gallery

  attr_reader :id, :name, :description, :address, :opening_hour, :closing_hour

  def initialize(args)
    @id = args["id"]
    @name = args["name"]
    @description = args["description"]
    @address = args["address"]
    @opening_hour = args["opening_hour"]
    @closing_hour = args["closing_hour"]
  end

end