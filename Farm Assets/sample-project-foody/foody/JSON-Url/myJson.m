
#import "myJson.h"


@implementation Json

@synthesize receivedData;
@synthesize delegate;

+ (NSString *)stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
    
    // Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    
}

+ (id) objectWithUrl:(NSURL *)url
{

	SBJSON *jsonParser = [SBJSON new];
	NSString *jsonString = [self stringWithUrl:url];
	
	return [jsonParser objectWithString:jsonString error:NULL];
}


-(void)startLoadingObjectWithUrl:(NSString*)urlString andDelegate:(id<myJsonDelegate>)del;
{
    self.delegate = del;
    NSURL *url = [NSURL URLWithString:urlString];
    
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];

	    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
 	if (theConnection) {
               receivedData = [NSMutableData data];
    }

}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    NSString* jsonString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    SBJSON *jsonParser = [SBJSON new];
	
    id jsonObject = [jsonParser objectWithString:jsonString error:NULL];

    
    [delegate dataRequestCompletedWithJsonObject:jsonObject];

}

@end