module Lita
  module Handlers
    class Gittitle < Handler
		  on :loaded, :define_github_url
      config(:web_endpoint,type: String, required: true)
      config :api_endpoint
      config :token
      # insert handler code here
      #route(/git.pepabo.com\/(.+)\/issues\/([0-9]+)/i,:issue,help:{"GHEのissueのURL" => "タイトルを返す"})
      route(/(.+\/.+)#([0-9]+)/i,:issue) 
			def define_github_url(payload)
        regexp = config.web_endpoint + "\/(.+)\/issues\/([0-9]+)"
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
        issue =  @@octokit.issue(response.matches[0][0],response.matches[0][1])
	      response.reply("https://git.pepabo.com/" + response.matches[0][0] + "/issues/" + response.matches[0][1] + "\n" + issue.title)
      end
      Lita.register_handler(self)
    end
  end
end
