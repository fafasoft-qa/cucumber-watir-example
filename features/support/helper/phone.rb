require 'twilio-ruby'

#Define module to be used by other classes
module PhoneUtils
  
  class Phone
  
    #Contructor for phone class.
    def initialize
      #Load properties file for twilio, containing account details
      @config = YAML.load_file('config/data/twilio.yml')

      # set up a client to talk to the Twilio REST API
      client = Twilio::REST::Client.new(@config['account_sid'], @config['auth_token'])
      
      #define the account from the Twilio client
      @account = client.account
      
      #Set default data for call. This may be changed later using the class methods
      @from = @config['from']
      @voice_url = @config['url']
      @method = @config['method']
      @digits = ""
    end
  
    #Define the phone number to call to
    def call to
      @number = to
    end
  
    #Define digits to dial when the call connects
    def sending_digits digits
      @digits = digits
    end
  
    #Define a custom Response File to play after the call connects. This file must be stored in a server.
    def using voice_url
      @voice_url = voice_url
    end
  
    #Set the voice url to the defaul presenter file
    def using_default_presenter_voice
      @voice_url = @config['presenter_url']
    end
    
    #Set the voice url to the defaul host file
    def using_default_host_voice
      @voice_url = @config['host_url']
    end
  
    #Set the voice url to the defaul guest file
    def using_default_guest_voice
      @voice_url = @config['guest_url']
    end
  
    #This method should be called last, as it's the one that actually makes the call
    def make_call
      @call = @account.calls.create({:from => @from, 
                                     :to => @number, 
                                     :url => @voice_url, 
                                     :method => @method,
                                     :send_digits => @digits})
    end
  end
end