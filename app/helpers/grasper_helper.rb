module GrasperHelper

  module Parse
    def parse
      html = open(@url).read

      # correct the encoding (only for some websites)
      # html.force_encoding("gbk")
      # html.encode!("utf-8")

      # parse the html with nokogiri
      Nokogiri::HTML.parse html
    end

  end

  class Post
    attr_reader :content, :author, :post

    def initialize post, selector = {}

      selector[:author_selector]  ||= 'a'
      selector[:content_selector] ||= 'p'
      @post = post
      get_author selector[:author_selector]
      get_content selector[:content_selector]
    end

    def get_author author_selector
      @author ||= @post.css(author_selector)[0].text
    end

    def get_content content_selector
      # replace <br> with \n
      @post.css(content_selector).css('br').each { |br| br.replace "\n" }
      @content = @post.css(content_selector).text
      @content.gsub!(/\r?\n+\s*/,"\n\n")
    end
  end

  class Page
    attr_reader :url, :posts, :doc

    include Parse

    def initialize url, selector = {}
      selector[:post_selector] ||= 
        'div.topic-doc, ul#comments.topic-reply div.reply-doc.content'
      @url = url
      puts "parsing #{@url}"
      @doc = self.parse
      get_posts selector[:post_selector]
    end

    def get_posts post_selector
      @posts ||= @doc.css(post_selector).collect { |post| Post.new post }
    end

  end

  class Topic
    attr_reader :url, :title, :author, :pages_url, :pages, :author_posts, :doc

    include Parse

    def initialize url, option = {}
      option[:author_selector] ||= 'div.topic-doc a'
      option[:page_selector]   ||= 'div.paginator>a'
      option[:parse_pages]     ||= 0..-1
      @url   = url
      puts "url initialized"
      puts "parsing first page..."
      @doc   = self.parse
      @pages_url = []
      get_title
      get_author    option[:author_selector]
      get_pages_url option[:page_selector]
      parse_pages   option[:parse_pages]
      get_author_posts
    end

    def get_title
      if @doc.css('td.tablecc').empty?
        @title = @doc.css('title').text
      else
        @title = @doc.css('td.tablecc').children.last.text
      end
      # replace spaces at the beginning and ending
      @title.gsub!(/^\s+|\s+$/,"") 
    end

    def get_author author_selector
      @author ||= @doc.css(author_selector)[0].text
    end

    def get_pages_url page_selector

      @pages_url << url

      unless @doc.css(page_selector).empty? # when it is not a single page

        # example:
        # <a href="http://www.douban.com/group/topic/18524871/?start=12400">125</a>
        max_page = @doc.css(page_selector).last.text.to_i 
        # => 125 

        (1..max_page - 1).each do |i| # 1..124
          @pages_url << url+"?start=#{i}00"
        end
      end
    end

    def parse_pages range
      @pages ||= pages_url[range].collect { |page_url| Page.new page_url }
    end

    def get_author_posts
      @author_posts = []
      @pages.each do |page|
        page.posts.each do |post|
          @author_posts << post.content if post.author == @author
        end
      end
    end
  end


end


