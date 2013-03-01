#!/usr/bin/ruby -w
# pt_demo.rb - PageTemplate demonstration script

require "PageTemplate"
require "cgi"

pt = PageTemplate.new
pt.load("pt_demo.tmpl")
pt["character_name"] = "Peregrine Pickle"
pt["character_role"] = "a young country gentleman"
pt["str_to_encode"] = "encoded text: (<>&'\" =;)"
pt["id"] = 47846
pt["colors"] = ["red","orange","yellow","green","blue","indigo","violet"]

cgi = CGI.new("html4")
cgi.out { pt.output }
