require 'sinatra'
require 'rmagick'
require 'nokogiri'
require './image_manipulation'
require './svg_tools'

class ImageManipulator < Sinatra::Application
  set :public_folder, 'public'

  get '/' do
    erb :index
  end

  post '/upload' do
    image_file = params[:image_file]
    original_filename = image_file[:filename]
    image_path = "uploads/#{original_filename}"
    File.open(image_path, 'wb') { |f| f.write(image_file[:tempfile].read) }

    if original_filename.include?(".svg")
      manipulator = SvgTools.new(image_path)
      effects = params[:effects] || []
      effects.each do |effect|
        manipulator.send(effect.to_sym, *params["effect_#{effect}"])
      end
      manipulator.save(image_path)
    else
      manipulator = ImageManipulation.new(image_path)
      effects = params[:effects] || []
      effects.each do |effect|
        manipulator.apply_effect(effect.to_sym)
      end
      manipulator.combine_all_effects("combined_#{original_filename}")
    end

    redirect "/results/#{original_filename}"
  end

  get '/results/:filename' do
    @filename = params[:filename]
    erb :results
  end
end
