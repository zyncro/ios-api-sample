//
//  OauthManager.h
//  iOSSample
//
//  Created by Daniel Albert Sánchez on 30/4/15.
//  Copyright (c) 2015 Zyncro Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>

@interface OauthManager : NSObject

+ (id)sharedManager;
- (void) oauthLogin:(NSString *) user password:(NSString *) password success:(void (^)(NSString *token))success failure:(void (^)(NSError *error))failure;

@end
