//
//  IAPManager.h
//  Unity-iPhone
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPManager : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

@property (nonatomic, assign) BOOL initMall; 

@property (nonatomic, assign) BOOL requestFinished; //判断一次请求是否完成

@property (nonatomic, copy) NSString *userId; //交易人

@property (nonatomic,strong) NSArray *productIds;  
  
@property (nonatomic,copy) NSString *currentProId;  

@property (nonatomic, assign) NSInteger actType;

//观察者
-(void)attachObserver;

//是否开启内购
-(BOOL)CanMakePayment;

//下单购买
-(void)buyRequest:(NSString *)uid pid:(NSString *)productIdentifier;

//购买成功否
-(BOOL)IsPaySuccess;

// u3d反向方法，向u3d传值，通知客户购买成功，让服务器去验证结果并且发放道具.
-(void)sendU3dMessage:(SKPaymentTransaction *)transaction;

-(void)requstProductList;

-(void)recordTransaction:(NSString *)bookid;

-(void)provideContent:(NSString *)bookid;

-(void)requestProductData:(NSString *)pids;

-(void)productInfo:(NSString *)productIdentifiers;

-(void)verifyPruchase:(NSString *)productIdentifiers;

-(void)failedTransaction: (SKPaymentTransaction *)tran;

-(void)completeTransaction:(SKPaymentTransaction *)tran;

-(void)deferredTransaction: (SKPaymentTransaction *)tran;

@end
