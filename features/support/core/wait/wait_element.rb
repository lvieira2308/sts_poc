module WaitElement
  def wait_el(locator, element_id)
    wait_elements { $driver.find_element(locator, element_id) }
  end

  def wait_displayed_el(locator, element_id)
    wait_elements { $driver.find_element(locator, element_id).displayed? }
  end

  def wait_el_list(locator, element_id)
    wait_elements { $driver.find_elements(locator, element_id).size > 0 }
  end

  def wait_child_el(element_father, locator, element_id)
    wait_elements { element_father.find_element(locator, element_id).displayed? }
  end

  def wait_child_elements(element_father, locator, element_id)
    wait_elements { element_father.find_elements(locator, element_id).size > 0 }
  end

  private
  def wait_elements
    options = {}
    options[:timeout] = 5
    options[:interval] = 1
    wait = Selenium::WebDriver::Wait.new(options)
    tries = 0

    begin
      response = wait.until { yield }
    rescue StandardError
      if tries < 2
        tries += 1
        sleep 1
        retry
      else
        response = false
      end
    end
    response.nil? ? false : response
  end
end
