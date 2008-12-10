module Jekyll

  class Page
    include Convertible
    
    attr_accessor :ext
    attr_accessor :data, :content, :output
    
    # Initialize a new Page.
    #   +base+ is the String path to the <source>
    #   +dir+ is the String path between <source> and the file
    #   +name+ is the String filename of the file
    #
    # Returns <Page>
    def initialize(base, dir, name, site)
      @base = base
      @dir  = dir
      @name = name
      @site = site
      
      self.data = {}
      
      self.process(name)
      self.read_yaml(File.join(base, dir), name)
      #self.transform
    end
    
    # Extract information from the page filename
    #   +name+ is the String filename of the page file
    #
    # Returns nothing
    def process(name)
      self.ext = File.extname(name)
    end
    
    # Prepare this page's payload and transform it
    #   +do_layout+ is defined in Convertible
    #
    # Returns nothing
    def render
      do_layout({"page" => self.data}, @site.layouts, @site.site_payload)
    end
    
    # Write the generated page file to the destination directory.
    #   +dest+ is the String path to the destination dir
    #
    # Returns nothing
    def write(dest)
      FileUtils.mkdir_p(File.join(dest, @dir))
      
      name = @name
      if self.ext != ""
        name = @name.split(".")[0..-2].join('.') + self.ext
      end
      
      path = File.join(dest, @dir, name)
      File.open(path, 'w') do |f|
        f.write(self.output)
      end
    end
  end

end
