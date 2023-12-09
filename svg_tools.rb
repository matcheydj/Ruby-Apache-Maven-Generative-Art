# svg_tools.rb
class SvgTools
  def self.translate_svg(svg_data, dx, dy)
    # Parse SVG data
    doc = Nokogiri::XML(svg_data)

    # Apply translation
    doc.xpath('//*[@transform]').each do |element|
      current_transform = element['transform']
      element['transform'] = translate_transform(current_transform, dx, dy)
    end

    # Return modified SVG data
    doc.to_xml
  end

  private

  def self.translate_transform(transform, dx, dy)
    match = transform.match(/translate\((.*),(.*)\)/)
    return transform unless match

    tx, ty = match.captures.map(&:to_f)
    "translate(#{tx + dx}, #{ty + dy})"
  end
end
