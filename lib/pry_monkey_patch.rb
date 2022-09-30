# solve a dependency issue of pry-byebug, see https://github.com/deivid-rodriguez/pry-byebug/issues/373

module PryByebug
  module Helpers
    module Breakpoints
      def text
        Pry::Helpers::Text
      end
    end
  end
end
