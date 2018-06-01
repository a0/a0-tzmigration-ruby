# frozen_string_literal: true

require 'rest-client'

module A0
  module TZMigration
    module Util
      def self.compact_range_list!(range_list) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        index = 0

        while index < range_list.count
          curr_range = range_list[index]
          next_range = range_list[index + 1]

          if next_range && curr_range[:fin] == next_range[:ini] && curr_range[:off] == next_range[:off]
            curr_range[:fin] = next_range[:fin]
            range_list.delete_at(index + 1)
          else
            index += 1
          end
        end

        range_list
      end

      def self.offset_to_str(offset)
        str = Time.at(offset.abs).utc.strftime('%H:%M:%S')
        sig = offset.negative? ? '-' : '+'

        "#{sig}#{str}"
      end

      def self.timestamp_to_str(timestamp)
        if timestamp == -Float::INFINITY
          '-∞'
        elsif timestamp == +Float::INFINITY
          '∞'
        else
          Time.at(timestamp).utc.to_s
        end
      end

      def self.range_item(ini, fin, off)
        { ini_str: timestamp_to_str(ini), fin_str: timestamp_to_str(fin), off_str: offset_to_str(off), ini: ini, fin: fin, off: off }
      end

      def self.next_index(index, range_list, timestamp)
        index += 1 while range_list[index + 1] && range_list[index][:ini] < timestamp && range_list[index][:fin] <= timestamp

        index
      end

      def self.split_range_list(range_list, timestamps) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        range_list = Marshal.load(Marshal.dump(range_list))
        index = 0

        timestamps.each do |timestamp|
          index = next_index(index, range_list, timestamp)
          range = range_list[index]

          if index < range_list.count && timestamp > range[:ini] && timestamp < range[:fin]
            range_list.insert index + 1, range.merge(ini: timestamp)
            range_list[index][:fin] = timestamp
          end
        end

        range_list
      end

      def self.load_from_network(path)
        url = "#{A0::TZMigration.config.base_url}/#{path}"

        JSON.parse RestClient.get(url)
      end

      def self.load_from_file(path)
        conf = A0::TZMigration.config.data_dir
        file = File.join(conf, path)

        raise "File #{path} not found at #{conf}" unless File.exist? file

        JSON.parse File.read(file)
      end

      def self.load_from_network_or_file(path)
        load_from_network(path)
      rescue StandardError => error
        warn "Unable to fetch from network, using local files (error was: #{error})"
        load_from_file(path)
      end
    end
  end
end
