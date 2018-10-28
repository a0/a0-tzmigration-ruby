# frozen_string_literal: true

def reload!(base = 'a0-tzmigration-ruby')
  $LOADED_FEATURES.select { |feature| feature =~ %r{\/#{base}\/lib\/} }.each do |feature|
    puts "Reloading #{feature.gsub(/.*#{base}/, base)}: #{load feature}"
  end
end
