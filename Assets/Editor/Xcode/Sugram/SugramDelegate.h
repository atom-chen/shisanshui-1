//
//  SugramDelegate.h
//  SDKSugram
//
//  Created by ZengJiadong on 18/04/17.
//
//

#ifndef SugramDelegate_h
#define SugramDelegate_h
#import <UIKit/UIKit.h>
#import "WXApiManager.h"
typedef void(*IntCallBack)(int);
typedef void(*StringCallBack)(const char*);

@interface SugramDelegate : NSObject<WXApiManagerDelegate,UITextViewDelegate>
@property IntCallBack shareCallback;
@property StringCallBack loginCallback;
@property IntCallBack payCallback;

@property NSString* mSchemes;
+ (instancetype)sharedSugramTool;
-(void)initApp:(NSString*) app_id openSchemes:(NSString*) schemes;
-(void)login:(StringCallBack) cb;
-(void)shareText:(NSString*)text type:(int)type callback:(IntCallBack)cb;
-(void)shareImage:(NSString*)img_path icon_path:(NSString*)icon type:(int)type callback:(IntCallBack)cb;
-(void)shareWebPage:(NSString*)url title:(NSString*)title desc:(NSString*)desc icon_path:(NSString*)icon type:(int)type callback:(IntCallBack)cb;
-(void)sugramShareGameRoom:(NSString*)url title:(NSString*)title desc:(NSString*)desc roomId:(NSString*)roomId roomToken:(NSString*)roomToken icon_path:(NSString*)icon type:(int)type callback:(IntCallBack)cb;
-(void)pay:(NSString*)string type:(int)type callback:(IntCallBack)cb;


@end
#endif /* WeChatDelegate_h */
