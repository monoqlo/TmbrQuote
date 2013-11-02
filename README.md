#TmbrQuote

iPhoneからTumblrへ簡単にQuoteが送れるアプリです・ω・  

##How To Build
1. Tumblrでアプリケーション登録をして、ConsumerKeyとConsumerSecretを入手してください。
2. SecretConstants.mを作成し、入手したConsumerKeyとConsumerSecretを書き加えて下さい。

##How To Use
1. TmbrQuoteを起動してTumblrのOAuth認証を済ませておく
2. Safariのブックマークに javascript:window.location='tmbrquote://open_url?url='+document.URL; を追加
3. Quoteしたい文章が含まれるページをSafariで開き、2で追加したブックマークレットを走らせる
4. TmbrQuoteが立ち上がり、Safariで開いていたページが表示されるので、文字列選択をして右上のボタンを押す
5. 編集したい項目があったら編集し投稿する