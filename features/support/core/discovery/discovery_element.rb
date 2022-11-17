class DiscoverElement
  attr_reader :locator, :element_id, :description, :element_name

  @screen_name = ''

  def discover(element_name)
    @element_name = element_name
    els= element_name.split(/\.(?=\w)/)
    @screen_name = els[0]
    file = load_file

    @locator = file[element_name]['locator'].to_s

    @element_id = file[element_name]['element_id'].to_s
    @element_id = "//*[text() = '#{@element_id}']" if @locator.downcase == 'text'
    @element_id = "//*[contains(text(),'#{@element_id}')]" if @locator.downcase == 'textcontains'
    @locator = 'xpath' if @locator.downcase == 'text'
    @locator = 'xpath' if @locator.downcase == 'textcontains'
    @locator = @locator.to_sym
    raise "The locator for the element #{element_name} is empty" if @locator.to_s.empty?
    raise "The identifier for the element #{element_name} is empty" if @element_id.to_s.empty?
  end

  def load_file
    begin
      YAML.load_file("features/screens/#{@screen_name}/#{@screen_name}.yml")
    rescue StandardError => e
      raise "#{@screen_name}.yml file: Check if the file really exists, if yes, it may have some parsing error"
    end
  end
end
