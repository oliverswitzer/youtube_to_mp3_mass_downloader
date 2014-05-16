require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'rack'
require 'pry'
 
Capybara.run_server = false
Capybara.current_driver = :selenium
Capybara.app_host = "http://www.youtube-mp3.org/"

module Spider 
  class YoutubeConverter
    include Capybara::DSL

    attr_accessor :input, :youtube_urls

    def initialize 
      @youtube_urls = ARGV
      @input = 'youtube-url'
    end 

    def visit_page
      visit('/')
    end

    def clear_input
      fill_in(input, with: "")
    end

    def convert_youtube_link(link)
      fill_in(input, :with => link )
      click_button "Convert Video"
      puts "Converting Video" 
    end

    def download
      sleep 2
      click_link('Download')
      sleep 5
    end

    def download_links
      visit_page
      clear_input
      youtube_urls.each do |url|
        convert_youtube_link(url)
        download
      end
      sleep 20
    end
  end
end
 
spider = Spider::YoutubeConverter.new
spider.download_links