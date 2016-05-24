//
//  HTTPService.m
//  KeMan
//
//  Created by user on 14-8-4.
//
//

#import "HTTPService.h"
#import "AFNetworking.h"
#import "HTTPcomMethod.h"


NSString * const imageType = @"image/png";


@interface HTTPService ()
{
    dispatch_queue_t Queue;
    dispatch_group_t group;
    
}

@end

static HTTPService * singleInstance = nil;

@implementation HTTPService

+ (HTTPService *)shareHTTPService
{
    if (singleInstance == nil) {
        //
        singleInstance = [[HTTPService alloc] init];
    }
    return singleInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        //
        //定义线程队列和组
        Queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        group = dispatch_group_create();
    }
    return self;
}

/**
 *  用户登录
 *
 *  @param userName    用户名
 *  @param passWord    密码
 *  @param result      返回访问成功信息
 *  @param errorresult 返回错误信息
 */
- (void)loginServerWithUserName:(NSString *)userName passWord:(NSString *)passWord deviceToken:(NSString *)deviceToken success:(succeeBlock)result errorresult:(errorBlock)errorresult
{
    //开始登录服务器
    NSString * appName = [HTTPcomMethod getAppName];
    NSString * appVersion = [HTTPcomMethod getAppVersion];
    NSString * countrycode = [HTTPcomMethod getCurrentCountry];
    NSString * pwdmd5 = [HTTPcomMethod getPassWordWithmd5:passWord];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:AccessKey forKey:KEY_Accesskey];
    [dict setObject:userName forKey:KEY_username];
    [dict setObject:pwdmd5 forKey:KEY_password];
    [dict setObject:[NSString stringWithFormat:@"%d",2] forKey:KEY_appType];
    [dict setObject:appName forKey:KEY_appName];
    [dict setObject:appVersion forKey:KEY_appVersion];
    [dict setObject:countrycode forKey:KEY_country];
    [dict setValue:deviceToken forKey:KEY_deviceToken];
    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"LoginURL = %@:dict = %@",LoginURL,dict]);

    [self HttpPostToServerWith:LoginURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
}

///**
// *  忘记密码
// *
// *  @param username    用户名
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)getPasswordServerWithusername:(NSString *)username success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:AccessKey forKey:KEY_Accesskey];
//    [dict setObject:username forKey:KEY_username];
//    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"ForgetPwdURL = %@:dict = %@",ForgetPwdURL,dict]);
//
//    [self HttpPostToServerWith:ForgetPwdURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
//}
//
///**
// *  用户注册
// *
// *  @param username    用户名
// *  @param userpwd     密码
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)registWithuserName:(NSString *)username userPwd:(NSString *)userpwd success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSString * pwdmd5 = [HTTPcomMethod getPassWordWithmd5:userpwd];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:AccessKey forKey:KEY_Accesskey];
//    [dict setObject:username forKey:KEY_username];
//    [dict setObject:pwdmd5 forKey:KEY_password];
// 
//    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"SignUpURL = %@:dict = %@",SignUpURL,dict]);
//    [self HttpPostToServerWith:SignUpURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
//}
//
///**
// *  修改密码
// *
// *  @param username    用户名
// *  @param oldpwd      旧密码
// *  @param newpwd      新密码
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)modifyPwdWithusername:(NSString *)username oldpwd:(NSString *)oldpwd newpwd:(NSString *)newpwd success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSString * md5oldpwd = [HTTPcomMethod getPassWordWithmd5:oldpwd];
//    NSString * md5newpwd = [HTTPcomMethod getPassWordWithmd5:newpwd];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:AccessKey forKey:KEY_Accesskey];
//    [dict setObject:username forKey:KEY_username];
//    [dict setObject:md5oldpwd forKey:KEY_old_password];
//    [dict setObject:md5newpwd forKey:KEY_new_password];
//    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"ChangePwdURL = %@:dict = %@",ChangePwdURL,dict]);
//    [self HttpPostToServerWith:ChangePwdURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
//}

