//
//  UJSInterface.m
//

#import "IAPInterface.h"
#import "IAPManager.h"

@implementation IAPInterface

IAPManager *iapManager = nil;

void InitIAPManager(){
	if (iapManager == nil)
	{
		iapManager = [[IAPManager alloc] init];
		 // 开始注册观察者
		[iapManager attachObserver];
	}
}

// 返回玩家是否开启IAP内购
BOOL IsProductAvailable(){
    return [iapManager CanMakePayment];
}

// plist 获取商品列表信息
void RequstProducts(){
	[iapManager requstProductList];
}

//获取商品列表信息
void RequstProductList(void *p){
	[iapManager requestProductData:[NSString stringWithUTF8String:p]];
}

// 输入商品key列表 获取商品信息
void RequstProductInfo(void *p){	
	// UF8String是因为 C++的字符跟OC的字符不同。
	// 因为接收到的商品id --> p 不完整，需要拼接。
	//NSString * str = @"bundleId.";//bundleId = 'com.xxx.xxx'
	//（注意有个点，因为在iTunesConnet上，商品ID是 ，这里的bundleId.xxx是服务器发给商品ID字符串）
	//NSString * Product = [str stringByAppendingString:pa];
	// 开始请求商品
	[iapManager productInfo:[NSString stringWithUTF8String:p]]; 
}

void BuyProduct(void *uid, void *p){  
	if (iapManager == nil)
	{
		InitIAPManager();
	}
	// 如果已经开启内购
	if (IsProductAvailable()) {
		// 开始执行请求商品行为
		[iapManager buyRequest:[NSString stringWithUTF8String:uid] pid:[NSString stringWithUTF8String:p]];
	}else{
		NSLog(@"不允许程序内付费");
	}	
}

void VerifyPruchase(void *p){
	[iapManager verifyPruchase:[NSString stringWithUTF8String:p]];
}

BOOL PaySuccess(){
	return [iapManager IsPaySuccess];
}
@end
