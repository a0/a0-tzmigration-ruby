# frozen_string_literal: true

require 'a0/tzmigrate/data_generator/git'
require 'a0/tzmigrate/data_generator/process'

module A0
  module TZMigrate
    class DataGenerator
      attr_reader :path, :out, :url, :versions

      def initialize(out, url: 'https://github.com/tzinfo/tzinfo-data.git')
        @out = out
        @url = url
        @path = File.join(@out, 'repo', 'tzinfo-data')

        FileUtils.mkdir_p @out

        repo
      end

      def tzinfo_load
        old_verbose = $VERBOSE
        $VERBOSE = nil

        require 'tzinfo'
        require 'tzinfo/data/indexes/countries'
        require 'tzinfo/data/indexes/timezones'
        require 'tzinfo/data'

        $VERBOSE = old_verbose
      end

      def tzinfo_unload
        $LOADED_FEATURES.delete_if { |x| x.include?('tzinfo') }
        Object.send(:remove_const, :TZInfo) if defined? TZInfo
      end
    end
  end
end