/**
 *  获取wifi设备列表
 *
 *  @param userName 用户名
 *  @param password 密码
 *  @param result      返回访问成功信息
 *  @param errorresult 返回错误信息
 */
- (void)getWifiListWithuserName:(NSString * )userName password:(NSString *)password success:(succeeBlock)result errorresult:(errorBlock)errorresult
{
    NSString * md5pwd = [HTTPcomMethod getPassWordWithmd5:password];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:AccessKey forKey:KEY_Accesskey];
    [dict setObject:userName forKey:KEY_username];
    [dict setObject:md5pwd forKey:KEY_password];
    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"GetwifiInfoURL = %@:dict = %@",GetwifiInfoURL,dict]);
    [self HttpGetToServerWith:GetwifiInfoURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
}

/**
 *  上传设备信息到服务器
 *
 *  @param userName 用户名
 *  @param password 密码
 *  @param deviceinfo 设备信息
 *  @param result      返回访问成功信息
 *  @param errorresult 返回错误信息
 */
- (void)UploadDeviceinfoToHttpServerWithuserName:(NSString * )userName password:(NSString *)password deviceInfo:(DevicePreF *)deviceinfo success:(succeeBlock)result errorresult:(errorBlock)errorresult
{
    NSString * md5pwd = [HTTPcomMethod getPassWordWithmd5:password];
    NSString * lastOperationtime = [HTTPcomMethod getcurrentOperationtime];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:AccessKey forKey:KEY_Accesskey];
    [dict setObject:userName forKey:KEY_username];
    [dict setObject:md5pwd forKey:KEY_password];
    [dict setObject:deviceinfo.macAddress forKey:KEY_macAddress];
    [dict setObject:deviceinfo.companyCode forKey:KEY_companyCode];
    [dict setObject:deviceinfo.deviceType forKey:KEY_deviceType];
    [dict setObject:deviceinfo.authCode forKey:KEY_authCode];
    [dict setObject:deviceinfo.deviceName forKey:KEY_deviceName];
    [dict setObject:deviceinfo.imageName forKey:KEY_imageName];
    [dict setObject:[NSNumber numberWithInt:deviceinfo.orderNumber] forKey:KEY_orderNumber];
    [dict setValue:lastOperationtime forKey:KEY_lastOperation];
    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"EditWifiURL = %@:dict = %@",EditWifiURL,dict]);
    [self HttpPostToServerWith:EditWifiURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
}

