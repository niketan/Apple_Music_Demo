

#import "ViewController.h"
#import "ServerConnection.h"
#import <CoreData/CoreData.h>

@interface ViewController () <ConnectionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self callWSNewFeed];
    
    [self getResultData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)callWSNewFeed{
    
    [SVProgressHUD show];
    [[ServerConnection sharedConnectionWithDelegate:self] requestWithURL:REQUESTURL method:@"GET" data:nil withImages:nil withVideo:nil];
    
}

-(void)getResultData {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Results"];
    NSArray *arr_List = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSLog(@"%@", arr_List);
}

#pragma mark - Server Connection Delegate -

- (void)ConnectionDidFinishRequestURL: (NSString*)reqURL Data:(NSMutableDictionary*) dictData
{
    
    NSLog(@"%@",dictData);
    [SVProgressHUD dismiss];
    
    NSManagedObjectContext *context = [self managedObjectContext];

    NSArray *arr_results = [[dictData allValues][0] valueForKey:@"results"];

    for (int i = 0; i < arr_results.count; i++) {
        NSDictionary *dict = arr_results[i];
        // Create a new managed object
        
        NSManagedObject *result = [NSEntityDescription insertNewObjectForEntityForName:@"Results" inManagedObjectContext:context];
        
        [result setValue:dict[@"artistId"] forKey:@"artistId"];
        [result setValue:dict[@"artistName"] forKey:@"artistName"];
        [result setValue:dict[@"artistUrl"] forKey:@"artistUrl"];
        [result setValue:dict[@"artworkUrl100"] forKey:@"artworkUrl100"];
        [result setValue:dict[@"contentAdvisoryRating"] forKey:@"contentAdvisoryRating"];
        [result setValue:dict[@"copyright"] forKey:@"copyright"];
        [result setValue:dict[@"genreNames"] forKey:@"genreNames"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
}
- (void)ConnectionDidFailRequestURL: (NSString*)reqURL  Data: (NSString*)nData
{
    
    [SVProgressHUD dismiss];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
