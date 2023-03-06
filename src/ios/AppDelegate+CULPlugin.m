//
//  AppDelegate+CULPlugin.m
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import "AppDelegate+CULPlugin.h"
#import "CULPlugin.h"

/**
 *  Plugin name in config.xml
 */
static NSString *const PLUGIN_NAME = @"UniversalLinks";

@implementation AppDelegate (CULPlugin)

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    // ignore activities that are not for Universal Links
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb] || userActivity.webpageURL == nil) {
        return NO;
    }
    
    // get instance of the plugin and let it handle the userActivity object
    CULPlugin *plugin = [self.viewController getCommandInstance:PLUGIN_NAME];
    if (plugin == nil) {
        return NO;
    }
    
    return [plugin handleUserActivity:userActivity];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:NSUserActivityTypeBrowsingWeb];
        [activity setWebpageURL:url];
        
        CULPlugin *plugin = [self.viewController getCommandInstance:PLUGIN_NAME];
        return [plugin handleUserActivity:activity];
    }else{
        
         if ([url.absoluteString containsString:@"lacroix://inapp/"]){
            NSString *UrlString = url.absoluteString;
            UrlString = [UrlString stringByReplacingOccurrencesOfString:@"lacroix://inapp/"
                                                 withString:@"https://www.la-croix.com/CustomDeeplink/"];
                    NSURL *composeURL = [NSURL URLWithString:UrlString];
                  //  NSLog(@"UgotMe = %@", composeURL);
                    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:NSUserActivityTypeBrowsingWeb];
                    [activity setWebpageURL:composeURL];
                    CULPlugin *plugin = [self.viewController getCommandInstance:PLUGIN_NAME];
                    return [plugin handleUserActivity:activity];
                   
                }
        return NO;
    }
    
}

@end
