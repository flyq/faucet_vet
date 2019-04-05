主网合约地址在 `0x85819B115b20396bE1d953b3FB530909d64260A6`

测试合约地址在 `0x15456B9aBCFAd1C7BfD8b1c2cd643d69cfc38f23`

   


## 接口：    
call：    
`getDonations(_index)`
拿到排名为_index的捐赠数据   
_index为 `1 - getDonationAmount()`   

`getDonationAmount()`   
拿到一共有多少人捐赠   

`todayAsked()`   
今天有多少地址领取了   

`lastGetTime(address)`   
该用户上次领取是多少时间（48小时后才能领）   
 
`getBlance()`   
水龙头里面还有多少水 VTHO   

`donationAddrs(index)`    
捐赠者地址（注意，这个地址是按照时间顺序做的）   
index从 ` 0 - (getDonationAmount()-1)`   

`donations(address)`   
返回该捐赠者的具体信息    
   

send:  
`askVTHO(uint256 _a)`   
用户拿vtho   
   
`donate()`   
用户捐赠VTHO   



## VTHO合约
需要先调用approve函数：
https://github.com/vechain/thor/blob/master/builtin/gen/energy.sol#L62

地址
0x0000000000000000000000000000456e65726779

`approve(address, uint256)`
address是我们水龙头合约的地址
uint256是数量比如 `1 vet` 需要传 `1000000000000000000`


## 提示
根据VeChain智能合约设计，要想本合约根据捐赠的事件并运行代码，需要先调用`VTHO合约`的`approve()`然后再调用本合约的函数。因此需要用同一地址签名两次
According to the design of the VeChain, in order for this contract to run the code, you need to call the `approve()` of the `VTHO contract` and then call the function of this contract. So you need to sign twice with the same address.

