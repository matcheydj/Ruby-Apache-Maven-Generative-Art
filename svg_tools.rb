require "nokogiri"

class SvgTools
  def initialize(svg_path)
    @doc = Nokogiri::XML(File.open(svg_path))
  end

  def scale(scale_factor)
    @doc.css("svg").each do |svg|
      svg["width"] = (svg["width"].to_f * scale_factor).round.to_s
      svg["height"] = (svg["height"].to_f * scale_factor).round.to_s
    end
    @doc.css("path, circle, ellipse, rect, line, polygon, polyline").each do |element|
      element["d"] = transform_path(element["d"], scale_factor)
    end
  end

  def translate(x_shift, y_shift)
    @doc.css("g").each do |group|
      group["transform"] = "translate(#{x_shift}, #{y_shift})" + (group["transform"] ? " #{group['transform']}" : "")
    end
  end

  def apply_filter(filter_name)
    # ... Implement logic to apply SVG filters ...
  end

  def change_color(color)
    @doc.css("path, circle, ellipse, rect, line, polygon, polyline").each do |element|
      element["fill"] = color
      element["stroke"] = color
    end
  end

  def save(output_path)
    File.open(output_path, "w") { |f| f.write(@doc.to_xml) }
  end

  private

  def transform_path(path_string, scale_factor)
    path_string.split(/[\s,]+/).map do |segment|
      case segment[0]
      when "M", "L", "C", "Q"
        segment.gsub(/\d+/, &method(:transform_coordinate).curry(scale_factor))
      else
        segment
      end
    end.join(" ")
  end

  def transform_coordinate(scale_factor, coordinate)
    (coordinate.to_f * scale_factor).round.to_s
  end
end
