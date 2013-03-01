#!/usr/bin/ruby -w
# pt_hello.rb - simple PageTemplate script

require "PageTemplate"
require "cgi"

pt = PageTemplate.new
pt.load("pt_hello.tmpl")
pt["name"] = "world"
pt["addr"] = ENV["REMOTE_ADDR"] || "UNKNOWN"

cgi = CGI.new("html4")
cgi.out { pt.output }
