# frozen_string_literal: true

require 'time'
require 'fasten'
require 'parallel'

module A0
  module TZMigration
    class DataGenerator
      def generate
        load_release_dates

        generate_versions
        generate_timezones

        save_versions
        save_versions_index
        save_timezones
        save_timezones_index
        save_index
      end

      def generate_versions
        tags = repo.tags.map(&:name)

        @versions = Fasten.map(tags, name: 'a0-tzmigration-ruby-data') do |tag|
          process_tag tag
        end

        @versions.sort_by! { |version_data| version_data[:version] }
      end

      def generate_timezones
        @timezones = {}
        @versions.each do |version_data|
          version_data[:timezones].each do |name, timezone_data|
            @timezones[name] ||= { name: name, versions: {} }
            @timezones[name][:versions][version_data[:version]] = { tag: version_data[:tag], released_at: version_data[:released_at] }.merge timezone_data
          end
        end

        @timezones = @timezones.to_a.sort_by(&:first).to_h
      end

      def load_release_dates
        @released_at = {}

        File.open(File.join(@path, 'data', 'NEWS')).each_line do |line|
          next unless line.start_with? 'Release '

          release, time = line.split(' - ')
          version = release.split.last
          next unless time

          @released_at[version] = Time.parse(time)
        end
      end

      def process_tag(tag)
        repo_use tag

        tzinfo_unload
        tzinfo_load

        process tag
      end

      def process(tag)
        version = TZInfo::Data::Version::TZDATA
        timezones = {}
        meta = { tag: tag, version: version, released_at: @released_at[version], timezones: timezones }

        TZInfo::Timezone.all.each do |timezone|
          process_timezone timezones, timezone.send(:real_timezone)
        end

        meta
      end

      def process_timezone(timezones, real_timezone)
        name = real_timezone.name
        canonical_name = real_timezone.canonical_identifier

        if name == canonical_name
          transitions = real_timezone.send(:info).instance_variable_get(:@transitions)&.map do |transition|
            data_from_transition(transition)
          end
          timezones[name] = { transitions: transitions }
        else
          timezones[name] = { alias: canonical_name }
        end
      end

      def data_from_transition(transition)
        offset = transition.offset
        previous_offset = transition.previous_offset

        { utc_offset: offset.utc_total_offset,
          utc_prev_offset: previous_offset.utc_total_offset,
          utc_timestamp: transition.time.to_i,
          utc_time: transition.datetime,
          local_ini_str: transition.local_end_time.strftime("%F %T #{previous_offset.abbreviation}"),
          local_fin_str: transition.local_start_time.strftime("%F %T #{offset.abbreviation}") }
      end
    end
  end
end
