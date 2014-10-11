//
//  WebService.h
//  HackZurich
//
//  Created by Patrick Amrein on 11/10/14.
//  Copyright (c) 2014 Laurin Brandner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Feed.h"

@interface WebService : NSObject

+(WebService *) sharedService;

@property (strong, nonatomic) NSString *deviceToken;

//WebService Implementations

/*
 Register Function
PRE: 
        Username: the username (!!!always an E-Mailaddress !!!) used for the Webservice
        Password: Password in cleartext (Connection via https)
        PushToken (generated by the UIApplication remote thing): used for PushMessages
 
 POST: null or a User Objective representing the user which is logged in
 IMPORTANT: Send the auth-token in the User-INstance for every further request
 
*/

-(User *)registerUser:(NSString *)username withPassword:(NSString *)password andDeviceToken:(NSString *)token;

/*
 Login Function

 PRE:
        Username: the username (!!!always an E-Mailaddress !!!) used for the Webservice
        Password: Password in cleartext (Connection via https)
        PushToken (generated by the UIApplication remote thing): used for PushMessages
 
 POST: null or a User Objective representing the user which is logged in
        IMPORTANT: Send the auth-token in the User-INstance for every further request
 */
-(User *)login:(NSString *)username withPassword:(NSString*)password andPushToken:(NSString *)token;

/*
 Create New Input Feed 
 IMPORTANT NO FILTER FOR INPUTFEED
 PRE:
        Name: A name for the feed 
        Description: Describe the way your feed is acting on the input
        Uri: Pointer to a online ressource of an ICS file
[OPTIONAL] Filter: The Filter rules including the included InputFeeds (DO NOT SET FOR INPUTFEED!!!)
 
 POST:
        Null or generated Feed Object
 */
-(Feed *)createNewInputFeedWithName:(NSString *) name withDescription:(NSString *)desc withUri:(NSString *)uri;

/*
 Create New Input Feed
 IMPORTANT NO FILTER FOR INPUTFEED
 PRE:
        Name: A name for the feed
        Description: Describe the way your feed is acting on the input
        Uri: Pointer to a online ressource of an ICS file
        [OPTIONAL] Filter: The Filter rules including the included InputFeeds (DO NOT SET FOR INPUTFEED!!!)
 
 POST:
 Null or generated Feed Object
 */
-(Feed *)createNewFeedWithName:(NSString *) name withDescription:(NSString *)desc withFilters:(NSArray<Filter> *)filters;


/*
 Create NewFilter
 PRE:
        Output: A reference to the Feed which uses this Filter
        Rules: Array of Rule Objects representing each either a string or a tag
        Inputs: An Input array of feed objects (pointing to a ICS online ressource)
 
 POST:
        Null or generated Filter Object
 
 */
-(Filter *)createNewFilterWithBaseFeed:(Feed *) feed filteringForRules:(NSArray<Rule> *)rules includingFeeds:(NSArray<Feed>*) inputFeeds;


@end
