require 'rspec'

module ExpectLog
  include RSpec::Matchers

  def expecting(condition, expected, description='none')
    condition.eql?(expected) ? log_info(description) : log_error(description)
    expect(condition).to eql(expected)
  end

  def log_info(msg)
    logger('INFO', msg)
  end

  def log_warning(msg)
    logger('WARNING', msg)
  end

  def log_error(msg)
    logger('ERROR', msg)
  end

  def start_log_controller
    date = Time.now.strftime('%m/%d/%Y').to_s
    start_time = Time.now.strftime('%H:%M:%S').to_s
    $compare_starting_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    $log = []
    $log << "Date: #{date}"
    $log << "Starting time: #{start_time}"
    $log << "Platform: #{PLATFORM}"
    $log << "Browser: #{BROWSER}"
    $log << "\n"
    $log << '--------- LOG START ---------'
  end

  def end_log_controller
    ending_time = Time.now.strftime('%H:%M:%S').to_s
    $compare_ending_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed_time = $compare_ending_time - $compare_starting_time

    $log << '--------- LOG END ---------'
    $log << ''
    $log << "Elapsed time: #{elapsed_time}"
    $log << "Ending time: #{ending_time}"
  end

  private

  def logger(type,msg)
    log = type.eql?('INFO') || type.eql?('WARNING') ? Logger.new($stdout) : Logger.new($stderr)
    type.eql?('ERROR') ? log.error(msg) : log.info(msg)
    $log << msg
  end


end

