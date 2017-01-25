# lita-gittitle

github(GHE)のissueのURLを貼るとタイトルを流してくれる

## Installation

Add lita-gittitle to your Lita instance's Gemfile:

``` ruby
gem "lita-gittitle"
```

## Configuration

lita_config.rbに以下を追加(環境変数GH_READ_TOKENにgithubのトークンを設定しておく)

- config.handlers.gittitle.token = ENV['GH_READ_TOKEN']
- config.handlers.gittitle.web_endpoint = 'github.com/'
- config.handlers.gittitle.api_endpoint = 'https://api.github.com/'


## Usage

Slackのプラグインと合わせて使うと便利！
