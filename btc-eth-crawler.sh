#!/bin/bash


botToken=$(sed -n 1p token.txt)
channelId=$(sed -n 2p token.txt)
chatId=$(sed -n 3p token.txt)

result=$(curl -s https://blockchain.info/ticker | grep TWD)
btcBuy=$(echo $result | grep -oP '"buy" : \K[^,]*(?=,)')
btcSell=$(echo $result | grep -oP '"sell" : \K[^,]*(?=,)')

result=$(curl -s https://www.maicoin.com/api/prices/eth-twd)
ethBuy=$(echo $result | grep -oP '"formatted_buy_price":"\K[^"]*(?=")' | tr -d 'NT$,' )
ethSell=$(echo $result | grep -oP '"formatted_sell_price":"\K[^"]*(?=")' | tr -d 'NT$,' )

preBtcBuy=$(sed -n 1p rate.txt)
preBtcSell=$(sed -n 2p rate.txt)
preEthBuy=$(sed -n 3p rate.txt)
preEthSell=$(sed -n 4p rate.txt)

echo $btcBuy > rate.txt
echo $btcSell >> rate.txt
echo $ethBuy >> rate.txt
echo $ethSell >> rate.txt

diffBtcBuy=$(echo $btcBuy-$preBtcBuy | bc)
diffBtcSell=$(echo $btcSell-$preBtcSell | bc)
diffEthBuy=$(echo $ethBuy-$preEthBuy | bc)
diffEthSell=$(echo $ethSell-$preEthSell | bc)

echo $diffBtcBuy
echo $diffBtcSell
echo $diffEthBuy
echo $diffEthSell

btcBuy=$(printf "%'.2f" $btcBuy)
btcSell=$(printf "%'.2f" $btcSell)
ethBuy=$(printf "%'.2f" $ethBuy)
ethSell=$(printf "%'.2f" $ethSell)

_diffBtcBuy=$(printf "%'.2f" $diffBtcBuy)
_diffBtcSell=$(printf "%'.2f" $diffBtcSell)
_diffEthBuy=$(printf "%'.2f" $diffEthBuy)
_diffEthSell=$(printf "%'.2f" $diffEthSell)

diffBtcBuy=$([ $(echo "$diffBtcBuy >= 0" | bc -l) = 1 ] && echo "📈 $_diffBtcBuy" || echo "📉 $_diffBtcBuy" )
diffBtcSell=$([ $(echo "$diffBtcSell >= 0" | bc -l) = 1 ] && echo "📈 $_diffBtcSell" || echo "📉 $_diffBtcSell" )
diffEthBuy=$([ $(echo "$diffEthBuy >= 0" | bc -l) = 1 ] && echo "📈 $_diffEthBuy" || echo "📉 $_diffEthBuy" )
diffEthSell=$([ $(echo "$diffEthSell >= 0" | bc -l) = 1 ] && echo "📈 $_diffEthSell" || echo "📉 $_diffEthSell" )



sendText="
比特幣匯率💸
買入 : <b>NT\$$btcBuy</b> ( $diffBtcBuy )
賣出 : <b>NT\$$btcSell</b> ( $diffBtcSell )
﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎
乙太幣匯率💰
買入 : <b>NT\$$ethBuy</b> ( $diffEthBuy )
賣出 : <b>NT\$$ethSell</b> ( $diffEthSell )
﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎
"

url="https://api.telegram.org/bot"$botToken"/sendMessage"
data="chat_id=@"$channelId"&text="$sendText"&parse_mode=HTML"
data="chat_id="$chatId"&text="$sendText"&parse_mode=HTML"
curl "$url" --data "$data"