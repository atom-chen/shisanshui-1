//
//  IAPManager.m
// -fno-objc-arc

#import "IAPManager.h"

@implementation IAPManager

/*
#ifdef __cplusplus
extern "C"{
#endif
    // 这是反向传信息给u3d的方法，内容可以自定。
    extern void UnitySendMessage(const char *, const char*, const char*);
#ifdef __cplusplus
}
#endif
*/

-(void) attachObserver{
    NSLog(@"AttachObserver");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

// 向Unity传递交易结果的信息
- (void)sendU3dMessage:(SKPaymentTransaction *)tran{
	NSString *jsonData = @"";
	
	NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
	NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
	if(!receipt){
		NSLog(@"erorr:receipt is null");
	}
	else{
        NSString *base64Encoding=[receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
		NSString *productIdentifier = tran.payment.productIdentifier;
		NSString *transactionIdentifier = tran.transactionIdentifier;
        
		NSDictionary *dict = @{
			@"base64Encoding":base64Encoding,
			@"productIdentifier":productIdentifier,
            @"transactionIdentifier":transactionIdentifier,
            @"state":[NSString stringWithFormat:@"%li",tran.error.code]
			};
			
		NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
		jsonData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	
    //NSLog(@"%@",jsonData);
    UnitySendMessage("StoreManager", "PaymentCallback", [jsonData UTF8String]);
}

-(void)sendRequest:(NSSet *) nsset{
	self.requestFinished = NO;
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}

-(BOOL) CanMakePayment{
    return [SKPaymentQueue canMakePayments];
}

//获取数据列表
-(void)requstProductList {
    
	// 1.请求所有的商品ID
	NSString *productFilePath = [[NSBundle mainBundle] pathForResource:@"products.plist" ofType:nil];
	NSArray *products = [NSArray arrayWithContentsOfFile:productFilePath];

	// 2.获取所有的productid
	NSArray *productIds = [products valueForKeyPath:@"products"];

	// 3.获取productid的set(集合中)
	NSSet *set = [NSSet setWithArray:productIds];

	// 4.向苹果发送请求,请求可卖商品
	[self sendRequest:set];
}


-(void)requestProductData:(NSString *)pids {
    NSArray *idArray = [pids componentsSeparatedByString:@"\t"];
    NSSet *idSet = [NSSet setWithArray:idArray];
    [self sendRequest:idSet];
}

//接收商品信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
	self.initMall = YES;
    NSArray *products = response.products;
	
    if ([products count] > 0) {
		for (SKProduct *pro in products) {
			if([pro.productIdentifier isEqualToString:_currentProId]){
                switch (_actType) {
                    case 1:
                        [self productInfo:_currentProId];
                        break;
                    case 2:
                        [self buyRequestByProduct:pro];
                        break;
                    default:
                        break;
                }
			}
        }
	}
			
	//无效产品
	for(NSString *invalidProductId in response.invalidProductIdentifiers){
		NSLog(@"Invalid product id:%@",invalidProductId);
	}
	
	_productIds = products;	
    _currentProId = nil;
	_actType = 0;
	
    //自动释放
    //[request autorelease];
}

//购买商品
-(void)buyRequest:(NSString *)uid pid:(NSString *)productIdentifier {	
	if([self CanMakePayment]){
		_userId = uid;
		_currentProId = productIdentifier;
		/*
		SKPayment * payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
		*/
		if (self.initMall != YES){
			_actType = 2;
			[self requstProductList];
		}else{
			if(_productIds != NULL && [_productIds count] > 0){
				for (SKProduct * pro in _productIds){
					if([pro.productIdentifier isEqualToString:productIdentifier]){
						[self buyRequestByProduct:pro];
						break;
					}
				}
			}else{
				[self showMsg:@"没有付费商品!"];
			}
		}
	}
	else{
		[self showMsg:@"不允许程序内付费!"];
	}
}

// 购买请求
- (void)buyRequestByProduct:(SKProduct *)product{
	/*
    NSLog(@"描述信息:%@", [product description]);
    NSLog(@"产品标题:%@", [product localizedTitle]);
    NSLog(@"产品描述信息:%@", [product localizedDescription]);
    NSLog(@"价格:%@", [product price]);
    NSLog(@"购买产品id:%@", [product productIdentifier]);
	*/    
    SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity=1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(BOOL)IsPaySuccess{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        SKPaymentTransaction* transaction = [transactions firstObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            NSLog(@"购买成功: %@",transaction.transactionIdentifier);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
			return true;
        }
    }
    return false;
}

//弹出错误信息
- (void)showMsg:(NSString *)msg{
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", NULL) message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil];
    [alerView show];
}

// 请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"------------------错误-----------------:%@", error);
	[self showMsg:@"请求失败请重试!"];
}

//商品信息
-(void)productInfo:(NSString *)productIdentifiers {
	if (self.initMall != YES){
		_actType = 1;
		[self requstProductList];
	}
	else{
		NSString *jsonData = @"";
		if(_productIds != NULL && [_productIds count] > 0){
			for (SKProduct * pro in _productIds){
				if([pro.productIdentifier isEqualToString:productIdentifiers]){
					NSDictionary *dict = @{
						@"productIdentifier":productIdentifiers,			//商品编号
						@"localizedTitle":pro.localizedTitle,				//商品名称
						@"localizedDescription":pro.localizedDescription,	//本地化描述
						@"description":pro.description,						//描述
						@"price":pro.price									//商品单价
						};
						
					NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
					jsonData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
					break;
				}
			}
		}else{
			[self showMsg:@"没有查询到该商品!"];
		}
		UnitySendMessage("StoreManager", "ProvideContent", [jsonData UTF8String]);
	}
}

//监听购买结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
			 case SKPaymentTransactionStatePurchasing:
                NSLog(@"用户正在购买...");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"购买成功!");
				[self completeTransaction:tran];
				//验证凭据
				//[self verifyPruchase:tran];
                break;
            case SKPaymentTransactionStateFailed:
				NSLog(@"支付失败!");
				[self failedTransaction:tran];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"恢复购买!");
				[self restoreTransaction:tran];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"需要家长确认!");
                [self deferredTransaction:tran];
                break;
            default:
                break;
        }
    }
}

