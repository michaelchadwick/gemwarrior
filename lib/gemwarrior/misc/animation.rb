# lib/gemwarrior/misc/animation.rb
# Animation routine using matrext

module Gemwarrior
  module Animation
    def self.run(opts)
      options = {
        oneline:    false, 
        speed:      nil, 
        alpha:      true, 
        numeric:    true, 
        random:     true,
        color:      nil,
        background: nil
      }.merge(opts)

      th = Thread.new do
        print Matrext.process({
          phrase:     options.fetch(:phrase),
          oneline:    options.fetch(:oneline),
          speed:      options.fetch(:speed),
          alpha:      options.fetch(:alpha),
          numeric:    options.fetch(:numeric),
          random:     options.fetch(:random),
          color:      options.fetch(:color),
          background: options.fetch(:background)
        })
      end

      return th.join
    end
  end
end
