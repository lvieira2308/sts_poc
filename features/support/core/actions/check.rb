module Finder
  def visible_el?(element_name)
    log_info("Checking if element #{element_name} is visible")
    retry_finder_visible(element_name) { wait_displayed_el(@locator, @element_id) }
  end

  def fast_visible_el?(element_name)
    log_info("Checking if element #{element_name} is visible")
    fast_find_el(element_name)
  end

  def fast_visible_el_times(element_name, times)
    log_info("Checking if element #{element_name} is visible")
    bool = false

    times.times do
      bool = fast_find_el(element_name)
      break if bool

    end
    bool
  end



  def wait_visible_el(element_name, times)
    bool = false
    times.times do
      bool = visible_el? element_name
      break if bool
    end
    bool
  end

  def wait_disappear_el(element_name, tries)
    (1..tries).each do
      if fast_visible_el?(element_name)
        sleep(0.5)
      else
        break
      end
    end
  end

  def visible_child_el?(element_father, element_child_name)
    log_info("Checking if element #{element_child_name} is visible")
    response = retry_finder_visible(element_child_name) { wait_child_el(element_father, @locator, @element_id) }
    response ? true : false
  end

  def visible_el_list?(element_name)
    log_info("Checking if one or more elements are visible: #{element_name}")
    response = retry_finder_visible(element_name) { wait_displayed_el(@locator, @element_id) }
    response.nil? ? false : true
  end

  def get_text_position(element, position)
    find_all_el(element)[position].text
  end

  def get_text(element)
    find_el(element).text
  end

end
