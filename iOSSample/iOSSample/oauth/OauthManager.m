//
//  OauthManager.m
//  iOSSample
//
//  Created by Daniel Albert Sánchez on 30/4/15.
//  Copyright (c) 2015 Zyncro Tech. All rights reserved.
//

#import "OauthManager.h"

static NSString * const kBaseUrl = @"ZYNCRO_ENV_URL_HERE_ENDING_BY_/";
static NSString * const kConsumerKey = @"CONSUMER_KEY";
static NSString * const kConsumerSecret = @"CONSUMER_SECRET";
static NSString * const kRequestTokenUrl = @"tokenservice/oauth/v1/get_request_token";
static NSString * const kRequestTokenCallback = @"oob";
static NSString * const kAuthorizeUrl = @"tokenservice/oauth/v1/NoBrowserAuthorization";
static NSString * const kAccessTokenUrl = @"tokenservice/oauth/v1/get_access_token";


@implementation OauthManager {
    BDBOAuth1SessionManager *sessionManager;
}

+ (id)sharedManager {
    static OauthManager *sharedManager = nil;
    @synchronized(self) {
        if (sharedManager == nil)
            sharedManager = [[self alloc] init];
    }
    return sharedManager;
}


- (void) oauthLogin:(NSString *)user password:(NSString *)password success:(void (^)(NSString *token))success failure:(void (^)(NSError *error))failure {
    [self initSessionManager];
    [self getRequestTokenWithSuccess:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Request token success");
        [self authorizeUser:user password:password requestToken:requestToken success:^(BDBOAuth1Credential *requestToken) {
            NSLog(@"Authorize user success");
            [self getAccessToken:requestToken success:^(BDBOAuth1Credential *requestToken) {
                NSLog(@"Access token success");
                success(requestToken.token);
            } failure:^(NSError *error) {
                NSLog(@"Access token error");
                failure(error);
            }];
        } failure:^(NSError *error) {
            NSLog(@"Authorize user error");
        }];
    } failure:^(NSError *error) {
        NSLog(@"Request token error");
        
    }];
    
}


- (void) initSessionManager {
    sessionManager = [[BDBOAuth1SessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]
                                                          consumerKey:kConsumerKey
                                                       consumerSecret:kConsumerSecret];
}


- (void) getRequestTokenWithSuccess:(void (^)(BDBOAuth1Credential *requestToken))success
                            failure:(void (^)(NSError *error))failure {
    [sessionManager deauthorize];
    [sessionManager fetchRequestTokenWithPath:[kRequestTokenUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                       method:@"POST"
                                  callbackURL:[NSURL URLWithString:kRequestTokenCallback]
                                        scope:nil
                                      success:^(BDBOAuth1Credential *result) {
                                          // Request Token Success
                                          success(result);
                                          
                                      } failure:^(NSError *error) {
                                          // Request Token Fail
                                          failure(error);
                                      }];
    
}

- (void) authorizeUser:(NSString *) user password:(NSString *) password requestToken:(BDBOAuth1Credential *)requestToken success:(void (^)(BDBOAuth1Credential *requestToken))success failure:(void (^)(NSError *error))failure  {
    NSDictionary *params = @{
                             @"username": user,
                             @"password": password,
                             @"request_token": requestToken.token
                             };
    
    [sessionManager POST:[kAuthorizeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
              parameters:params
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     // Check User Success
                     NSDictionary *headers = [(NSHTTPURLResponse *)task.response allHeaderFields];
                     NSString *authenticatedUserAppId = headers[@"oauth_userid"];
                     requestToken.verifier = requestToken.secret;
                     success(requestToken);
                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                     // Check User Fail
                     failure(error);
                 }];
    
}

- (void) getAccessToken:(BDBOAuth1Credential *)requestToken success:(void (^)(BDBOAuth1Credential *requestToken))success failure:(void (^)(NSError *error))failure {
    [sessionManager fetchAccessTokenWithPath:[kAccessTokenUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                      method:@"POST"
                                requestToken:requestToken
                                     success:^(BDBOAuth1Credential *accessToken) {
                                         // Access Token Success
                                         success(accessToken);
                                     } failure:^(NSError *error) {
                                         // Access Token Fail
                                         failure(error);
                                     }];
}



@end
