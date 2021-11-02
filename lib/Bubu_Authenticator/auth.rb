# frozen_string_literal: false

require "rotp"

# Makes the Auth proccess
module Auth
  def self.get_2fa(name, key)
    code = ROTP::TOTP.new(key).now.chomp
    puts "\nYour code is: #{code}\nCopying #{name} 2FA to clipboard..."

    if RUBY_PLATFORM =~ /cygwin|mswin|mingw|bccwin|wince|emx/
      # If OS is windows, use clipboard
      `echo #{code} | clip`
    elsif RUBY_PLATFORM =~ "linux"
      # If OS is linux, use xclip
      `xclip -selection c #{code}`
    elsif RUBY_PLATFORM =~ "darwin"
      # If OS is mac, use pbcopy
      `pbcopy #{code}`
    else
      puts "Unsupported OS, please copy manually"
    end

    puts "Done!"
  end
end
