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
