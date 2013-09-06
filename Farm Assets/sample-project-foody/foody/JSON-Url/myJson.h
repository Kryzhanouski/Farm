

#import <Foundation/Foundation.h>
#import "JSON.h"

@protocol  myJsonDelegate;

@interface Json : NSObject {
    
    NSMutableData *receivedData;
}

@property (nonatomic, retain) NSMutableData *receivedData;

@property (nonatomic, assign) id<myJsonDelegate> delegate;

+ (NSString *)stringWithUrl:(NSURL *)url;
+ (id) objectWithUrl:(NSURL *)url;

-(void)startLoadingObjectWithUrl:(NSString*)urlString andDelegate:(id<myJsonDelegate>)delegate;
@end

@protocol myJsonDelegate <NSObject>

-(void)dataRequestCompletedWithJsonObject:(id)jsonObject;

@end
