require 'fileutils'
require 'multi_json'

module IRails
  class Command
    def initialize(args)
      @args = args

      ipython_dir = ENV['IPYTHONDIR'] || '~/.ipython'
      @args.each do |arg|
        ipython_dir = $1 if arg =~ /\A--ipython-dir=(.*)\Z/
      end
      @kernel_dir = File.join(File.expand_path(ipython_dir), 'kernels', 'rails')
      @kernel_file = File.join(@kernel_dir, 'kernel.json')
      @irails_path = File.expand_path $0
    end

    def run
      case @args.first
      when 'version', '-v', '--version'
        require 'irails/version'
        puts "IRails #{IRails::VERSION}, Rails #{Rails.version}"
      when 'help', '-h', '--help'
        print_help
      when 'register'
        if registered_irails_path && !@args.include?('--force')
          STDERR.puts "#{@kernel_file} already exists!\nUse --force to force a register."
          exit 1
        end
        register_kernel
      when 'unregister'
        unregister_kernel
      when 'kernel'
        run_kernel
      else
        run_ipython
      end
    end

    private

    def print_help
      puts %{
Usage:
    irails register        Register IRails kernel in #{@kernel_file}.
    irails unregister      Unregister IRails kernel.
    irails console         Launch the IRails terminal-based console.
    irails notebook        Launch the IRails HTML notebook server.
    ...                   Same as IPython.

Please note that IRails accepts the same parameters as IPython.
Try `ipython help` for more information.
}
    end

    def run_kernel
      require 'irails/logger'
      IRails.logger = MultiLogger.new(*Logger.new(STDOUT))
      @args.reject! {|arg| arg =~ /\A--log=(.*)\Z/ && IRails.logger.loggers << Logger.new($1) }
      IRails.logger.level = @args.delete('--debug') ? Logger::DEBUG : Logger::INFO

      raise(ArgumentError, 'Not enough arguments to the kernel') if @args.size < 2 || @args.size > 4
      config_file, boot_file, working_dir = @args[1..-1]
      Dir.chdir(working_dir) if working_dir

      require boot_file if boot_file
      check_bundler {|e| IRails.logger.warn "Could not load bundler: #{e.message}\n#{e.backtrace.join("\n")}" }

      require 'irails'
      Kernel.new(config_file).run
    rescue Exception => e
      IRails.logger.fatal "Kernel died: #{e.message}\n#{e.backtrace.join("\n")}"
      raise
    end

    def check_version
      required = '3.0.0'
      version = `ipython --version`.chomp
      if version < required
        STDERR.puts "Your IPython version #{version} is too old, at least #{required} is required"
        exit 1
      end
    end

    def run_ipython
      # If no command is given, we use the console to launch the whole 0MQ-client-server stack
      @args = %w(console) + @args if @args.first.to_s !~ /\A\w/
      @args += %w(--kernel ruby) if %w(console qtconsole).include? @args.first

      check_version
      check_registered_kernel
      check_bundler {|e| STDERR.puts "Could not load bundler: #{e.message}" }

      Kernel.exec('ipython', *@args)
    end

    def check_registered_kernel
      if kernel = registered_irails_path
        STDERR.puts "#{@irails_path} differs from registered path #{registered_irails_path}.
This might not work. Run 'irails register --force' to fix it." if @irails_path != kernel
      else
        register_kernel
      end
    end

    def check_bundler
      require 'bundler'
      raise %q{irails is missing from Gemfile. This might not work.
Add `gem 'irails'` to your Gemfile to fix it.} unless Bundler.definition.dependencies.any? {|s| s.name == 'irails' }
      Bundler.setup
    rescue LoadError
    rescue Exception => e
      yield(e)
    end

    def register_kernel
      FileUtils.mkpath(@kernel_dir)
      File.write(@kernel_file, MultiJson.dump(argv: [ @irails_path, 'kernel', '{connection_file}' ],
                                              display_name: "Rails #{Rails.version}", language: 'ruby'))
      FileUtils.copy(Dir[File.join(__dir__, 'assets', '*')], @kernel_dir) rescue nil
    end

    def registered_irails_path
      File.exist?(@kernel_file) && MultiJson.load(File.read(@kernel_file))['argv'].first
    end

    def unregister_kernel
      FileUtils.rm_rf(@kernel_dir)
    end
  end
end
