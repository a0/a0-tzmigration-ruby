# frozen_string_literal: true

module A0
  module TZMigration
    class TZVersion
      def self.versions
        @versions = Util.load_from_network_or_file('versions/00-index.json')['versions']
      end

      def self.timezones
        @timezones = Util.load_from_network_or_file('timezones/00-index.json')['timezones']
      end

      attr_reader :name, :version

      def initialize(name, version)
        @name = name
        @version = version
      end

      def data
        return @data if defined? @data

        @data = Util.load_from_network_or_file("timezones/#{name}.json")
      end

      def version_data
        return @version_data if defined? @version_data

        raise "Version #{@version} not found for #{@name}." unless (@version_data = data.dig('versions', @version))

        if @version_data['alias']
          @link = TZVersion.new(@version_data['alias'], @version)
          @version_data = @link.version_data
        end

        @version_data
      end

      def released_at
        return @released_at if defined? @released_at

        @released_at = version_data['released_at']
      end

      def transitions
        return @transitions if defined? @transitions

        if version_data['alias']
          @transitions = TZVersion.new(version_data['alias'], @version).transitions
        else
          @transitions = version_data['transitions']
          @transitions.each do |transition|
            transition['utc_time'] = Time.parse(transition['utc_time'])
          end
        end

        @transitions
      end

      def transition_ranges # rubocop:disable Metrics/AbcSize
        return @transition_ranges if defined? @transition_ranges

        ini = -Float::INFINITY
        fin = +Float::INFINITY

        @transition_ranges = transitions.map do |transition|
          Util.range_item(ini, (ini = transition['utc_timestamp']), transition['utc_prev_offset'])
        end

        @transition_ranges << Util.range_item(@transition_ranges.last[:fin], fin, transitions.last['utc_offset']) unless @transition_ranges.empty?

        @transition_ranges
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

      def changes(other) # rubocop:disable Metrics/AbcSize
        # raise "No transitions for self #{@name}/#{@version}" if transitions.empty?
        # raise "No transitions for other #{name}/#{version}" if other.transitions.empty?

        timestamp_list = (timestamps + other.timestamps).uniq.sort

        list_a = Util.split_range_list(transition_ranges, timestamp_list)
        list_b = Util.split_range_list(other.transition_ranges, timestamp_list)

        changes = []
        list_a.each_with_index do |range_a, index|
          range_b = list_b[index]

          changes << Util.range_item(range_a[:ini], range_a[:fin], range_b[:off] - range_a[:off]) if range_a[:off] != range_b[:off]
        end

        Util.compact_range_list!(changes)
      end
    end
  end
end
