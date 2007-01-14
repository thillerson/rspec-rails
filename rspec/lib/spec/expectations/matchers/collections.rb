module Spec
  module Expectations
    module Matchers
      module Collections
        def have(n)
          Have.new(n)
        end
      
        def have_exactly(n)
          Have.new(n)
        end
      
        def have_at_least(n)
          Have.new(n, :at_least)
        end
      
        def have_at_most(n)
          Have.new(n, :at_most)
        end
      
        class Have
          def initialize(expected, relativity=:exactly)
            @expected = expected
            @relativity = relativity
          end
        
          def relativities
            @relativities ||= {
              :exactly => "",
              :at_least => "at least ",
              :at_most => "at most "
            }
          end
        
          def method_missing(sym, *args, &block)
            @sym = sym
            self
          end
        
          def met_by?(collection_owner)
            collection = collection_owner.send @sym
            @actual = collection.length if collection.respond_to?(:length)
            @actual = collection.size if collection.respond_to?(:size)
            return @actual >= @expected if @relativity == :at_least
            return @actual <= @expected if @relativity == :at_most
            return @actual == @expected
          end
        
          def failure_message
            "expected #{relativities[@relativity]}#{@expected} #{@sym}, got #{@actual}"
          end
        end
      end
    end
  end
end