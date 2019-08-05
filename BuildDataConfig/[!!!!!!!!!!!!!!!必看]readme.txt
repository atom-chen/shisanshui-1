环境搭建：
环境配置查看：\\192.168.1.205\com.xlcw\软件\研发工具\Protobuf相关\搭建protobuf_lua环境.txt
相关软件目录：\\192.168.1.205\com.xlcw\软件\研发工具\Protobuf相关


注意： 生成的.byte、.cs、.lua文件生成后会自动添加到svn；
	 生成Mate文件后，可以调用 "Add 所有生成的文件和meta文件到svn.bat"添加svn


备注：svn添加不成功的同学，需要重新安装下svn的“command line client tools”：	  
                 安装目录\\192.168.1.205\com.xlcw\软件\其它\SVN\TortoiseSVN-1.8.8.25755-x64-svn-1.8.10.msi


(2) 配置规则：
# 说明:
说明如下：
第一行：c代表只导出给client，cs代表同时导出给client/server, s代表只导出给server
第二行：required代表必须填的列，optional表示选填的列，repeated表示包含重复元素， required_struct 必选结构属性，optional_struct 可选结构属性
第三行：值类型，比如 uint32,string,float
第四行：属性名
第五行：注释部分
第六行开始，都是值