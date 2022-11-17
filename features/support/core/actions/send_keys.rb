module WebActions
  def send_keys_el(element, value)
    retry_action do
      perform_keys(element, find_el(element), value)
    end
  end

  def copy_and_paste(element)
    copy_keys(element)
    paste_keys(element)
  end

  def copy_keys(element)
    symbol = OS_mac? ? :command : :control
    element = find_el(element)
    element.send_keys([symbol, 'a'])
    element.send_keys([symbol, 'c'])
  end

  def paste_keys(element)
    symbol = OS_mac? ? :command : :control
    element = find_el(element)
    element.send_keys([symbol, 'v'])
  end

  def clear_el(element)
    retry_action do
      perform_clear(element, find_el(element))
    end
  end

  def clear_and_send_keys_el(element, value)
    retry_action do
      send_keys_el(element,value)
      clear_el(element)
    end
  end


  private

  def perform_keys(element_name, element, value)
    log_info("Sending text to the element: #{element_name}. Locator: #{@locator}, ID: #{@element_id}")
    begin
      element.send_keys(value)
    rescue StandardError
      sleep 2
      element.send_keys(value)
    end

  end

  def perform_clear(element_name, element)
    log_info("Clearing the text of the element: #{element_name}. Locator: #{@locator}, ID: #{@element_id}")
    begin
      element.clear
    rescue StandardError
      sleep 2
      element.clear
    end
  end

end