//
//  SDKSample
//
//
//

#import <Foundation/Foundation.h>
#import "SugramDelegate.h"
#import "SugramApiManager.h"
#import "AppDelegateListener.h"
#import "Foundation/NSJSONSerialization.h"
#import "UnityAppController.h"
extern "C"
{
    void SugramInit(const char* app_id,const char* openSchemes);
    void SugramLogin(StringCallBack cb);
    void SugramShareText(const char* text,int type,IntCallBack cb);
    void SugramShareImage(const char* img_path,const char* icon_path,int type,IntCallBack cb);
    void SugramShareWebPage(const char* url,const char* title,const char* desc, const char* icon_path,int type,IntCallBack cb);
    void SugramShareGameRoom(const char* url,const char* title,const char* desc, const char* roomId,const char* roomToken, const char* icon_path,int type,IntCallBack cb);
    bool isInstallSugram();
    void SugramGamePay(const char* text,int type, IntCallBack cb);
}
@implementation SugramDelegate

+(instancetype)sharedSugramTool
{
    static dispatch_once_t onceToken;
    static SugramDelegate *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SugramDelegate alloc] init];
    });
    return instance;
}

/**
 * 解析URL参数的工具方法。
 */
+ (NSDictionary *)parseURLParams:(NSString *)query{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *val =[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
    }
    return params;
}

- (void)onOpenURL:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSURL* url = [userInfo valueForKey:@"url"];
    if(url != nil)
    {
        if([url.scheme isEqualToString:_mSchemes]) {
            
            return;
        }
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
}

-(void)initApp:(NSString*) app_id openSchemes:(NSString*) schemes
{
    _mSchemes = schemes;
    [SugramApiManager registerApp:app_id];
    [SugramApiManager showLog:true];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUnityOnOpenURL object:nil];
}

-(void)login:(StringCallBack) cb
{
    _loginCallback = cb;
    
    [SugramApiManager loginState:@"sugram_login_state" fininshBlock:^(SugramLoginCallBackType callBackType, NSString *code, NSString *state) {
        NSString* json = @"{\"code\":\"%@\",\"state\":\"%@\",\"errCode\":\"%d\"}";
        json = [NSString stringWithFormat:json,code,state,callBackType];
        _loginCallback([json UTF8String]);
        json = nil;
    }];
}

-(void)shareText:(NSString*)text type:(int)type callback:(IntCallBack)cb
{
    _shareCallback = cb;
    SugramShareTextObject *req = [[SugramShareTextObject alloc] init];
    req.text = text;
	[SugramApiManager share:req fininshBlock:^(SugramShareCallBackType callBackType) {
        if(_shareCallback != NULL){
            _shareCallback(callBackType);
        }
	}];
}

-(void)shareImage:(NSString*)img_path icon_path:(NSString*)icon type:(int)type callback:(IntCallBack)cb
{
    _shareCallback = cb;
    
	SugramShareImageObject *imageObject = [[SugramShareImageObject alloc] init];
	imageObject.imageData = [NSData dataWithContentsOfFile: img_path];
	[SugramApiManager share:imageObject fininshBlock:^(SugramShareCallBackType callBackType) {
        if(_shareCallback != NULL){
            _shareCallback(callBackType);
        }
	}];
}

-(void)shareWebPage:(NSString*)url title:(NSString*)title desc:(NSString*)desc icon_path:(NSString*)icon type:(int)type callback:(IntCallBack)cb
{
    _shareCallback = cb;
	
	if([SugramApiManager isInstallSugram]) {
        SugramShareGameObject *game = [[SugramShareGameObject alloc] init];
        game.roomToken = @"shareWebPage";
        game.roomId = @"00000";
        game.title = title;
        game.text = desc;
		if ([url isEqualToString:@""]) {
		} else {
			game.androidDownloadUrl = url;
			game.iOSDownloadUrl = url;
		}
        
        game.imageData = [NSData dataWithContentsOfFile: icon];
        [SugramApiManager share:game fininshBlock:^(SugramShareCallBackType callBackType) {
            if(_shareCallback != NULL){
                _shareCallback(callBackType);
            }
        }];
    }	
}

