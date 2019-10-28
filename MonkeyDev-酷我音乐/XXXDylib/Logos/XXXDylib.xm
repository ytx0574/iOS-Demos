// See http://iphonedevwiki.net/index.php/Logos

#import <UIKit/UIKit.h>



%hook NSBundle

- (NSString *)bundleIdentifier
{
    return @"com.yeelion.kwplayer";
}

%end
