# main.rb
require 'sinatra'
require './image_manipulation'

set :port, 3000

get '/' do
  erb :index
end

post '/upload' do
  if params[:image_file]
    image_path = params[:image_file][:tempfile].path
    image_manipulation = ImageManipulation.new(image_path)

    # Apply selected effects
    params.each do |key, value|
      if key.to_sym.start_with?(:effect_)
        image_manipulation.apply_effect(key.to_sym.split('_').last.to_sym)
      end
    end

    # Combine all effects
    image_manipulation.combine_all_effects

    # Send response
    send_file "original_#{@image.filename}"
    send_file "modified_#{@image.filename}"
    send_file "combined_image.png"
  else
    redirect '/'
  end
end

post '/generate' do
  # Implement logic for AI-based image generation based on user input
end

# Views
erb :index do
  @effects = [:geometric_patterns, :fractals, :cellular_automata, :pixelate, :gradients, :traditional_colors, :minimalist, :random_colors, :moving_particles]
end
