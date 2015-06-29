module UrlsHelper
	# AZ27062016: add address to model data, needed for warning message
    def set_url_host_model
      if @url.present?
        @url.url_host = @url_host
      end
    end    

	# AZ27062016: build address here, needs less requests than in the view
    def set_url_host      
      @url_host = request.protocol() + request.host_with_port() + '/'             
    end
end
