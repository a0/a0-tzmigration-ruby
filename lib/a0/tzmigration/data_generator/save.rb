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

      def save_index
        File.open(File.join(@out, 'index.md'), 'w') do |file|
          file.write version_head
          @timezones.keys.sort.map do |timezone_name|
            file.write timezones_row(timezone_name)
          end
        end
      end

      def version_head
        head_a = @versions.map do |version_data|
          version = version_data[:version]
          "[#{version}](versions/#{version}.json)"
        end.join ' | '
        head_b = @versions.map { '---' }.join ' | '

        "| | #{head_a} |\n| --- | #{head_b} |\n"
      end

      def timezones_row(timezone_name)
        row = @versions.map do |version_data|
          data = @timezones[timezone_name][:versions][version_data[:version]]
          if data && data[:alias]
            "→ #{data[:alias]}"
          elsif data
            "#{data[:transitions].count} "
          end
        end.join ' | '

        "| [#{timezone_name}](versions/#{timezone_name}.json) | #{row} |\n"
      end
    end
  end
end
