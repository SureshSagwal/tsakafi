

#import "Database.h"

@implementation Database
static sqlite3 *database = nil;

+ (void)openDataBase
{
    [self copyDatabaseIfNeeded];
    NSString *dbPath = [self getDBPath];
    NSLog(@"Sqlite version:%s",sqlite3_libversion());
    NSLog(@"Sqlite Path:%@",dbPath);
    sqlite3_shutdown();
    NSLog(@"sqlite3_config: %d", sqlite3_config(SQLITE_CONFIG_SERIALIZED));
    sqlite3_initialize();
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        NSLog(@"DataBaseOpen");
    } else {
        NSAssert1(0, @"Error while openning database. '%s'", sqlite3_errmsg(database));
    }
}

+ (void)closeDataBase
{
    if (sqlite3_close(database) == SQLITE_OK) {
        NSLog(@"DataBaseClose");
    } else {
        NSAssert1(0, @"Error while closing database. '%s'", sqlite3_errmsg(database));
    }
}

+ (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"Coffee.sqlite"];
}

+ (void)copyDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Coffee.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+ (sqlite3 *)getDBConnection
{
    return database;
}


@end
