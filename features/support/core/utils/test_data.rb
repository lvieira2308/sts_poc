module TestData

  @safe_lock = false

  def lock?
    @safe_lock
  end

  def default_url
    @safe_lock = true if ENVIRONMENT.eql?('prd')
    MAIN_URL
  end

  def get_random_email
    "qa-web-automation_inkblot_#{Time.now.strftime('%Y-%m-%d-T%H-%M-%S-%3N')}"
  end

  def get_credit_card(brand)
    brands = {'master' => '5544615437188318', 'visa' => '4510674279941485'}

    brand.downcase!

    if brand.eql?('random')
      brand_name = brands.keys.sample
      card_number = brands[brand_name]
    else
      begin
        brand_name = brand
        card_number = brands[brand_name]
      rescue StandardError
        error_msg = "This card holder #{brand} does not exist in the list"
        log.error(error_msg)
        raise error_msg
      end
    end

    [brand_name, card_number]
  end

end

