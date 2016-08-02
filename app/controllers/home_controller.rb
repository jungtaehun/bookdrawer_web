require 'net/http'
require 'nokogiri'
require "uri"
require "json"

class HomeController < ApplicationController
  def index
    @drawer_novel = Book.where(type: 1).order("id desc")
    @drawer_poet = Book.where(type: 2).order("id desc")
  end

  def create
    book = Book.new
    book.title = params[:title]
    book.author = params[:author]
    book.writer = params[:writer]
    book.content = params[:content]

    uploader = BookUploader.new
    uploader.store!(params[:pic])

    if @ming == ""
      book.img = uploader.url
    else
      book.img = @ming
    end



    if book.save
      redirect_to "/home/index"
    else
      render :text => post.errors.messages[:title].first
    end
  end

  def search
    title = params[:title]

    tmp = "https://openapi.naver.com/v1/search/book.xml?query=#{title}"


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
    @mauthor = xml_doc.xpath("//author")
    # [0].inner_text
    @mimg = xml_doc.xpath("//image")
    # [0].inner_text

    
  end

  def delete
  end

  def edit
  end
end
