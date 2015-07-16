# MyTools
***
####UIImage+MrZImagecilr
     可以将图片处理成圆形，保存到沙盒下，或者不保存直接返回使用
####NSString+SandboxPath
	 可以将URL文件路径拼接成沙盒路径字符串
#####ZWWebImageView网络图片处理
     如何使用:
	 #import "UIImageView+ZWWebImageView.h"
	 - (void)setWebImageFromURL:(NSString *)URLString;
	 操作缓存数限制为3，图片缓存数限制为10
	 使用中注意：
	 -(void)cache:(NSCache *)cache willEvictObject:(id)obj
	 该代理方法仅供调试用，注意关闭
	 
####~~ZWXMLSAXManager单层xml,这个只能解析单层嵌套，停用~~
	 如何使用:
	 #import "ZWXMLSAXManager.h"
     SAX解析xml,解析完成后以数组包含字典的形式进行回调,目前只支持一层数据解析
     解析线程名为:xml
     默认回调线程为主线程
     类似于该结构:
     <tests>
     <test testid = 1>
     <name>test1</name>
     <test testid = 2>
     <name>test2</name>
     </tests>
     @param URL      xml文件路径
     @param parseEnd 解析完成后以数组包含字典的形式的回调
     @param test     测试模式，输出各个阶段的NSLog
	 -(void)parseWithURLString:(NSString *)URL parseEnd:(parseEndBlock)parseEnd andTestMod:(BOOL)test
	 
####MRZNewXMLparser深层嵌套XML转字典(已知bug，深层同级同名属性会覆盖，待修复)

````
如何使用:
#import "MRZNewXMLparser.h"
MRZNewXMLparser *parser = [[MRZNewXMLparser alloc]init];
NSDictionary *dict = [parser parseData:data];
````
####Log扩展NSLog对字典和数组对象打印的分类，加入到工程即可无需导入头文件
####NETWork封装了指纹识别
####WLDeviceInfo封装了设备信息以及网络运营商信息取得
####BleWork封装了蓝牙设备的链接以及数据回调/使用了xcodecolors控制台颜色插件
####Log中新增了对xcodecolor插件的宏设置