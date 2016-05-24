require 'net/http'
require 'nokogiri'
require "uri"
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
    search = Search.new
    search.title = params[:title]
    search.author = params[:author]
    search.isbn = params[:isbn]

    tmp = "https://openapi.naver.com/v1/search/book_adv.xml?query=#{search.title}"

    unless search.author.nil?
      tmp << "?d_auth=#{search.author}"
    end

    unless search.isbn.nil?
      tmp << "?d_auth=#{search.isbn}"
    end

    uri = URI(URI.encode(tmp))

    req = Net::HTTP::Get.new(uri)
    req['X-Naver-Client-Id'] = "DZaaw4YVOevidOL4rL06"
    req['X-Naver-Client-Secret'] = "AgZIyTdxqI"

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
      http.request(req)
    }

    xml_doc = Nokogiri::XML(res.body)
    @mtitle = xml_doc.xpath("//title").inner_text
    @mauthor = xml_doc.xpath("//author").inner_text
    @mimg = xml_doc.xpath("//image").inner_text

    
  end

  def delete
  end

  def edit
  end
end
