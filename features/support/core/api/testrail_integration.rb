class TestrailIntegration

  @client = nil

  def initialize
    @client = TestRail::APIClient.new('https://inkblottherapy.testrail.io')
    @client.user = 'quality+inkblot@teamsts.ca'
    @client.password = 'p4s$4In3blot'
  end

  def testrail_add_run(cases_ids)
    time = Time.now.strftime("%m/%d/%Y_%H:%M:%S")
    name = "#{BROWSER} web automation run - : #{time}"

    jira = File.read("jira.txt")
    @client.send_post(
      'add_run/1',
      { :suite_id => 2, :name => name, :refs => jira, :case_ids => cases_ids, :include_all => false}
    )
  end

  def testrail_close_run(run_id)
    @client.send_post(
      "close_run/#{run_id}",
      run_id: run_id
    )
  end

  def testrail_add_results_for_cases(run_id, case_id, result)
    if result
      test_msg = "passed"
      result_number = 1
    else
      test_msg = "failed"
      result_number = 5
    end

    @client.send_post(
      "add_result_for_case/#{run_id}/#{case_id}",
      {
        "status_id": result_number,
        "comment": "This test #{test_msg}"
      }
    )
  end

  def testrail_add_attachment_result(result_id, attachment_path)
    @client.send_post("add_attachment_to_result/#{result_id}", attachment_path)
  end

end
