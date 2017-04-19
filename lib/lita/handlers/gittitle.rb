module Lita
  module Handlers
    class Gittitle < Handler
		  on :loaded, :set_route_title
      config(:web_endpoint,type: String, required: true)
      config :api_endpoint
      config :token
      config :bots
      # insert handler code here
      route(/(.+\/.+)#([0-9]+)/i,:issue) 
			def set_route_title(payload)
        regexp = "(http[s]://" + config.web_endpoint + ")\/(.+)\/(issues|pull)\/([0-9]+)"
        self.class.route(/#{regexp}/i,:title,help:{"GHEのissueのURL" => "タイトルを返す"})
			end
			def octokit()
				Octokit.reset!
				@@octokit = Octokit::Client.new(
	      :access_token =>config.token,
        :web_endpoint=> config.web_endpoint, 
        :api_endpoint =>config.api_endpoint)
		  end 	
      def title(response)
				octokit()
        mname = response.user.metadata['mention_name']
        bots = config.bots.split(",")
        is_bot = false
        bots.each do |bot|
          if bot == mname
             p "bot!" + mname
             is_bot = true
          else
             p "not bot!" + mname
          end
        end
        if is_bot == false
        issue =  @@octokit.issue(response.matches[0][1],response.matches[0][3])
        response.reply(response.matches[0][0] + "/" + response.matches[0][1] + "/"+response.matches[0][2]+"/" + response.matches[0][3] + "\n" + issue.title)
        else
          response.reply("BOTかー")
        end
      end
      Lita.register_handler(self)
    end
  end
end
