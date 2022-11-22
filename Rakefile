require 'report_builder'
require 'pry'

desc 'Run Sequential Tests'
task :sequential_tests, [:tag, :browser, :env, :other] do | _task, args|
  other_args = get_other_args(args[:other])
  sequential( args[:tag], args[:browser], args[:env],  other_args)
end

desc 'Run Parallel Tests'
task :parallel_tests, [:tag, :browser, :env, :threads, :other] do | _task, args|
  other_args = get_other_args(args[:other])
  parallel( args[:tag], args[:browser],args[:env], args[:threads], other_args)
end

desc 'Run Circle CI Parallel Tests'
task :parallel_tests_circle_ci, [:tag, :browser, :env, :threads, :build, :other] do | _task, args|
  set_build(:build, :browser, :tag)
  other_args = get_other_args(args[:other])
  parallel( args[:tag], args[:browser],args[:env], args[:threads], other_args)
end
def parallel(tag, browser, environment, threads, args)
  clean_project
  puts '================== STARTING =================='
  puts '================== RUNNING =================='
  system "parallel_cucumber features/ -o '-t \"#{tag}\" -p parallel -p #{environment} -p #{browser}' -n #{threads} --group-by scenarios"
  rerun_parallel_tests_failed(args[:threads], browser, environment) if args[:retry] && File.exist?('cucumber_failures.log') && File.size('cucumber_failures.log') >= 1
  generate_report_builder('parallel', 'web', browser, environment)
end

def sequential(tag, browser, environment, args, retry_times=2)
  clean_project
  puts '================== STARTING =================='
  puts '================== RUNNING =================='
  system "cucumber -t \"#{tag}\" -p sequential -p #{browser} -p #{environment}"
  rerun_sequential_tests_failed(retry_times, browser, environment) if args[:retry] && File.exist?('cucumber_failures.log') && File.size('cucumber_failures.log') >= 1
  generate_report_builder('sequential', 'web', browser, environment)
end

def clean_project
  puts '======== Cleaning all the mess ========'

  rm_dir("reports/final_reports")
  rm_dir("reports/sequential")
  rm_dir("reports/parallel")

  puts "======== Ok, now we're ready! ========"

end

def rm_dir(path)
  if File.directory?(path)
    puts ">>>>>>>> Cleaning #{path} <<<<<<<<"
    FileUtils.rm_rf(path)
  end
end

def generate_report_builder(type_exec, plat, browser, environment)
  ReportBuilder.configure do | config |
    config.report_title = 'Inkblot Therapy - Web Automation'
    config.report_types = %i[html]
    config.input_path = "reports/#{type_exec}"
    config.report_path = "reports/final_reports/#{type_exec}_report"
    config.additional_info = { Platform: plat.upcase, Browser: browser.upcase, Environment: environment.upcase}
    config.color = 'light-green lighten-5'
  end
  ReportBuilder.build_report

  customize_report_builder(type_exec)
end

def customize_report_builder(report_name)
  report = File.open("reports/final_reports/#{report_name}_report.html", "r")
  string = report.read
  report.close

  string.gsub!('<h5 class="truncate white-text tooltipped" data-tooltip="Inkblot Therapy- Web Automation">Inkblot Therapy - Web Automation</h5>', '<div class="center"><img src="/reports/img/inkblot_therapy.png" style="width:220px;height:40px;"></div>')
  File.open(report, "w") { |file| file << string }
end

def rerun_parallel_tests_failed(threads, browser, environment)
  puts '======================= STARTING RERUN ========================'
  puts '=========== Parallel rerun scenarios failed... ============'

  scenarios = list_scenarios_failed_parallel
  scenarios_failed = extracts_failed_scenarios(scenarios)
  tags_list = get_tags_scenarios_failed(scenarios_failed)
  final_tags = convert_array_tags_for_cucumber_command(tags_list)
  system "parallel_cucumber features/ -o '-t \"#{final_tags}\" -p report_parallel_rerun -n #{threads} --group-by scenarios -p #{browser} -p #{environment}"
  puts '======================== END RERUN ========================='
end

def rerun_sequential_tests_failed(retry_times, browser, environment)
  time = 1
  retry_times = retry_times.to_i
  retry_times.times do
    if File.exist?('cucumber_failures.log') && File.size('cucumber_failures.log') >= 1
      failures = File.read('cucumber_failures.log')
      File.delete('cucumber_failures.log')
      scenarios_filtered = extracts_failed_scenarios(failures.split("\n"))
      puts "======================= STARTING RERUN # #{time}======================"
      puts '========= Sequential rerun scenarios failed... ==========='
      puts "===================== #{scenarios_filtered.size} scenarios to retry ============="
      scenarios_filtered.each do |scenario|
        system "cucumber #{scenario} -p cucumber_failures_logger -p report_rerun -p web -p #{browser} -p #{environment}"
      end
      time +=1
    end
  end

  puts '======================= END RERUN =========================='
end

def extracts_failed_scenarios(scenarios_failed)
  scenarios_filtred = []
  scenarios_failed.each do |scenario|
    if scenario.count(':') <= 1
      scenarios_filtred << scenario
      next
    end
    scenarios_splited = scenario.split(':')

    scenarios_splited.size.times do |index|
      scenarios_filtred << "#{scenarios_splited[0]}:#{scenarios_splited[index]}" unless index.zero?
    end
  end

  scenarios_filtred
end

def list_scenarios_failed_parallel
  scenarios = File.read('cucumber_failures.log')
  scenarios = scenarios.gsub('features', "\nfeatures")
  scenarios = scenarios.split("\n")
  scenarios.each { |scenario| scenarios.delete(scenario) if scenario.empty? }
  scenarios
end

def get_tags_scenarios_failed(scenarios)
  final_tags = []
  words_regex = /Given|When|Then|Scenario|Scenario Outline/

  scenarios.each do |scenario|
    scenario_and_line = scenario.split(':')
    lines = File.readlines(scenario_and_line.first)

    count = 1
    scenario_and_line.last.to_i.times do
      line_current = lines[scenario_and_line.last.to_i - count]

      if line_current.include?('@') &&
        !line_current.include?('|') &&
        !line_current.match?(words_regex)

        final_tags << line_current.strip
        break
      else
        count += 1
      end
    end
  end

  final_tags
end

def convert_array_tags_for_cucumber_command(tags_list)
  tags_list = tags_list.to_s
  tags_list.gsub('"', '').gsub('[', '').gsub(']', '').gsub(',', ' or')
end

def get_other_args(arg)
  args = { :retry => false }

  case arg
  when 'retry'
    args[:retry] = true
  else
    raise "Invalid argument" unless arg.nil?
  end
  args
end

def set_build(build, browser, tag)
  tag = tag.delete('@')
  ENV['BUILD_NAME'] = "[WEB_#{browser.uppercase}]_BUILD:#{build}_SCOPE:#{tag}"
end