# -*- coding: utf-8 -*-

require "sinkan_net_cli/version"

module SinkanNetCli
  require 'rubygems'
  require 'mechanize'
  require 'pry'

  exit if ARGV.empty?

  a = Mechanize.new do |agent|
    agent.user_agent_alias = 'Mac Safari'
  end

  top = a.get('http://sinkan.net/')
  login = top.links.find {|link|link.text == "ログイン"}.click

  mypage = login.form_with(:action => 'index.php') do |f|
    f.email = ENV["SHINKAN_NET_USER"]
    f.password = ENV["SHINKAN_NET_PASS"]
  end.click_button

  keyword_controles = mypage.link_with(text: "キーワードの管理").click
  music = keyword_controles.links.find {|link| link.href.index("?store=5&")}.click

  form = music.forms[1]
  form.name_sei = ARGV[0]

  page = a.submit(form, form.button_with(value: "キーワードを追加"))
  page.link_with(text: "追加").click if page.link_with(text: "このキーワードを追加")

end
