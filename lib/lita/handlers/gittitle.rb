module Lita
  module Handlers
    class Gittitle < Handler
      config :web_endpoint
      config :api_endpoint
      config :token
      # insert handler code here
      route(/git.pepabo.com\/(.+)\/issues\/([0-9]+)/i,
             :issue,help:{"GHEのissueのURL" => "タイトルを返す"})
      route(/(.+\/.+)#([0-9]+)/i,:issue) 
      def issue(response)
        octocat = Octokit::Client.new(
	          :access_token =>config.token,
		  :web_endpoint=> config.web_endpoint, 
		  :api_endpoint =>config.api_endpoint)
        issue =  octocat.issue(response.matches[0][0],response.matches[0][1]);
	response.reply("https://git.pepabo.com/" + response.matches[0][0] + "/issues/" + response.matches[0][1] + "\n" + issue.title)
      end
      Lita.register_handler(self)
    end
  end
end
