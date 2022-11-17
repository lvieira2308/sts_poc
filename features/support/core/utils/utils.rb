module Utils

  def go_to(path)
    $driver.navigate.to(path)
  end

  def go_to_home
    $driver.navigate.to(default_url)
  end

  def go_to_domain_path(path)
    $driver.navigate.to("#{default_url}#{path}")
  end

  def go_to_tab_when_it_opens(tab)
    6.times do
      begin
        go_to_tab(tab)
        break
      rescue StandardError
        sleep 2
      end
    end
  end

  def go_to_tab(tab_number, revert = false)
    windows = $driver.window_handles
    windows.reverse! if revert
    $driver.switch_to.window windows[tab_number - 1]
  end

  def OS_windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS_mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS_linux?
    OS.unix? and not OS.mac?
  end

  def get_clipboard
    Clipboard.paste
  end

end

