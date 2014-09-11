#!/usr/bin/env ruby
require 'gollum/app'
require 'omnigollum'
require 'omniauth-github'

OmniAuth.config.full_host = ENV['WIKI_URL']

gollum_path = ENV['WIKI_REPOSITORY_PATH']

wiki_options = {
  universal_toc: false,
  mathjax: false,
  live_preview: false,
  user_icons: 'gravatar',
  show_all: true
}

omnigollum_options = {
  providers: Proc.new do
    provider :github, ENV['WIKI_GITHUB_CLIENT_ID'], ENV['WIKI_GITHUB_CLIENT_SECRET']
  end,
  dummy_auth: false
}

Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:default_markup, :markdown)
Precious::App.set(:wiki_options, wiki_options)
Precious::App.set(:omnigollum, omnigollum_options)
Precious::App.set(:protection, except: :http_origin)
Precious::App.register(Omnigollum::Sinatra)
run Precious::App