///**
// *  删除wifi设备
// *
// *  @param userName    用户名
// *  @param password    密码
// *  @param macstring   设备mac信息
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)DeleteDeviceinfoToHttpServerWithuserName:(NSString * )userName password:(NSString *)password macstring:(NSString *)macstring success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSString * md5pwd = [HTTPcomMethod getPassWordWithmd5:password];
//    NSString * lastOperationtime = [HTTPcomMethod getcurrentOperationtime];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:AccessKey forKey:KEY_Accesskey];
//    [dict setObject:userName forKey:KEY_username];
//    [dict setObject:md5pwd forKey:KEY_password];
//    [dict setObject:macstring forKey:KEY_macAddress];
//    [dict setValue:lastOperationtime forKey:KEY_lastOperation];
//    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"DeleteWifiURL = %@:dict = %@",DeleteWifiURL,dict]);
//    [self HttpPostToServerWith:DeleteWifiURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
//}
//
///**
// *  获取反馈列表
// *
// *  @param userName    用户名
// *  @param password    密码
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)getFeedbackListToHttpServerWithuserName:(NSString *)userName password:(NSString *)password success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSString * md5pwd = [HTTPcomMethod getPassWordWithmd5:password];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:AccessKey forKey:KEY_Accesskey];
//    [dict setObject:userName forKey:KEY_username];
//    [dict setObject:md5pwd forKey:KEY_password];
//    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"GetFeedbackURL = %@:dict = %@",GetFeedbackURL,dict]);
//    [self HttpGetToServerWith:GetFeedbackURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
//}
//
///**
// *  删除反馈
// *
// *  @param userName    用户名
// *  @param password    密码
// *  @param feedbackID  反馈id
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)deleteFeedbackToHttpServerWithuserName:(NSString *)userName password:(NSString *)password feedbackID:(NSString *)feedbackID success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSString * md5pwd = [HTTPcomMethod getPassWordWithmd5:password];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:AccessKey forKey:KEY_Accesskey];
//    [dict setObject:userName forKey:KEY_username];
//    [dict setObject:md5pwd forKey:KEY_password];
//    [dict setObject:feedbackID forKey:KEY_feedbackID];
//    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"DeleteFeedbackURL = %@:dict = %@",DeleteFeedbackURL,dict]);
//    [self HttpPostToServerWith:DeleteFeedbackURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
//}
//
///**
// *  新增反馈
// *
// *  @param userName   用户名
// *  @param password   密码
// *  @param msgcontext 消息内容
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)AddFeedbackToHttpServerWithuserName:(NSString *)userName password:(NSString *)password msgcontext:(NSString *)msgcontext success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSString * md5pwd = [HTTPcomMethod getPassWordWithmd5:password];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:AccessKey forKey:KEY_Accesskey];
//    [dict setObject:userName forKey:KEY_username];
//    [dict setObject:md5pwd forKey:KEY_password];
//    [dict setObject:msgcontext forKey:KEY_content];
//    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"AddFeedbackURL = %@:dict = %@",AddFeedbackURL,dict]);
//    [self HttpPostToServerWith:AddFeedbackURL WithParameters:dict timeoutInterval:HTTPTimeout success:result errorresult:errorresult];
//}
//
///**
// *  图片文件上传
// *
// *  @param userName    用户名
// *  @param password    密码
// *  @param name        图片名称
// *  @param image       图片UIImage
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)UploadImageToServerWithuserName:(NSString *)userName password:(NSString *)password imageName:(NSString *)name andImageFile:(UIImage *)image success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSString * md5pwd = [HTTPcomMethod getPassWordWithmd5:password];
//    NSData * imageData = UIImageJPEGRepresentation(image, 0.00001);
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
//    [dict setObject:AccessKey forKey:KEY_Accesskey];
//    [dict setObject:userName forKey:KEY_username];
//    [dict setObject:md5pwd forKey:KEY_password];
//    [dict setObject:name forKey:KEY_imageName];
//    [dict setObject:imageData forKey:KEY_file];
//    HJFHTTPLog(@"%@",[NSString stringWithFormat:@"UploadImageURL = %@:dict = %@",UploadImageURL,dict]);
//    [self HttpPostImageToServerWith:UploadImageURL WithParameters:dict imageName:name andImageFile:image success:result errorresult:errorresult];
//}
//
///**
// *  下载图片
// *
// *  @param fileanme      图片名称
// *  @param saveDirectory 图片保存路径
// *  @param filepathblock 文件下载完成
// *  @param errorresult   返回错误信息
// */
//- (void)downloadFileWithfilename:(NSString *)fileanme savefilepath:(NSString *)savefilepath filepathblock:(downBlock)filepathblock errorresult:(errorBlock)errorresult
//{
//    NSString * url = [NSString stringWithFormat:@"%@/%@",DownloadImageURL,fileanme];
//    HJFHTTPLog(@"downloadFileWithfilename:url = %@",url);
//    __block BOOL isSuccess = NO;
//    dispatch_group_async(group, Queue, ^{
//        isSuccess = [self HttpdownFileWithurl:url savefilepath:savefilepath filepathblock:filepathblock errorresult:errorresult];
//    });
//    //队列任务执行完成
//    dispatch_group_notify(group, Queue, ^{
//        //
//        if (isSuccess) {
//            filepathblock(savefilepath);
//        } else {
//            NSError * error = [NSError errorWithDomain:@"downloadFileWithfilename" code:XDefultFailed userInfo:@{NSLocalizedDescriptionKey:savefilepath}];
//            errorresult(error);
//        }
//    });
//}

/**
 *  http get访问
 *
 *  @param url             访问地址
 *  @param dict            访问参数
 *  @param timeoutInterval 超时时间
 *  @param result          返回访问成功信息
 *  @param errorresult     返回错误信息
 */
