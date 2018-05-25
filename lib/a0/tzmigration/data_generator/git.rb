# frozen_string_literal: true

require 'git'

module A0
  module TZMigration
    class DataGenerator
      def repo
        return @repo if defined? @repo

        File.exist?(@path) ? repo_update : repo_clone
      end

      def repo_update
        puts "Updating #{@url} repo at #{@path}"

        @repo = Git.open @path
        @repo.pull

        @repo
      end

      def repo_clone
        puts "Cloning #{@url} repo at #{@path}"

        @repo = Git.clone @url, @path
      end

      def repo_use(tag)
        tag_path = File.join(@out, 'repo', tag)
        lib_path = File.join(tag_path, 'lib')
        $LOAD_PATH.unshift File.expand_path(lib_path)

        return if File.exist? lib_path

        FileUtils.rm_rf tag_path
        FileUtils.copy_entry @path, tag_path

        tag_repo = Git.open tag_path
        tag_repo.checkout tag
      end
    end
  end
end