-(void)sugramShareGameRoom:(NSString*)url title:(NSString*)title desc:(NSString*)desc roomId:(NSString*)roomId roomToken:(NSString*)roomToken icon_path:(NSString*)icon type:(int)type callback:(IntCallBack)cb
{
    _shareCallback = cb;
    
    SugramShareGameObject *game = [[SugramShareGameObject alloc] init];
    game.roomToken = roomToken;
    game.roomId = roomId;
    game.title = title;
    game.text = desc;

    if ([url isEqualToString:@""]) {
    } else {
        game.androidDownloadUrl = url;
        game.iOSDownloadUrl = url;
    }
    
    //game.imageUrl = @"http://qylmj.cdn.hfqipai.cn/files/default_head_img.jpg";
    NSData *thumbImage = [NSData dataWithContentsOfFile: icon];
    game.imageData = thumbImage;
    [SugramApiManager share:game fininshBlock:^(SugramShareCallBackType callBackType) {
        if(_shareCallback != NULL){
            _shareCallback(callBackType);
        }
    }];
}

-(void)pay:(NSString*)string type:(int)type callback:(IntCallBack)cb
{    
	_payCallback = cb;
	//TODO::未处理闲聊支付
}

void SugramInit(const char* app_id,const char* openSchemes)
{
    NSString* _id = [NSString stringWithUTF8String:app_id];
    NSString* schemes = [NSString stringWithUTF8String:openSchemes];
    [[SugramDelegate sharedSugramTool] initApp:_id openSchemes:schemes];
}

void SugramLogin(StringCallBack cb)
{
    [[SugramDelegate sharedSugramTool] login:cb];
}

void SugramShareText(const char* text,int type,IntCallBack cb)
{
    [[SugramDelegate sharedSugramTool] shareText:[NSString stringWithUTF8String:text] type:type callback:cb];
}

void SugramShareImage(const char* img_path,const char* icon_path,int type,IntCallBack cb)
{
    [[SugramDelegate sharedSugramTool]shareImage:[NSString stringWithUTF8String:img_path] icon_path:[NSString stringWithUTF8String:icon_path] type:type callback:cb];
}

void SugramShareWebPage(const char* url,const char* title,const char* desc, const char* icon_path,int type,IntCallBack cb)
{
    [[SugramDelegate sharedSugramTool]shareWebPage:[NSString stringWithUTF8String:url] title:[NSString stringWithUTF8String:title]  desc:[NSString stringWithUTF8String:desc]  icon_path:[NSString stringWithUTF8String:icon_path]  type:type callback:cb];
}

void SugramShareGameRoom(const char* url,const char* title,const char* desc,const char* roomId,const char* roomToken, const char* icon_path,int type,IntCallBack cb)
{
    [[SugramDelegate sharedSugramTool]sugramShareGameRoom:[NSString stringWithUTF8String:url] title:[NSString stringWithUTF8String:title]  desc:[NSString stringWithUTF8String:desc] roomId:[NSString stringWithUTF8String:roomId]  roomToken:[NSString stringWithUTF8String:roomToken] icon_path:[NSString stringWithUTF8String:icon_path]  type:type callback:cb];
}

bool isInstallSugram()
{
    return [SugramApiManager isInstallSugram];
}

void SugramGamePay(const char* json,int type,IntCallBack cb)
{
    [[SugramDelegate sharedSugramTool] pay:[NSString stringWithUTF8String:json] type:type callback:cb];
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {   
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)req {
}

/**
 * 分享回调
 */
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {    
    if(_shareCallback != NULL)
    {
        _shareCallback(response.errCode);
    }
}

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response {
}

/**
 * 登陆回调
 */
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
  
    if(_loginCallback != NULL)
    {
        NSString* json = @"{\"code\":\"%@\",\"state\":\"%@\",\"errCode\":\"%d\",\"lang\":\"%@\",\"country\":\"%@\"}";
        
        json = [NSString stringWithFormat:json,response.code,response.state,response.errCode,response.lang,response.country];
        _loginCallback([json UTF8String]);
        json = nil;
    }
}


@end


