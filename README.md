#TmbrQuote

iPhoneからTumblrへ簡単にQuoteが送れるアプリです・ω・  

##How To Build
1. Tumblrでアプリケーション登録をして、ConsumerKeyとConsumerSecretを入手してください。
2. SecretConstants.mを作成し、入手したConsumerKeyとConsumerSecretを書き加えて下さい。

##How To Use
1. Safariのブックマークに javascript:window.location='tmbrquote://open_url?url='+document.URL; を追加
2. Quoteしたい文章が含まれるページをSafariで開き、1で追加したブックマークレットを走らせる