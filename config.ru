#!/usr/bin/env ruby
require 'gollum/app'
require 'omnigollum'
require 'omniauth-github'
require 'omniauth-twitter'

OmniAuth.config.full_host = 'uri'

gollum_path = '/var/lib/gollum/wiki'

wiki_options = {
  universal_toc: false,
  mathjax: false,
  live_preview: true
}

omnigollum_options = {
  providers: Proc.new do
    provider :github, 'key', 'secret', scope: 'user',
    provider :twitter, 'key', 'secret'
  end,
  dummy_auth: false
}

Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:default_markup, :markdown)
Precious::App.set(:wiki_options, wiki_options)
Precious::App.set(:environment, :production)
Precious::App.set(:omnigollum, omnigollum_options)
Precious::App.register(Omnigollum::Sinatra)
run Precious::App
