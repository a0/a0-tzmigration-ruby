# frozen_string_literal: true

module A0
  module TZMigration
    DefaultConfig = Struct.new(:base_url, :data_dir) do
      def initialize
        self.base_url = 'https://a0.github.io/a0-tzmigration-ruby/data/'
        self.data_dir = File.expand_path File.join(__dir__, '..', '..', '..', 'data')
      end
    end

    def self.configure
      @config = DefaultConfig.new
      yield(@config) if block_given?
      @config
    end

    def self.config
      @config || configure
    end
  end
end
