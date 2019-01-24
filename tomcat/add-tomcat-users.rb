#!/usr/bin/env ruby

# $ ./add-tomcat-users.eb <source> <target> tomcat-users.yml

require 'yaml'
require 'nokogiri'

origin = ARGV[0]
target = ARGV[1]
data = ARGV[2]

# Parsing origin 'tomcat-users.xml' file
f = File.open(origin)
@doc = Nokogiri::XML(f) {|config| config.noblanks}
f.close

# Parsing users data file
f = File.open(data)
@users_hash = YAML.load(f)
f.close

# Fetch hole roles
@roles_array = @users_hash.map {|el| el.fetch("roles")}.flatten

@doc.xpath('//xmlns:tomcat-users').each do |users|
  # add role nodes
  @roles_array.each do |r|
    role = Nokogiri::XML::Node.new "role", @doc
    role["rolename"] = r
    users.add_child(role)
  end

  # add user nodes
  @users_hash.each do |u|
    user = Nokogiri::XML::Node.new "user", @doc
    u.each {|key, value| user[key] = ((value.is_a? Array) ? value.join(",") : value)}
    users.add_child(user)
  end
end

f = File.open(target, 'w')
f.puts @doc.to_xml(:indent => 2, :encoding => 'UTF-8')
f.close
