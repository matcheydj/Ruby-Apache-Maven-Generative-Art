# main.rb
require 'sinatra'
require './image_manipulation'
require './svg_tools'

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
    
    # Send random_combined effects
    post '/generate_random' do
    image_manipulation = ImageManipulation.new(params[:image_url])
    image_manipulation.generate_random_combined_image
    send_file "random_combined.png"
  end
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

post '/upload' do
  if params[:image_file]
    image_path = params[:image_file][:tempfile].path
    image_manipulation = ImageManipulation.new(image_path)

    # Apply selected effects
    effects = {}
    [:affine, :annotate, :arc, :bezier, :circle].each do |effect|
      if params[:effect_#{effect}]
        effects[effect] = params[:effect_#{effect}].split(',').map(&:to_f)
      end
    end

    image_manipulation.apply_all_effects(effects)

    # Send response
    send_file "original_#{@image.filename}"
    send_file "modified_image.png"
  else
    redirect '/'
  end
end

post '/translate_svg' do
  if params[:svg_data]
    dx = params[:dx].to_f
    dy = params[:dy].to_f

    translated_svg = SvgTools.translate_svg(params[:svg_data], dx, dy)

    # Send response
    content_type :xml
    body translated_svg
  else
    redirect '/'
  end
end

# Views
erb :index do
  @effects = [:affine, :annotate, :arc, :bezier, :circle, :geometric_patterns, :fractals, :cellular_automata, :pixelate, :gradients, :traditional_colors, :minimalist, :random_colors, :moving_particles]
end
