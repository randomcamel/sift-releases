#!/usr/bin/env ruby

require "date"
require "json"
require "pp"
require "pry"

# curl 'https://api.github.com/repos/hashicorp/terraform/releases?per_page=400' > releases.json

class Release < Gem::Version
  attr_accessor :date, :git_tag, :last_major, :last_minor

  def initialize(github_release_data)
    @git_tag = github_release_data["tag_name"]
    version_string = git_tag.sub(/^v/, '')
    super(version_string)

    @date = Date.parse(github_release_data["published_at"].sub(/T.*/, ''))
  end

  def major;   segments[0]; end
  def minor; segments[1]; end
  def patch;   segments[2]; end

  def stringify (release_hash)
    release_hash[:version] = release_hash[:version].to_s
    release_hash
  end

  def to_s
    { class: self.class, date: date.to_s, git_tag: git_tag }.to_s
  end
end

data = JSON.load(File.new("releases.json"))
last_major = nil
last_patch = nil

releases = data.map { |rel|
      Release.new(rel)
    }.sort { |a, b| a.date <=> b.date }

releases.each do |rel, i|
  if i == 0
    last_minor = rel
    last_patch = rel
    next
  end

  if releases[i].minor != releases[i-1].minor
  end

end

    # .map { |v| stringify(v) }
# binding.pry
# p releases
releases.each { |o| puts o }
