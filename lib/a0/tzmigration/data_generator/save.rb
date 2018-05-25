# frozen_string_literal: true

require 'json'

module A0
  module TZMigration
    class DataGenerator
      def save_versions
        FileUtils.mkdir_p File.join(@out, 'versions')

        @versions.each do |version_data|
          File.open(File.join(@out, 'versions', "#{version_data[:version]}.json"), 'w') do |file|
            file.write(JSON.generate(version_data))
          end
        end
      end

      def save_timezones
        FileUtils.mkdir_p File.join(@out, 'timezones')

        @timezones.each do |name, timezone_data|
          dir = name.split('/')[0...-1]
          FileUtils.mkdir_p File.join(@out, 'timezones', dir) unless dir.empty?

          File.open(File.join(@out, 'timezones', "#{name}.json"), 'w') do |file|
            file.write(JSON.generate(timezone_data))
          end
        end
      end

      def save_versions_index
        FileUtils.mkdir_p File.join(@out, 'versions')

        File.open(File.join(@out, 'versions', '00-index.json'), 'w') do |file|
          versions = @versions.map do |version_data|
            [version_data[:version], { released_at: version_data[:released_at], timezones: version_data[:timezones].keys }]
          end.to_h

          file.write(JSON.generate(versions: versions))
        end
      end

      def save_timezones_index
        FileUtils.mkdir_p File.join(@out, 'timezones')

        File.open(File.join(@out, 'timezones', '00-index.json'), 'w') do |file|
          object = @timezones.map do |name, timezone_data|
            versions = timezone_data[:versions].keys
            [name, { versions: versions }]
          end.to_h

          file.write(JSON.generate(timezones: object))
        end
      end
    end
  end
end
