//
//  HistoryStore.h
//

#import <Foundation/Foundation.h>

@class History;

@interface HistoryStore : NSObject
{
    NSMutableArray *allHistorys;
}

+ (HistoryStore *)defaultStore;
- (NSArray *)allHistorys;
- (void)addHistory:(History *)b;
- (void)removeHistory:(History *)b;
- (void)removeAllHistory;
- (void)moveHistoryAtIndex:(int)from toIndex:(int)to;
- (NSString *)historyArchivePath;
- (BOOL)saveChanges;
- (void)fetchHistoryIfNecessary;

@end
