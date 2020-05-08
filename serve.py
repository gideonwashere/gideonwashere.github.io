#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Python script to act as test server for wiki page"""

import http.server
import socketserver

PORT = 9001
HANDLER = http.server.SimpleHTTPRequestHandler

def main():
    with socketserver.TCPServer(("", PORT), HANDLER) as httpd:
        print("serving at port", PORT)
        httpd.serve_forever()

if __name__ == "__main__":
    main()
