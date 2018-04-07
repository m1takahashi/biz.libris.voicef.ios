//
//  FileHelpers.m
//

#import "FileHelpers.h"

// ファイル名を渡すとDocumentsディレクトリ内にあるファイルへのフルパスを構築
NSString *pathInDocumentDirectory(NSString *fileName)
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES
                                                                       );
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:fileName];
}