require "mini_magick"

module Screenshot
  def screenshot_define_name(scenario)
    $file_path = File.path("reports/evidences/#{scenario}/#{Time.now.strftime('%dd_%mm_%Yy_%HH_%MM_%SS')}")
    FileUtils.mkdir_p($file_path) unless File.exist?($file_path)
  end

  def scenario_print(name)
    $driver.switch_to.default_content rescue StandardError
    path = "#{$file_path}/#{name}_#{Time.now.strftime('%MM_%SS')}.png"
    $driver.save_screenshot(path)
    image = File.open(path, 'rb', &:read)
    Base64.encode64(image)
    path
  end

end
