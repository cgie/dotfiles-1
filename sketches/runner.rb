module Bin

  # The Bin runner expects to be initialized with `ARGV` and primarily
  # exists to run on a file.
  #
  class Runner
    attr_reader :args
    
    def initialize(*args)
      @args = Args.new(args)
    end
    
    def execute
      p @args.inspect
    end
    
end


module Bin
  # The Args class exists to make it more convenient to work with
  # command line arguments.
  #
  # The ARGV array is converted into an Args instance by the Bin
  # instance when instantiated.
  class Args < Array
    attr_accessor :executable
    attr_reader :original_ars

    def initialize(executable=nil, *args)
      super
      @executable = executable
      @original_args = args
    end

  end # Args
  
end # Bin

__END__

#!/usr/bin/env ruby
# executable file
#
# bin(1)

require 'bin'
Bin::Runner.execute(*ARGV)