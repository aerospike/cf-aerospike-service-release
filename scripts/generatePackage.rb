#!/usr/bin/env ruby

require 'erb'

file_name = ARGV[0]
ERB_TEMPLATE_FILE = ARGV[1]

simple_template = File.read("#{ERB_TEMPLATE_FILE}")

renderer = ERB.new(simple_template)
puts output = renderer.result()