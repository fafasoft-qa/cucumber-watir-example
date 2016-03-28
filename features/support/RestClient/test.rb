#!/usr/bin/env ruby
require 'rest_client'
require 'base64'
require 'openssl'
require_relative '../helper/common'

def calculate_hash (key, verb, uri, time)
  data =  verb + "\n" + time + "\n" + uri
  hash  = OpenSSL::HMAC.digest('sha256', key, data)
  Base64.encode64(hash)
end

def execute_api
  private_key = 'BAE490D0-5D81-481C-9564-9408469B4A7D' # this is the private key    --> for qajair_01@test.com   caso 1: invalido, caso: sea valida pero de otro user     caso 5 null
  public_key = '5684D9F5175A4EAD8FA668643C1420AF' #this is the public key           --> for qajair_01@test.com   caso 3: invalido caso 4: null
  verb = 'GET'  # caso 6: post, delete, put, update     caso 10: null
  uri ='https://qa-platform.cinchcast.com/api/v1/reporting/12967' #caso 7: uri sin acceso al user (reporte de otro usuario)  caso 8: otra uri caso 9 :null
  time =  Time.now.utc.strftime('%a, %e %b %Y %T GMT') #valid time caso 11:
  # caso 11: check string value of the last timestamp, copy, and replace time variable by the copied string minus 5 minutes
  puts "Rest client test - Last generated timetamp - URI\t\t=> #{time.to_s}\n"

  signature = calculate_hash(private_key, verb, uri, time)
  #puts signature
  authorization   =  'CCApiAuth '+public_key+':'+signature
  response = RestClient::Request.execute(:method => :get, :url =>  uri,
                                         :headers => {'X-CCAPIAUTH-Date' => time,'Authorization' => authorization})

  print response.code
  print response.body

rescue => e
  begin
    print e.response
 end

end
begin
  #execute_api
end
#public key
#5684D9F5175A4EAD8FA668643C1420AF                                 qaJair_01@test.com
#97FEF747CA924A7BAC89C0CFBF568C62                                 qaFabricio_01@test.com
#9DA99E2B433E46FCA4EA3D66CEF3F98D                                autoams01@test.com
#A952404A3A314058A146795F3F359914                                   jcarusotest@cinchcast.com
#BEEA67DD25964BAD820EFA8FDBDCF651                               dima01@test.com
#secret key
#autoams01@test.com   59469059-72F3-411E-86D1-1E12C08E96FB
#dima01@test.com           E4BD3051-1B83-4C33-A0D6-CF20D11193C9
#qafabricio_01@test.com              7E4C4B1E-31CE-498D-A598-590A5F51D111
#qajair_01@test.com       BAE490D0-5D81-481C-9564-9408469B4A7D




