@interface Clipboard : NSObject

#define MakeStringCopy( _x_ ) ( _x_ != NULL && [_x_ isKindOfClass:[NSString class]] ) ? strdup( [_x_ UTF8String] ) : NULL

extern "C"
{
    /*  compare the namelist with system processes  */
    void _copyTextToClipboard(const char *textList);
	char* _getTextFromClipboard();
}

@end


@implementation Clipboard

//将文本复制到IOS剪贴板
-(void)objc_copyTextToClipboard : (NSString*)text
{
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  pasteboard.string = text;
}

@end

extern "C" {
	static Clipboard *iosClipboard;
	
	void _copyTextToClipboard(const char *textList)
	{   
		NSString *text = [NSString stringWithUTF8String: textList] ;
		if(iosClipboard == NULL)
		{
			iosClipboard = [[Clipboard alloc] init];
		}
		[iosClipboard objc_copyTextToClipboard: text];
	}
	
    char* _getTextFromClipboard()
    {
        NSString * text = NULL;
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        if(pasteboard != NULL)
        {
            text = pasteboard.string;
        }
        return MakeStringCopy(text);
    }
}
