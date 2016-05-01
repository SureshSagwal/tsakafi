

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject
+ (void)openDataBase;
+ (sqlite3 *)getDBConnection;
+ (void)closeDataBase;

@end
