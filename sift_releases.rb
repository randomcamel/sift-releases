#!/usr/bin/env ruby
require "pp"
require "json"

# curl 'https://api.github.com/repos/hashicorp/terraform/releases?per_page=400' > releases.json

def stringify(release_hash)
  release_hash[:version] = release_hash[:version].to_s
  release_hash
end

data = JSON.load(File.new("releases.json"))
output = data.map { |rel|
          version_obj = Gem::Version.create( rel["tag_name"].sub(/^v/, '') )
          {
            version: version_obj,
            date: rel["published_at"].sub(/T.*/, '')
          }
    }.sort { |a, b| a[:version] <=> b[:version] }.map { |v| stringify(v) }

pp output
