

module GrasperHelper


  module Parse
    def parse
      html = open(@url).read

      # correct the encoding
      html.force_encoding("gbk")
      html.encode!("utf-8")

      # parse the html with nokogiri
      Nokogiri::HTML.parse html
    end
  end

  class Post
    attr_reader :content, :author

    def initialize post, selector = {}
      # selector only for cl.man.lv
      selector[:author_selector]  ||= 'tr.tr1 th.r_two b'
      selector[:content_selector] ||= 'div.tpc_content'
      @post = post
      get_author selector[:author_selector]
      get_content selector[:content_selector]
    end

    def get_author author_selector
      @author = @post.css(author_selector)[0].text
    end

    def get_content content_selector
      @content = @post.css(content_selector).text
      @content.gsub!(/\s+|　/,"\n")
    end
  end

  class Page
    attr_reader :url, :posts, :doc

    include Parse

    def initialize url, selector = {}
      selector[:post_selector] ||= 'div.t.t2'
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
    attr_reader :url, :author, :pages_url, :pages, :author_posts

    include Parse

    def initialize url, option = {}
      option[:author_selector] ||= 'tr.tr1 th.r_two b'
      option[:page_selector]   ||= 'div.pages a'
      option[:parse_pages]     ||= 0..1
      @url   = url
      puts "url initialized"
      puts "parsing first page..."
      @doc   = self.parse
      @pages_url = []
      get_author    option[:author_selector]
      get_pages_url option[:page_selector]
      parse_pages   option[:parse_pages]
      get_author_posts
    end

    def get_author author_selector
      @author ||= @doc.css(author_selector)[0].text
    end

    def get_pages_url page_selector
      # add url of the first page
      @pages_url << url

      # only for cl.man.lv
      # => "read.php?tid=1063468&page=194" 
      max_page_url = @doc.css('div.pages a').last.attributes['href'].value.
                     gsub('../','') 
                     
      max_page = max_page_url.match(/\d+$/).to_s.to_i # => 194

      (2..max_page).each do |i|
        @pages_url << url.match(/.*\.[a-zA-z]+\//).to_s + # http://example.com/
                      max_page_url.sub(/\d+$/,i.to_s)
      end
    end

    def parse_pages range = 0
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


