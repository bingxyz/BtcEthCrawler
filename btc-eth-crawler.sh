#!/bin/bash
cd ~/code/BtcEthCrawler

botToken=$(sed -n 1p token.txt)
channelId=$(sed -n 2p token.txt)
chatId=$(sed -n 3p token.txt)

result=$(curl -s "https://api.bitfinex.com/v2/tickers?symbols=tBTCUSD")
btcBuy=$(echo $result | jq '.[0][3]' )
btcSell=$(echo $result | jq '.[0][1]' )

result=$(curl -s "https://api.bitfinex.com/v2/tickers?symbols=tETHUSD")
ethBuy=$(echo $result | jq '.[0][3]' )
ethSell=$(echo $result | jq '.[0][1]' )

result=$(curl -s "https://api.bitfinex.com/v2/tickers?symbols=tLTCUSD")
ltcBuy=$(echo $result | jq '.[0][3]' )
ltcSell=$(echo $result | jq '.[0][1]' )

result=$(curl -s "https://api.bitfinex.com/v2/tickers?symbols=tIOTUSD")
iotBuy=$(echo $result | jq '.[0][3]' )
iotSell=$(echo $result | jq '.[0][1]' )

preBtcBuy=$(sed -n 1p rate.txt)
preBtcSell=$(sed -n 2p rate.txt)
preEthBuy=$(sed -n 3p rate.txt)
preEthSell=$(sed -n 4p rate.txt)
preLtcBuy=$(sed -n 5p rate.txt)
preLtcSell=$(sed -n 6p rate.txt)
preIotBuy=$(sed -n 7p rate.txt)
preIotSell=$(sed -n 8p rate.txt)

echo $btcBuy > rate.txt
echo $btcSell >> rate.txt
echo $ethBuy >> rate.txt
echo $ethSell >> rate.txt
echo $ltcBuy >> rate.txt
echo $ltcSell >> rate.txt
echo $iotBuy >> rate.txt
echo $iotSell >> rate.txt

diffBtcBuy=$(echo $btcBuy-$preBtcBuy | bc)
diffBtcSell=$(echo $btcSell-$preBtcSell | bc)
diffEthBuy=$(echo $ethBuy-$preEthBuy | bc)
diffEthSell=$(echo $ethSell-$preEthSell | bc)
diffLtcBuy=$(echo $ltcBuy-$preLtcBuy | bc)
diffLtcSell=$(echo $ltcSell-$preLtcSell | bc)
diffIotBuy=$(echo $iotBuy-$preIotBuy | bc)
diffIotSell=$(echo $iotSell-$preIotSell | bc)

echo $diffBtcBuy
echo $diffBtcSell
echo $diffEthBuy
echo $diffEthSell
echo $diffLtcBuy
echo $diffLtcSell
echo $diffIotBuy
echo $diffIotSell

btcBuy=$(printf "%'.2f" $btcBuy)
btcSell=$(printf "%'.2f" $btcSell)
ethBuy=$(printf "%'.2f" $ethBuy)
ethSell=$(printf "%'.2f" $ethSell)
ltcBuy=$(printf "%'.2f" $ltcBuy)
ltcSell=$(printf "%'.2f" $ltcSell)
iotBuy=$(printf "%'.4f" $iotBuy)
iotSell=$(printf "%'.4f" $iotSell)

_diffBtcBuy=$(printf "%'.2f" $diffBtcBuy)
_diffBtcSell=$(printf "%'.2f" $diffBtcSell)
_diffEthBuy=$(printf "%'.2f" $diffEthBuy)
_diffEthSell=$(printf "%'.2f" $diffEthSell)
_diffLtcBuy=$(printf "%'.2f" $diffLtcBuy)
_diffLtcSell=$(printf "%'.2f" $diffLtcSell)
_diffIotBuy=$(printf "%'.4f" $diffIotBuy)
_diffIotSell=$(printf "%'.4f" $diffIotSell)

diffBtcBuy=$([ $(echo "$diffBtcBuy >= 0" | bc -l) = 1 ] && echo "📈 $_diffBtcBuy" || echo "📉 $_diffBtcBuy" )
diffBtcSell=$([ $(echo "$diffBtcSell >= 0" | bc -l) = 1 ] && echo "📈 $_diffBtcSell" || echo "📉 $_diffBtcSell" )
diffEthBuy=$([ $(echo "$diffEthBuy >= 0" | bc -l) = 1 ] && echo "📈 $_diffEthBuy" || echo "📉 $_diffEthBuy" )
diffEthSell=$([ $(echo "$diffEthSell >= 0" | bc -l) = 1 ] && echo "📈 $_diffEthSell" || echo "📉 $_diffEthSell" )
diffLtcBuy=$([ $(echo "$diffLtcBuy >= 0" | bc -l) = 1 ] && echo "📈 $_diffLtcBuy" || echo "📉 $_diffLtcBuy" )
diffLtcSell=$([ $(echo "$diffLtcSell >= 0" | bc -l) = 1 ] && echo "📈 $_diffLtcSell" || echo "📉 $_diffLtcSell" )
diffIotBuy=$([ $(echo "$diffIotBuy >= 0" | bc -l) = 1 ] && echo "📈 $_diffIotBuy" || echo "📉 $_diffIotBuy" )
diffIotSell=$([ $(echo "$diffIotSell >= 0" | bc -l) = 1 ] && echo "📈 $_diffIotSell" || echo "📉 $_diffIotSell" )



sendText="
比特幣匯率💸
買入 : <b>USD\$$btcBuy</b> ( $diffBtcBuy )
賣出 : <b>USD\$$btcSell</b> ( $diffBtcSell )
﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎
乙太幣匯率💰
買入 : <b>USD\$$ethBuy</b> ( $diffEthBuy )
賣出 : <b>USD\$$ethSell</b> ( $diffEthSell )
﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎
萊特幣匯率💵
買入 : <b>USD\$$ltcBuy</b> ( $diffLtcBuy )
賣出 : <b>USD\$$ltcSell</b> ( $diffLtcSell )
﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎
IOTA匯率🤑
買入 : <b>USD\$$iotBuy</b> ( $diffIotBuy )
賣出 : <b>USD\$$iotSell</b> ( $diffIotSell )
﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎﹎
"

url="https://api.telegram.org/bot"$botToken"/sendMessage"
data="chat_id=@"$channelId"&text="$sendText"&parse_mode=HTML"
#data="chat_id="$chatId"&text="$sendText"&parse_mode=HTML"
curl "$url" --data "$data"

