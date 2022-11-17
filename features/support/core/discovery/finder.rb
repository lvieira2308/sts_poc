module Finder
  @@tries = 3

  def discover(element_name)
    discover = DiscoverElement.new
    discover.discover(element_name)

    @description = discover.description
    @locator = discover.locator
    @element_id = discover.element_id
    @element_name = element_name
  end

  def retry_finder(element_name)
    discover(element_name)
    retries = 0

    begin
      return yield
    rescue StandardError => e
      retries +=1
      if retries < @@tries
        log_warning("Still looking for the element: #{@element_name}")
        retry
      else
        log_info(e.to_s)
        false
      end
    end
  end

  def fast_finder(element_name, finder, locator)
    discover(element_name)
    begin
      found = false
      2.times do
        found = $driver.find_element(finder, locator).displayed?
        break if found
      end
      found
    rescue StandardError
      false
    end
  end

  def retry_finder_visible(element_name)
    discover(element_name)
    retries = 0

    begin
      yield
    rescue StandardError
      sleep 1
      retries +=1
      retries < @@tries ? retry : nil
    end
  end

end
