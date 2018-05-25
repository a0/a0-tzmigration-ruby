# frozen_string_literal: true

module A0
  module TZMigrate
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

    def self.next_index(index, range_list, timestamp)
      index += 1 while (index + 1) < range_list.count && range_list[index][:ini] < timestamp && range_list[index][:fin] <= timestamp

      index
    end

    def self.timestamp_to_utc(timestamp)
      Time.at(timestamp).utc if timestamp && timestamp != Float::INFINITY && timestamp != -Float::INFINITY
    end

    def self.timestamp_range_list!(range_list)
      range_list.each do |range|
        range[:utc_ini] = timestamp_to_utc(range[:ini])
        range[:utc_fin] = timestamp_to_utc(range[:fin])
      end

      range_list
    end

    def self.split_range_list!(range_list, timestamps) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      index = next_index(0, range_list, timestamps.first)

      timestamps.each_with_index do |timestamp, timestamp_index|
        range = range_list[index]

        if timestamp > range[:ini] && timestamp < range[:fin] && index < range_list.count
          if index + 1 == range_list.count
            range_list.insert index + 1, range.merge(ini: timestamp)
            range_list[index][:fin] = timestamp
          else
            range_list.insert index + 1, range.merge(fin: timestamp)
            range_list[index + 1][:ini] = timestamp
          end
        end

        next_timestamp = timestamps[timestamp_index + 1]

        index = next_index(index, range_list, next_timestamp) if next_timestamp
      end

      range_list
    end
  end
end
