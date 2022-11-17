module Finder
  def find_el(element_name)
    log_info("Searching for the element #{element_name}")
    discover(element_name)
    r = retry_finder(element_name) { wait_el(@locator, @element_id)}
    r == false ? find_error(element_name) : $driver.find_element(@locator, @element_id)
  end

  def fast_find_el(element_name)
    log_info("Searching for the element #{element_name}")
    discover(element_name)
    fast_finder(element_name, @locator, @element_id)
  end

  def find_all_el(element_name)
    log_info("Searching for one or more elements: #{element_name}")
    discover(element_name)
    r = retry_finder(element_name) { wait_el_list(@locator, @element_id) }
    r == false ? find_error(element_name) : $driver.find_elements(@locator, @element_id)
  end

  def find_child_el(element_father, child_element_name)
    log_info("Searching for the child element: #{child_element_name}")
    discover(child_element_name)
    r = retry_finder(child_element_name) { wait_child_el(element_father, @locator, @element_id) }
    r == false ? find_error(element_name) : r.find_element(@locator, @element_id)
  end

  def find_child_elements(element_father, child_element_name)
    log_info("Searching for the child element: #{child_element_name}")
    discover(child_element_name)
    r = retry_finder(child_element_name) { wait_child_elements(element_father, @locator, @element_id) }
    r == false ? find_error(element_name) : r.find_elements(@locator, @element_id)
  end

  private

  def find_error(element_name)
    expecting(false, true, "Element not found: #{element_name}. Locator: #{@locator}. Identifier: #{@element_id}")
  end

  def find_text_error(text, locator, id)
    expecting(false, true, "Text not found: #{text}. Locator: #{locator}. Identifier: #{id}")
  end
end