require 'nokogiri'

file_name = ARGV[0]
file_extension = File.extname(file_name)
file_basename = File.basename(file_name, file_extension)

f = File.open(file_name)
@doc = Nokogiri::XML(f)
f.close

@doc.xpath('//xmlns:tomcat-users').each do |users|
  role = Nokogiri::XML::Node.new "role", @doc
  role["rolename"] = "manager-gui"

  puts role.to_xml
  users.add_child(role)

  user = Nokogiri::XML::Node.new "user", @doc
  user["username"] = "admin"
  user["password"] = "password"
  user["roles"] = "manager-gui,admin"
  users.add_child(user)
end

fixed = file_basename + "_fixed" + file_extension
f = File.open(fixed, 'w')
f.puts @doc.to_xml
f.close
