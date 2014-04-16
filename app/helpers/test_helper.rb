module TestHelper
  def test
    'test'
  end

  module Parse
    def parse
      @url + '!!!'
    end
  end

  class Post
    attr_reader :url
    include Parse

    def initialize selector = {}
      # selector only for cl.man.lv
      @url = 'haha'
      @url = parse
    end
  end

end
