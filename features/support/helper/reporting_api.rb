#!/usr/bin/env ruby
require 'rest_client'
require 'base64'
require 'openssl'
require 'rubygems'
require 'watir-webdriver'
require 'yajl'
require 'json-compare'
require 'rspec/expectations'
require 'json'

class ReportAPICustomError < StandardError
end

class Reporting_API_Client
  include PageObject
  include DataMagic

  def self.calculate (private_key, verb, uri, time)
    data =  verb + "\n" + time + "\n" + uri
    hash  = OpenSSL::HMAC.digest('sha256', private_key, data)
    Base64.encode64(hash)
  end

  def self.get_user_data (data = {})
    DataMagic.load('reporting_api.yml')
    env_prefix = FigNewton.env_prefix
    DataMagic.data_for('reporting_api/'+env_prefix+'_reporting_api_data', data)
  end

  def self.get_json_file(filetype)
    DataMagic.load('reporting_api.yml')
    files_path = DataMagic.yml["path_to_report_api_json_files"]
    #runtime_env = FigNewton.env
    env_prefix  = FigNewton.env_prefix
    path=env_prefix+'_report_api_json_'+filetype
    path=Dir.pwd+files_path[path]
    file = File.open(path,"rb")
    contents = file.read
  end

  def self.report_api(verb)
    data = {}
    data = get_user_data
    private_key = data['private_key']
    media_id = data['mediaID']
    uri = data['uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    public_key  = data['public_key']
    signature = calculate(private_key, verb, uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    response = request_report_get(uri,authorization, time )#RestClient.get uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  rescue => e  #rest issue
    begin
      result =  e.response.to_s
      fail
    end
  else
    begin
      prettify_response = JSON.pretty_generate(JSON.parse(response.body.to_s))
      #compare_jason(get_json_file('valid'),response.body)
      compare_json(get_json_file('valid'),response.body)
      fail if response.code!=200
      result =  'Response code: '+response.code.to_s+'<br>'+'Response JSon File'+'<br>'+'<pre>'+prettify_response+'</pre>'

    rescue => e
      begin
        prettify_expected= JSON.pretty_generate(JSON.parse(get_json_file('valid').to_s))
        result =  'Response code: '+response.code.to_s+ "\n"
        result =  result + 'API response != expected response '+"\n"
        result =  result + 'API JSON Response'+"\n"
        result =  result +"\n"+prettify_response+"\n"
        result =  result + 'Expected json'+'<br>'
        result =  result +"\n"+ prettify_expected +"\n"
        raise ReportAPICustomError, result
      end
    end
  end

  def self.compare_jason(to_compare_json1,to_compare_json2)
    json1=Yajl::Parser.parse(to_compare_json1)
    json2=Yajl::Parser.parse(to_compare_json2)
    exclusion = ["errorId"]
    result = JsonCompare.get_diff(json1, json2,exclusion)
    puts result
    fail unless result.empty?
  end

  def self.compare_json(to_compare_json1,to_compare_json2)
    json1=Yajl::Parser.parse(to_compare_json1)
    json2=Yajl::Parser.parse(to_compare_json2)
    array_a = hash_to_a (json1)
    array_b = hash_to_a (json2)
    are_different = !(array_compare(array_a.flatten, array_b.flatten))
    fail if are_different
  end

  def self.compare_json_as_set(to_compare_json1,to_compare_json2)
    json1=Yajl::Parser.parse(to_compare_json1)
    json2=Yajl::Parser.parse(to_compare_json2)
    puts json1
      # json_a = (JSON.parse(to_compare_json1)).flatten
      # json_b = (JSON.parse(to_compare_json2)).flatten
      # if compare_hashes(json_a, json_b)
      #     puts "Return Json is same as expected"
      # end
  end

  def self.compare_hashes(hash_a, hash_b)
    i=0
    puts "#{hash_a}\n"
    puts "#{hash_b}\n"
    while i<hash_a.size
      if hash_a[i].kind_of? Hash
        compare_hashes(hash_a[i].flatten,hash_b[i].flatten)
      else
          if hash_a[i].kind_of? Array
             compare_hashes(hash_a[i],hash_b[i])
          else
            if hash_a[i] != hash_b[i]
              puts "#{hash_a[i]} != #{hash_b[i]} - comparison fails"
              fail
            end
          end
      end
      i=i+1
    end
    return true
  end

  def self.request_report_get(uri,authorization, time )
    response = RestClient.get uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  end

  def self.request_report_post(uri,authorization, time )
    response = RestClient.post uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  end

  def self.request_report_put(uri,authorization, time )
    response = RestClient.put uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  end

  def self.request_report_delete(uri,authorization, time )
    response = RestClient.delete uri,{'X-CCAPIAUTH-Date' => time,'Authorization' => authorization}
  end

  def self.report_api_invalid_uri
    data = {}
    data = get_user_data
    private_key = data['private_key']
    media_id = data['mediaID']
    uri = data['invalid_uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    public_key  = data['public_key']
    signature = calculate(private_key, 'get', uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    response = request_report_get(uri,authorization, time )
  rescue => e
    begin
      fail if e.http_code!=500
      $stdout.print 'Response code: '+ e.http_code.to_s+'\n'
    end
  end

  def self.report_api_invalid_key(invalid_key, key_scope)
    data = {}
    data = get_user_data
    media_id = data['mediaID']
    uri = data['uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    public_key=''
    private_key=''
    if key_scope=='public'
      public_key  = invalid_key
      private_key = data['private_key']
    end
    if key_scope =='private'
      public_key  = data['public_key']
      private_key = invalid_key
    end
    signature = calculate(private_key, 'get', uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    response = request_report_get(uri,authorization, time )      #should fail
  rescue StandardError=>e
    begin
      compare_jason(get_json_file('invalid_authorization'),e.response)
      prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
      result =  'Response code: '+e.http_code.to_s+'<br>'
      result =  'Server Response: '+'<br>'
      result =  result + prettify_response+'<br>'
    rescue StandardError=>e
      begin
        compare_jason(get_json_file('change_key'),e.response)
        prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
        result =  'Response code: '+e.http_code.to_s+'<br>'
        result =  'Server Response: '+'<br>'
        result =  result + prettify_response+'<br>'
      rescue StandardError=>e
        begin
          compare_jason(get_json_file('secret_not_configured'),e.response)
          prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
          result =  'Response code: '+e.http_code.to_s+'<br>'
          result =  'Server Response: '+'<br>'
          result =  result + prettify_response+'<br>'
        rescue StandardError=>z #other
          prettify_expected= JSON.pretty_generate(JSON.parse(get_json_file('invalid_authorization').to_s))
          prettify_expected2= JSON.pretty_generate(JSON.parse(get_json_file('change_key').to_s))
          result =  'Response : '+z.to_s+ "\n"
          result =  result + 'API response != expected response '+"\n"
          result =  result + 'Response'+"\n"
          result =  result +"\n"+z.to_s+"\n"
          result =  result + 'Expected JSON 1 '+'<br>'
          result =  result +"\n"+ prettify_expected +"\n"
          result =  result + 'Expected JSON 2 '+'<br>'
          result =  result +"\n"+ prettify_expected2 +"\n"
          raise ReportAPICustomError, result
        end
      end
    end
  end

  def self.report_api_no_access
    data = {}
    data = get_user_data
    private_key = data['private_key_no_access']
    media_id = data['mediaID']
    uri = data['uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    public_key  = data['public_key_no_access']
    signature = calculate(private_key, 'get', uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    response = request_report_get(uri,authorization, time )
  rescue => e
    begin
      compare_jason(get_json_file('invalid_authorization'),e.response)
      prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
      result =  'Response code: '+e.http_code.to_s+'<br>'
      result =  'Server Response: '+'<br>'
      result =  result + prettify_response+'<br>'
        #other error
    rescue => y
      begin
        prettify_expected= JSON.pretty_generate(JSON.parse(get_json_file('invalid_authorization').to_s))
        result =  'Response code: '+response.code.to_s+ "\n"
        result =  result + 'API response != expected response '+"\n"
        result =  result + 'API JSON Response'+"\n"
        result =  result +"\n"+prettify_response+"\n"
        result =  result + 'Expected json'+'<br>'
        result =  result +"\n"+ prettify_expected +"\n"
        raise ReportAPICustomError, result
      end
    end

  end

  def self.report_api_change_key
    data = {}
    data = get_user_data
    media_id = data['mediaID']
    uri = data['uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    private_key = data['public_key']
    public_key  = data['private_key']
    signature = calculate(private_key, 'get', uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    response = request_report_get(uri,authorization, time )
  rescue =>e
    begin
      #compare_jason(get_json_file('change_key'),e.response)
      compare_jason(get_json_file('secret_not_configured'),e.response)
      prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
      result =  'Response code: '+e.http_code.to_s+'<br>'
      result =  'Server Response: '+'<br>'
      result =  result + prettify_response+'<br>'
        #other error
    rescue =>y
      begin
        prettify_expected= JSON.pretty_generate(JSON.parse(get_json_file('change_key').to_s))
        result =  'Response code: '+response.code.to_s+ "\n"
        result =  result + 'API response != expected response '+"\n"
        result =  result + 'API JSON Response'+"\n"
        result =  result +"\n"+prettify_response+"\n"
        result =  result + 'Expected json'+'<br>'
        result =  result +"\n"+ prettify_expected +"\n"
        raise ReportAPICustomError, result
      end
    end
  end

  def self.report_api_time_out
    data = {}
    data = get_user_data
    media_id = data['mediaID']
    uri = data['uri']+media_id.to_s
    time = (Time.now.utc  - (60*6)).strftime('%a, %d %b %Y %T GMT')
    private_key = data['private_key']
    public_key  = data['public_key']
    signature = calculate(private_key, 'get', uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    response = request_report_get(uri,authorization, time )
  rescue => e
    begin
      compare_jason(get_json_file('time_out'),e.response)
      prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
      result =  'Response code: '+e.http_code.to_s+'<br>'
      result =  'Server Response: '+'<br>'
      result =  result + prettify_response+'<br>'
        #other error
    rescue => y
      begin
        prettify_expected= JSON.pretty_generate(JSON.parse(get_json_file('time_out').to_s))
        result =  'Response code: '+response.code.to_s+ "\n"
        result =  result + 'API response != expected response '+"\n"
        result =  result + 'API JSON Response'+"\n"
        result =  result +"\n"+prettify_response+"\n"
        result =  result + 'Expected json'+'<br>'
        result =  result +"\n"+ prettify_expected +"\n"
        raise ReportAPICustomError, result
      end
    end
  end

  def self.report_api_invalid_media_id(media_id)
    data = {}
    data = get_user_data
    uri = data['uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    private_key = data['private_key']
    public_key  = data['public_key']
    signature = calculate(private_key, 'get', uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    response = request_report_get(uri,authorization, time )
  rescue => e
    begin
      fail if e.http_code!=500
      $stdout.print 'Response code: '+e.http_code.to_s+'\n'
    end
  end

  def self.report_api_header_invalid_key (key)
    data = {}
    data = get_user_data
    private_key = data['private_key_no_access']
    media_id = data['mediaID']
    uri = data['uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    public_key  = data['public_key_no_access']
    signature = calculate(private_key, 'get', uri, time)
    authorization   =  'CCApiAuth '+key+':'+signature
    response = request_report_get(uri,authorization, time )
  rescue => e
    begin
      compare_jason(get_json_file('invalid_headers'),e.response )
      prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
      result =  'Response code: '+e.http_code.to_s+'<br>'
      result =  'Server Response: '+'<br>'
      result =  result + prettify_response+'<br>'
        #other error
    rescue => y
      begin
        prettify_expected= JSON.pretty_generate(JSON.parse(get_json_file('invalid_headers').to_s))
        result =  'Response code: '+response.code.to_s+ "\n"
        result =  result + 'API response != expected response '+"\n"
        result =  result + 'API JSON Response'+"\n"
        result =  result +"\n"+prettify_response+"\n"
        result =  result + 'Expected json'+'<br>'
        result =  result +"\n"+ prettify_expected +"\n"
        raise ReportAPICustomError, result
      end
    end
  end

  def self.report_api_misspelled(misspelled)
    data = {}
    data = get_user_data
    private_key = data['private_key']
    media_id = data['mediaID']
    uri = data['uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    public_key  = data['public_key']
    signature = calculate(private_key, 'get', uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    response = RestClient.get uri,{'X-CCAPIAUTH-Date' => time,misspelled => authorization}
  rescue => e
    begin
      compare_jason(get_json_file('invalid_header'),e.response)
      prettify_response= JSON.pretty_generate(JSON.parse(e.response.to_s))
      result =  'Response code: '+e.http_code.to_s+'<br>'
      result =  'Server Response: '+'<br>'
      result =  result + prettify_response+'<br>'
        #other error
    rescue => y
      begin
        prettify_expected= JSON.pretty_generate(JSON.parse(get_json_file('invalid_header').to_s))
        result =  'Response code: '+response.code.to_s+ "\n"
        result =  result + 'API response != expected response '+"\n"
        result =  result + 'API JSON Response'+"\n"
        result =  result +"\n"+prettify_response+"\n"
        result =  result + 'Expected json'+'<br>'
        result =  result +"\n"+ prettify_expected +"\n"
        raise ReportAPICustomError, result
      end
    end
  end

  def self.report_api_invalid_method(signature_verb, method_verb)
    data = {}
    data = get_user_data
    private_key = data['private_key']
    media_id = data['mediaID']
    uri = data['uri']+media_id.to_s
    time = Time.now.utc.strftime('%a, %d %b %Y %T GMT')
    public_key  = data['public_key']
    signature = calculate(private_key, signature_verb, uri, time)
    authorization   =  'CCApiAuth '+public_key+':'+signature
    case method_verb
      when 'POST'
        response = request_report_post(uri,authorization,time)
      when 'PUT'
        response = request_report_put(uri,authorization,time)
      when 'DELETE'
        response = request_report_delete(uri,authorization,time)
    end
      #expected =  get_json_file('invalid_method')
  rescue => e
    begin
      if e.http_code!=501   #not implemented message
        compare_jason(get_json_file('invalid_method'),e.response)
        $stdout.print 'Response code: '+e.http_code.to_s+'\n'
        $stdout.print 'Response JSon File'+'\n'+ e.response
      end
    end
  end


  def self.hash_to_a(item)
    if item.instance_of? Hash
      item = item.to_a
    end
    if item.instance_of? Array
      i = 0
      while i<item.size do
        if item[i].instance_of? Hash
          item[i] = hash_to_a(item[i])
        end
        if item[i].instance_of? Array
          item[i] = hash_to_a(item[i])
        end
        i=i+1
      end
    end
    return item
  end

  def self.array_hash_nested(item)
    i=0
    while i<item.size do
      if item[i].instance_of? Hash
        item[i] = hash_to_a(item[i])
      else
        item[i] = hash_to_a(item[i])
      end
    end
    return item
  end

  def self.array_compare(a,b)
    i = 0
    flag = true
    while i<a.size do
      if not a.include? b[i]
        puts "pos #{i} - #{b[i]}"
        flag =  false
      end
      i=i+1
    end
    return flag
  end






end
