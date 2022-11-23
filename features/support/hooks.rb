World(WebActions, Finder, ExpectLog, WaitElement, Screenshot, TestData, Utils)
Bridge.class_eval { include WebActions, Finder, ExpectLog, WaitElement, Screenshot, TestData, Utils }

require 'selenium-webdriver'

Before do
  $step_results = {}
  $run_id = ''
  $testrail_api = TestrailIntegration.new
end

Before do |scenario|
  create_run(scenario)

  $step_index = 0
  $stop_count = scenario.test_steps.count
  @scenario = scenario

  screenshot_define_name(get_scenario_name(scenario))
  start_log_controller
  options = BROWSER.eql?('firefox') ? Selenium::WebDriver::Firefox::Options.new : Selenium::WebDriver::Chrome::Options.new

  if REMOTE
    USER_NAME = ENV['BROWSERSTACK_USERNAME'] || "pipopipoka_NSp7hl"
    ACCESS_KEY = ENV['BROWSERSTACK_ACCESS_KEY'] || "TQgSveAu8Fjx1KqatRBa"

    options = Selenium::WebDriver::Options.send "chrome"
    $driver = Selenium::WebDriver.for(:remote,
                                     :url => "https://#{USER_NAME}:#{ACCESS_KEY}@hub.browserstack.com/wd/hub",
                                     :capabilities => options)
  else
    if HEADLESS
      options.add_argument('--headless')
      options.add_argument('--window-size=1920,1080')
    else
      options.add_argument('--window-size=1280,1024')
    end

    $driver = Selenium::WebDriver.for BROWSER.downcase.to_sym, {
      :options => options,
    }

    $driver.manage.window.maximize unless HEADLESS
  end


end

After do |scenario|
  $final_result = scenario.passed?
  $final_attachment = scenario_print('end')
  attach($final_attachment, 'image/png')
  $driver.quit
  end_log_controller
  create_log_file
end

AfterStep do |scenario|
  attachment_path = scenario_print('step')
   attach(attachment_path, 'image/png')

  if $step_index < $stop_count
    $steps = @scenario.test_steps
    step_name = @scenario.test_steps[$step_index].text
  end
  $step_index += 2

  if step_name.include?("#")
    test_cases = step_name.split("#")
    test_cases = test_cases[1].gsub("testcase-","").split(" ")
    test_cases.each do |test_case|
      $step_results[test_case] = [scenario.passed?,attachment_path]
    end
  end
end

at_exit do
  puts "Updating TestRail run"

  unless $final_result
    step_name = $steps[$step_index].text
    if step_name.include?("#")
      test_cases = step_name.split("#")
      test_cases = test_cases[1].gsub("testcase-","").split(" ")
      test_cases.each do |test_case|
        $step_results[test_case] = [false, $final_attachment]
      end
    end
  end

  $step_results.each do |key, value|
    result_id = $testrail_api.testrail_add_results_for_cases($run_id, key, value[0])
    $testrail_api.testrail_add_attachment_result(result_id["id"], value[1])
  end

  $testrail_api.testrail_close_run($run_id)

  puts "Testrail run successfully updated!"
end

def create_log_file
  File.open("#{$file_path}/log_file.txt", 'w') do |file|
    file.puts $log
  end
end

def get_scenario_name(scenario)
  regex = %r{/([_@#!%()\-=;><,{}\˜\[\]\.\/\?\"\*\ˆˆ$\+\-]+)/}
  scenario.name.gsub(regex, '')
end

def create_run(scenario)
  test_cases = []

  scenario.source_tag_names.each do |tags|
    if tags.include?('testcase')
      test_cases << tags.sub("@testcase-", "").strip
    end
  end

  $run_id = $testrail_api.testrail_add_run(test_cases)["id"]
end