- (void)HttpGetToServerWith:(NSString *)url WithParameters:(NSDictionary *)dict timeoutInterval:(NSTimeInterval)timeoutInterval success:(succeeBlock)result errorresult:(errorBlock)errorresult
{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval =timeoutInterval;
    [manager GET:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorresult(error);
    }];
    
}

/**
 *  http post访问
 *
 *  @param url             访问地址
 *  @param dict            访问参数
 *  @param timeoutInterval 超时时间
 *  @param result          返回访问成功信息
 *  @param errorresult     返回错误信息
 */
- (void)HttpPostToServerWith:(NSString *)url WithParameters:(NSDictionary *)dict timeoutInterval:(NSTimeInterval)timeoutInterval success:(succeeBlock)result errorresult:(errorBlock)errorresult
{
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval =timeoutInterval;
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        result(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorresult(error);
    }];
}

///**
// *  上传图片
// *
// *  @param url         上传url
// *  @param dict        访问参数
// *  @param name        图片名称
// *  @param image       图片数据
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)HttpPostImageToServerWith:(NSString *)url WithParameters:(NSDictionary *)dict imageName:(NSString *)name andImageFile:(UIImage *)image success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:KEY_file fileName:name mimeType:imageType];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        result(responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        errorresult(error);
//        
//    }];
//}
//
///**
// *  下载图片
// *
// *  @param url            url
// *  @param filepathblock  返回下载地址
// *  @param errorresult    返回错误信息
// */
//- (BOOL)HttpdownFileWithurl:(NSString *)url savefilepath:(NSString *)savefilepath filepathblock:(downBlock)filepathblock errorresult:(errorBlock)errorresult
//{
//    NSString * resultDataString = nil;
//    NSMutableURLRequest * url_request = [[NSMutableURLRequest alloc] init];
//    [url_request setURL:[NSURL URLWithString:url]];
//    [url_request setHTTPMethod:@"GET"];
//    [url_request setTimeoutInterval:20];
//    NSHTTPURLResponse * Response = nil;
//    NSError * error = nil;
//    NSData * resultData = [NSURLConnection sendSynchronousRequest:url_request returningResponse:&Response error:&error];
//    NSInteger statuscode = Response.statusCode;
//    if (statuscode == 200) {
//        if (!error) {
//            resultDataString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
//            HJFHTTPLog(@"resultDataString=%@",resultDataString);
//            [resultData writeToFile:savefilepath atomically:YES];
//            return YES;
//            
//        } else {
//            HJFHTTPLog(@"error=%@",error);
//            return NO;
//        }
//        
//    } else {
//        return NO;
//    }
//}
//
////下载文件(暂未使用)
//- (void)IOS7_downloadFileWith:(NSString *)url filepathblock:(downBlock)filepathblock errorresult:(errorBlock)errorresult
//{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    //对urlString转成UTF8编码
//    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, NULL,  kCFStringEncodingUTF8));
//    NSURL *URL = [NSURL URLWithString:encodedString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSURLSessionDownloadTask * downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//         
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        
//        NSString * strfilepath = [NSString stringWithFormat:@"%@",filePath];
//        HJFHTTPLog(@">>>>>>>>completionHandler:strfilepath = %@",strfilepath);
//        filepathblock(strfilepath);
//        errorresult(error);
//        
//    }];
//    [downloadTask resume];
//}
//
///**
// *  上传文件(暂未使用)
// *
// *  @param url         上传url
// *  @param path        文件路径
// *  @param result      返回访问成功信息
// *  @param errorresult 返回错误信息
// */
//- (void)uploadToServerWithurl:(NSString *)url filePath:(NSString *)path success:(succeeBlock)result errorresult:(errorBlock)errorresult
//{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    NSURL *URL = [NSURL URLWithString:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSURL *filePath = [NSURL fileURLWithPath:path];
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:filePath progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            errorresult(error);
//        } else {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            result(dic);
//        }
//    }];
//    [uploadTask resume];
//}


@end
