# frozen_string_literal: true

module A0
  module TZMigration
    class TimezoneVersion
      attr_reader :path, :name, :version

      def initialize(name, version)
        @name = name
        @version = version
        @path = File.expand_path File.join(__dir__, '..', '..', '..', 'data', 'timezones', "#{name}.json")

        raise "Timezone #{name} was not found at #{@path}" unless File.exist? @path

        transitions
      end

      def data
        return @data if defined? @data

        @data = JSON.parse(File.read(@path))
      end

      def released_at
        return @released_at if defined? @released_at

        @released_at = Time.parse version_data['released_at']
      end

      def version_data
        return @version_data if defined? @version_data

        raise "Version #{@version} not found" unless (@version_data = data.dig('versions', @version))

        @version_data
      end

      def transitions
        return @transitions if defined? @transitions

        if version_data['alias']
          @transitions = TimezoneVersion.new(version_data['alias'], @version).transitions
        else
          @transitions = version_data['transitions']
          @transitions.each do |transition|
            transition['utc_time'] = Time.parse(transition['utc_time'])
          end
        end

        @transitions
      end

      def timestamps
        return @timestamps if defined? @timestamps

        @timestamps = [-Float::INFINITY]
        transitions.each do |transition|
          @timestamps << transition['utc_timestamp']
        end
        @timestamps << +Float::INFINITY

        @timestamps
      end

      def timezone_ranges
        return @timezone_ranges if defined? @timezone_ranges

        ini = -Float::INFINITY
        fin = +Float::INFINITY

        @timezone_ranges = transitions.map do |transition|
          { ini: ini, fin: (ini = transition['utc_timestamp']), off: transition['utc_prev_offset'] }
        end

        @timezone_ranges << { ini: @timezone_ranges.last[:fin], fin: fin, off: transitions.last['utc_offset'] } unless @timezone_ranges.empty?

        @timezone_ranges
      end

      def timezone_ranges_timed
        A0::TZMigration.timestamp_range_list!(Marshal.dump(timezone_ranges))
      end

      def delta_range_list(other) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        raise "No transitions for self #{@name}/#{@version}" if transitions.empty?
        raise "No transitions for other #{name}/#{version}" if other.transitions.empty?

        timestamp_list = (timestamps + other.timestamps).uniq.sort

        list_a = A0::TZMigration.split_range_list!(Marshal.load(Marshal.dump(timezone_ranges)), timestamp_list)
        list_b = A0::TZMigration.split_range_list!(Marshal.load(Marshal.dump(other.timezone_ranges)), timestamp_list)

        delta = []
        list_a.each_with_index do |range_a, index|
          range_b = list_b[index]

          delta << { ini: range_a[:ini], fin: range_a[:fin], off: range_b[:off] - range_a[:off] } if range_a[:off] != range_b[:off]
        end

        A0::TZMigration.timestamp_range_list!(A0::TZMigration.compact_range_list!(delta))
      end
    end
  end
end
