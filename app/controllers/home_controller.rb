require 'net/http'
require 'nokogiri'
require "uri"
require "json"

class HomeController < ApplicationController
  def index
    @drawer_novel = Book.order("id desc")
    # @drawer_poet = Book.where(type: 2).order("id desc")
  end

  def create
    t = params[:chk_select].to_i
    s_title = params[:search_title]

    book = Book.new

    tmp = "https://openapi.naver.com/v1/search/book.xml?query=#{s_title}"


    uri = URI(URI.encode(tmp))

    req = Net::HTTP::Get.new(uri)
    req['X-Naver-Client-Id'] = "H3P1aWrhf8qHA_Z97EZU"
    req['X-Naver-Client-Secret'] = "4IGa91_4SG"

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
      http.request(req)
    }


    xml_doc = Nokogiri::XML(res.body)

    book.title = xml_doc.xpath("//item //title")[t].inner_text.delete('<b>').delete('</b>')

    book.author = xml_doc.xpath("//item //author")[t].inner_text
    book.writer = "test"
    book.content = "테스트 콘텐츠"
    book.description = xml_doc.xpath("//item //description")[t].inner_text.delete('<b>').delete('</b>')


    if xml_doc.xpath("//item //image")[t].inner_text == ""
      book.img = "http://3.bp.blogspot.com/-gIbY-Tqv34I/Tdm2v0h_brI/AAAAAAAAAkw/l7_ZNQQ0HiU/s1600/null.gif"
    else
      book.img = xml_doc.xpath("//item //image")[t].inner_text
    end


    if book.save
      redirect_to "/home/index"
    else
      render :text => post.errors.messages[:title].first
    end
  end

  def search
    @title = params[:title]

    tmp = "https://openapi.naver.com/v1/search/book.xml?query=#{@title}"


    uri = URI(URI.encode(tmp))

    req = Net::HTTP::Get.new(uri)
    req['X-Naver-Client-Id'] = "H3P1aWrhf8qHA_Z97EZU"
    req['X-Naver-Client-Secret'] = "4IGa91_4SG"

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
      http.request(req)
    }


    xml_doc = Nokogiri::XML(res.body)
    @dtest = xml_doc.xpath("//item")

    @mtitle = xml_doc.xpath("//item //title")
    # [0].inner_text.delete('<b>').delete('</b>')
    @mauthor = xml_doc.xpath("//item //author")
    # [0].inner_text
    @mimg = xml_doc.xpath("//image")
    # [0].inner_text

    
  end

  def delete
  end

  def edit
  end
end
