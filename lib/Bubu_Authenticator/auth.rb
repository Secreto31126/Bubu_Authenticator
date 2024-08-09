# frozen_string_literal: false

require "rotp"

# Makes the Auth proccess
module Auth
  def self.get_2fa(name, key)
    code = ROTP::TOTP.new(key).now.chomp.strip
    puts "\nYour code is: #{code}\nCopying #{name} 2FA to clipboard..."
    copy_to_clipboard(code)
    puts "Done!"
  end
end

def copy_to_clipboard(code)
  case RUBY_PLATFORM
  when /cygwin|mswin|mingw|bccwin|wince|emx/
    `echo #{code} | clip`
  when "linux"
    `xclip -selection c #{code}`
  when "darwin"
    `pbcopy #{code}`
  else
    puts "Unsupported OS, please copy manually"
  end
end
