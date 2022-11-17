module WebActions
  def click_el(element)
    retry_action do
      perform_click(element)
    end
  end

  private

  def retry_action
    tries = 0
    begin
      yield
    rescue StandardError
      if tries < 1
        tries += 1
        sleep 2
        retry
      end
    end
  end

  def perform_click(element)
    element.click
  end
end