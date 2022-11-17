module Finder

  def find_element_by(locator, by: :css, timeout: 30, action: :none, keys: :none)
    log_info("Finding element: #{locator} by: #{by}")
    displayed = action.eql?(:displayed)

    by, locator, wait = get_wait_and_by(by, locator, timeout)

    get_element(displayed: displayed) do
      element = wait.until { $driver.find_element by, locator }
      perform_action(action, element, keys)
    end

  end

  def find_child_element_by(father_element, locator, by: :css, action: :none, keys: :none)
    log_info("Finding child element: #{locator} by: #{by}")
    displayed = action.eql?(:displayed)

    get_element(displayed: displayed) do
      element = father_element.find_element(by, locator)
      perform_action(action, element, keys)
    end
  end

  def find_elements_by(locator, by: :css, timeout: 30, action: :none, text: false)
    log_info("Finding elements: #{locator} by: #{by}")
    displayed = action.eql?(:displayed)

    by, locator, wait = get_wait_and_by(by, locator, timeout)

    get_elements(displayed: displayed, timeout: timeout, by: by, locator: locator) do
      element_list = wait.until { $driver.find_elements by, locator }
      perform_list_action(action, element_list)
    end
  end


  def find_child_elements_by(father_element, locator, by: :css)
    log_info("Finding child elements: #{locator} by: #{by}")

    get_element(displayed: false) do
      father_element.find_elements(by, locator)
    end
  end

  def find_by_text(text, timeout: 30, action: :none, button: false)
    xpath_query = button ? "//button[text() = '#{text}']" : "//*[text() = '#{text}']"

    if action.eql?(:displayed)
      find_element_by(xpath_query, by: :xpath, action: :displayed, timeout: timeout)
    else
      begin
        find_element_by(xpath_query, by: :xpath, timeout: timeout, action: action)
      rescue Selenium::WebDriver::Error::NoSuchElementError => e
        raise "Error: #{e.class}. Message: #{e.message}. Searched for text: #{text}"
      end
    end
  end

  def find_by_texts(text, timeout: 30, displayed: false, action: :none)
    if displayed
      find_elements_by("//*[text() = '#{text}']", by: :xpath, action: :displayed, timeout: timeout)
    else
      begin
        find_elements_by("//*[text() = '#{text}']", by: :xpath, action: action, timeout: timeout)
      rescue StandardError => e
        raise "Error: #{e.class}. Message: #{e.message}"
      end
    end
  end

  def find_by_texts_contain(text, timeout: 30, displayed: false)
    if displayed
      find_elements_by("//*[contains(text(),'#{text}')]", by: :xpath, action: :displayed, timeout: timeout)
    else
      begin
        find_elements_by("//*[contains(text(),'#{text}')]", by: :xpath, timeout: timeout)
      rescue StandardError => e
        raise "Error: #{e.class}. Message: #{e.message}"
      end
    end
  end

  def find_by_text_contains(text, timeout: 30, action: :none, button: false)
    xpath_query = button ? "//button[contains(text() = '#{text}']" : "//*[contains(text() = '#{text}']"

    if action.eql?(:displayed)
      find_element_by(xpath_query, by: :xpath, action: :displayed, timeout: timeout)
    else
      begin
        find_element_by(xpath_query, by: :xpath, timeout: timeout)
      rescue StandardError => e
        raise "Error: #{e.class}. Message: #{e.message}"
      end
    end
  end

  def retry_stale_error
    tries = 0
    begin
      tries += 1
      yield
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      sleep 2
      retry if tries <= 1
    end
  end

  private

  def perform_action(action, element, keys)
    res = element
    case action
    when :displayed
      log_info('Checking if element is displayed')
      res = element.displayed?
    when :click
      log_info('Clicking...')
      res = element.click
    when :move_click
      log_info('Moving and clicking...')
      res = $driver.action.move_to(element).click.perform
    when :text
      log_info('Retrieving the text...')
      res = element.text
    when :send_keys
      log_info('Sending text...')
      res = element.send_keys(keys)
    end
    res
  end

  def perform_list_action(action, element_list)
    res = element_list
    case action
    when :random_click
      res.sample.click
    end
    res
  end

  def get_wait_and_by(by, locator, timeout)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout)
    [by, locator, wait]
  end

  def get_element(displayed: nil)
    retries = 0
    if displayed
      begin
        yield
        true
      rescue Selenium::WebDriver::Error::StaleElementReferenceError ||
             Selenium::WebDriver::Error::InvalidArgumentError ||
             Selenium::WebDriver::Error::ElementNotInteractableError ||
             Selenium::WebDriver::Error::ElementClickInterceptedError => e

        log_warning("Found an exception. Trying to handle with: #{e.msg}")
        if retries < 5
          retries += 1
          sleep 2
          retry
        else
          false
        end
      rescue StandardError
        false
      end
    else
      begin
        yield
      rescue StandardError => e
        if retries < 3
          retries += 1
          sleep 2
          retry
        else
          raise "Error: #{e.class}. Message: #{e.message}"
        end
      end
    end
  end

  def get_elements(displayed: nil, timeout: nil, by: nil, locator: nil)
    retries = 0
    if displayed
      begin
        list_size = yield
        list_size.size.zero? ? raise(StandardError) : true
      rescue StandardError
        if retries < 10
          retries += 1
          sleep timeout.to_f / 10
          retry
        else
          false
        end
      end
    else
      begin
        list_size = yield
        list_size.size.zero? ? raise(StandardError) : list_size
      rescue StandardError
        if retries < 10
          retries += 1
          sleep timeout.to_f / 10
          retry
        else
          raise "Could not find any element by #{by} with the locator #{locator} after #{timeout} seconds"
        end
      end
    end
  end

  def log_info(msg)
    Logger.new($stdout).info(msg)
  end


end
