module Lita
  module Handlers
    class Gittitle < Handler
		  on :loaded, :set_route_issue
      config(:web_endpoint,type: String, required: true)
      config :api_endpoint
      config :token
      # insert handler code here
      route(/(.+\/.+)#([0-9]+)/i,:issue) 
			def set_route_issue(payload)
        regexp = "(http[s]://" + config.web_endpoint + ")\/(.+)\/issues\/([0-9]+)"
        self.class.route(/#{regexp}/i,:issue,help:{"GHEのissueのURL" => "タイトルを返す"})
			end
			def octokit()
				Octokit.reset!
				@@octokit = Octokit::Client.new(
	      :access_token =>config.token,
        :web_endpoint=> config.web_endpoint, 
        :api_endpoint =>config.api_endpoint)
		  end 	
      def issue(response)
				octokit()
        issue =  @@octokit.issue(response.matches[0][1],response.matches[0][2])
	      response.reply(response.matches[0][0] + "/" + response.matches[0][1] + "/issues/" + response.matches[0][2] + "\n" + issue.title)
      end
      Lita.register_handler(self)
    end
  end
end