// 交易失败
-(void)failedTransaction: (SKPaymentTransaction *)tran {
    NSLog(@"errorCode %ld",tran.error.code);
	NSString * msg = @"";
    if(tran.error.code != SKErrorPaymentCancelled){
		msg = @"交易失败！";
    }else {
        msg = @"用户取消购买！！" ;
    }
	[self showMsg:msg];
    
	// 将交易从交易队列中删除
	[[SKPaymentQueue defaultQueue] finishTransaction:tran];
    [self sendU3dMessage:tran];
}

// 恢复购买
-(void)restoreTransaction:(SKPaymentTransaction *)tran {
    // 恢复已经完成的所有交易.（仅限永久有效商品）	
	//[self provideContentForProductIdentifier:tran.originalTransaction.payment.productIdentifier];
	
	// 将交易从交易队列中删除
	[[SKPaymentQueue defaultQueue] finishTransaction:tran];
    [self sendU3dMessage:tran];
}

//购买成功
-(void)completeTransaction:(SKPaymentTransaction *)tran {
	NSLog(@"购买成功----->");
    NSString *product = tran.payment.productIdentifier;
    if([product length] > 0)
    {
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
        NSLog(@"pid: %@", product);
        [self sendU3dMessage:tran];
    }
	[[SKPaymentQueue defaultQueue] finishTransaction:tran];
}

-(void)deferredTransaction: (SKPaymentTransaction *)tran {
    [self showMsg:@"需要家长确认购买!"];
    // 将交易从交易队列中删除
    [[SKPaymentQueue defaultQueue] finishTransaction:tran];
    [self sendU3dMessage:tran];
}

 //记录交易
-(void)recordTransaction:(NSString *)bookid{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)bookid{
    NSLog(@"-----下载--------");
}

-(void)requestDidFinish:(SKRequest *)request {
    NSLog(@"反馈信息结束");
}

- (void)dealloc{
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark 验证购买凭据
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
//验证凭据
- (void)verifyPruchase: (SKPaymentTransaction *)tran  {
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:SANDBOX];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
	
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
	NSString *msg = @"";
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
		msg = @"error";
    }else{
		NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
		NSLog(@"%@",dic);
		if([dic[@"status"] intValue]==0){
			NSLog(@"购买通过验证！");
			NSDictionary *dicReceipt= dic[@"receipt"];
			NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
			NSString *pId= dicInApp[@"product_id"];//读取产品标识
			NSString *transaction_id= dicInApp[@"transaction_id"];//读取订单号
			NSString *purchase_date= dicInApp[@"purchase_date"];//交易日期
			
			//如果是消耗品则记录购买数量，非消耗品则记录是否购买过
			NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
			if ([pId isEqualToString:tran.transactionIdentifier]) {
				NSInteger purchasedCount=[defaults integerForKey:pId];//已购买数量
				[[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:pId];
			}else{
				[defaults setBool:YES forKey:pId];
			}
			msg = @"success";
			//在此处对购买记录进行存储，可以存储到开发商的服务器端
		}else{
			msg = @"failed";
			NSLog(@"购买失败，未通过验证！");
		}
	}
	UnitySendMessage("StoreManager", "PaymentFinish", [msg UTF8String]);
}

@end
