"""
Simple python webserver
"""

import sys
import os
from http.server import HTTPServer, CGIHTTPRequestHandler

webdir = '.'	# where your html files and cgi-bin script directory live
port = 80		# default http://localhost/, else use http://localhost:xxxx/

os.chdir(webdir)
srvraddr = ("", port)						# my hostname, portnumber
srvrobj = HTTPServer(srvraddr, CGIHTTPRequestHandler)
srvrobj.serve_forever()						# run as perpetual daemon