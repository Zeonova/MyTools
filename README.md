# MyTools
***
####UIImage+MrZImagecilr
     可以将图片处理成圆形，保存到沙盒下，或者不保存直接返回使用
 
####NSString+SandboxPath
	 可以将URL文件路径拼接成沙盒路径字符串
#####ZWWebImageView超轻量级网络图片
     如何使用:
	 #import "UIImageView+ZWWebImageView.h"
	 - (void)setWebImageFromURL:(NSString *)URLString;
	 操作缓存数限制为3，图片缓存数限制为10
	 使用中注意：
	 -(void)cache:(NSCache *)cache willEvictObject:(id)obj
	 该代理方法仅供调试用，注意关闭
	 
####ZWXMLSAXManager单层xml超轻量级解析
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
