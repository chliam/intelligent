#ifndef TRANSPORT_ST_H
#define TRANSPORT_ST_H
#include<stdint.h>
#include <stdio.h>

typedef struct{
    char flag1;
    char flag2;
    int8_t type;//录像熟悉类型 0是视频 1是音频
    int32_t datalen;//数据长度
}st_record_head;
typedef struct{
    uint64_t        capTime; // 采集时间戳
    uint8_t         rate; // 帧率
    uint8_t         format; // 编码格式
    uint8_t         iframe; // 是否关键帧
    uint16_t        width; // 宽度
    uint16_t        height; // 高度
}st_video_format;
typedef struct{
    char miandirpath[256];//录像保存主目录
    char timedir[256];//天目录路径
    char chndir[256];//通道目录
    int timelen;//每一段时间长
    time_t starttime;//录像起始时间
    long captime;
    FILE *precordfile;//正在录像保存的文件指针
}st_record_info;
//传感器报警content字段解析
typedef struct{
    char enable; //布防撤防
    int sensetype;//传感器类型
    int sensenum;//传感器序号
    int temperature;//当传感器类型为4有此字段，温度实际值=该字段/100
    int humidity;//当传感器类型为5有此字段，湿度实际值=该字段/100
    int power;//当传感器类型为8有此字段，1：主机停电 2：主机来电 3：主机欠压
}st_sensor_alarm_content;
typedef struct{
    char        id[64];
    uint64_t    deviceNo; // 设备ID
    uint64_t    channelNo; // 通道id
    int         type; // 报警类型
    char 		content[256]; // 报警内容
    st_sensor_alarm_content sensorcontent;//传感器报警内容解析
    char		time[64]; // 报警时间
    char		shotUrl[256]; // 截图网址
    char		videoUrl[256]; //视频网址
    char		actionScript[256]; // 执行脚本
}st_alarmlist;
typedef struct{
    int bright[2];//亮度范围bright[0]-bright[1]
    int contrast[2];//对比度范围contrast[0]-contrast[1]
    int saturation[2];//饱和度范围saturation[0]-saturation[1]
    int hue[2];//色调范围hue[0]-hue[1]
}st_img_modules;

typedef struct{
    char deviceid[64];
    char statu[8];
}st_dev_info;
typedef struct{
    int lsnum;
    int pagenum;
    int pagesize;
    int totalsize;
    st_dev_info devls[100];
}st_dev_ls;

typedef struct{
    char chnid[64];
    char statu[8];
    int cloud;
}st_chn_info;
typedef struct{
    int lsnum;
    int pagenum;
    int pagesize;
    int totalsize;
    st_chn_info chnls[100];
}st_chn_ls;

typedef struct{
    int mode;//模式 mode = 0为默认，mode=1 位设定值
    int bright;//当前亮度
    int constrast;//当前对比度
    int saturation;//当前饱和度
    int hue;//当前色调
}st_img_baseopt;

typedef struct{
    int gain;//增益
    int denoise2;//2D降噪
    int denoise3;//3D降噪
    int hsharpness;//水平锐度
    int vsharpness;//垂直锐度
}st_imgext_opt;

//摄像头参数
typedef struct{
    int aperture;//光圈
    int zoom;//变倍
    int focus;//变焦
}st_imglens_opt;

//图像场景参数
typedef struct{
    int scene;//场景  1：自动2：室内3：室外
    int infraed;//红外 1：日夜2：彩色3：黑白
    int horizontal;//左右旋转 0：关闭 1：打开
    int vertical;//上下旋转 0：关闭 1：打开
}st_imgscene_opt;

//通道状态
typedef struct{
    int vdost;//视频状态  1：上线 2：未上线 3：异常
    int recordst;//录像状态 1：开启 0：未开启
    int warnt;//报警状态 1：开启 0：未开启
    int warnin;//告警输入 1：开启 0：未开启
    int warnout;//告警输出 1：开启 0：未开启
}st_viewchn_sta;

//音频状态
typedef struct{
    int state;//状态 0关闭 1：打开
    int samprate;//采样频率 1：8000 2：11025 3：1600
    int digit; //位数
    int codetype;//编码类型 1：speex 2：pacm 3：G.711 4：aac
}st_vdoparam_sta;

//画质模式组
typedef struct{
    int module;//画质 1-普清 2-标清 3-高清 4-超清
    char resolution[256];//分辨率
    int framerate;//帧率
    int picQuality;//质量
}st_chncode_modules;
//画质参数类型
typedef struct{
    char resolutionList[3][256];//分辨率
    int frameRate[2];//帧率范围framerate[0]-framerate[1]
    int picQuality[2];//质量
    int iFrameInterval[2];//I帧间隔范围iframeinterval[0]-iframeinterval[1]
}st_chncode_type;
//当前通道设置状态
typedef struct{
    int module;//当前画质模式
    char resolution[256];//分辨率
    int frameRate;//帧率
    int picQuality;//质量
    int iFrameInterval;//I帧间隔
    int bitRateType;//码率模式 1：VBR、2：CBR、3：fixQP
    int encondeMode;//编码模式 1:jpeg、2:h264
}st_chncode_cursta;

typedef struct{
    int modulescnt;
    st_chncode_modules modulesls[10];
    st_chncode_type paramtype;
    st_chncode_cursta cursta;
}st_chncode_sta;

typedef struct{
    char start[64];
    char end[64];
}st_times;
typedef struct{
    int timecnt;
    st_times times[20];
}st_chnrec_days;
typedef struct{
    int enable;//录像状态
    int curindex;
    st_chnrec_days days[7];
}st_chnrec_sta;

typedef struct{
    int position;//云台位置
    int speed;//速度 1-100的百分比速度
    int baudRate;//波特率
    int dataBit;//数据位
    int stopBit;//停止位
    int check;//校验 0:无、1:奇校验、2:偶校验
    int tract[64];//巡航
    int tractcnt;//
    int presetPoint;//预警点
}st_platform_sta;

typedef enum{
    MOTION_DETECT = 0,
    VIDEO_COVER = 1
}e_alarm_type;
typedef struct{
    int enable;//移动侦测使能0：关闭 1：打开
    int sensitive;//灵敏度0：关闭 1：打开
    int regionSetting[30];//区域设置
    st_chnrec_days days[7];
    int buzzerMoo;//蜂鸣器鸣叫0：关闭 1：打开
    int alarmOut;//报警输出0：关闭 1：打开
    int record;//触发录像0：关闭 1：打开
    int preRecord;//预录像0：关闭 1：打开
    int shotSnap;//抓拍0：关闭 1：打开
    int sendEmail;//发送email0：关闭 1：打开
    int sendFtp;//发送ftp0：关闭 1：打开
    int interval;//告警间隔
    int curIndex;//当前时间计划
}st_alarm_sta;

//邮箱和ftp信息
typedef struct{
    char emailist[3][256];//邮箱
    char ftpServer[256];
    int ftpPost;
    char user[256];
    char password[256];
    char path[256];
}st_emailftp_info;

typedef struct{
    int timeX;//时间坐标x
    int timeY;//时间坐标y
    int enableTime;//是否显示时间
    int timeType;//时间显示类型 0: XXXX-XX-XX 年月日 1: XX-XX-XXXX 月日年
    int textX;//文字坐标x
    int textY;//文字坐标y
    int enableText;//是否显示文字
    char text[256];
}st_osd_sta;
//设备功能
typedef struct{
    int video;//视频 0：无 1：有
    int audio;//语音
    int venc;//画质设置
    int flip;//翻转
    int talk;//对讲
    int ptz;//云台
    int focus;//变焦
    int zoom;//变倍
    int aperture;//光圈
    int replay;//回放
    int recPlan;//录像计划
    int warnPlan;//报警计划
    int errorNo;//错误码
}st_dev_fun;

//设备运行状态
typedef struct{
    char devid[256];//设备号
    char serial[256];//系列号
    char hVersion[256];//硬件版本
    char sversion[256];//软件版本
    char date[256];//出厂日期
    int format;//视频制式 0：PAL 1: NTSC
    int log;//本地日志
    int lModules;//本地模块
    char sTime[256];//系统时间
    int service;//自动维护
    char rtime[256];//运行时长
}st_devrun_sta;
typedef struct{
    int format;
    int log;
    int lModules;
    char sTime[64];
    int service;
}st_set_devrun_sta;
//磁盘状态
typedef struct{
    char disk[64];
    int full;
    int diskSt;
    char distCapacity[64];
    char available[64];
}st_dist_sta;
typedef struct{
    int disknum;
    st_dist_sta distlist[100];
}st_dists_sta;
typedef struct{
    char disk[64];
    int writeable;
    int readable;
}st_set_dist_sta;
//设备网络状态
typedef struct{
    char name[64];//网卡名字
    char ipAddr[64];//网卡IP地址
    char dns[64];//域名系统地址
}st_network_card;
typedef struct{
    char ipAddr[64];
    int ciphers;//加密类型1:无密码2：WEP3:WPA/WPA

    char password[64];
}st_wifi_info;
typedef struct{
    char ipAddr[64];//ip地址
    char mac[64];//硬件地址
    char dns[64];//域名系统
    int tcpPort;//TCP端口
    int httpPort;//HTTP端口
    int networkcardnum;//网卡数最多10个
    st_network_card networkcard[10];
    st_wifi_info wifiinfo;
    int netMode;//网络类型 1:有线、2:无线、3:3G、4:4G
}st_network_sta;

typedef struct{
    char subDevId[64];//摄像头编号
    char ip[64];//ip地址
    int State;//绑定状态0:未绑定 1:已绑定(只有获取ipc列表是才有用)
}st_ipc_info;
typedef struct{
    int IPCNum;
    st_ipc_info *ipcls;
}st_ipc_list;

//传感器触发信息
typedef struct{
    int sensortype;//传感器类型
    int sensorNum;//传感器系列号
    char startTime[64];//触发时间
}st_sensortrigger_info;

//传感器状态
typedef struct{
    int num;//格式
   int *sensortriggerstatuls;//0：未触发 1：已触发
}st_sensorlist;
typedef struct{
    int enable;//使能
    int power;
    st_sensorlist ywk;//烟感
    st_sensorlist pir;//红外
    st_sensorlist mck;//门磁
    st_sensorlist tear;//催泪弹
    st_sensorlist shake;//震动
}st_sensortrigger_statu;
//单个传感器状态
typedef struct{
    int enable;//使能
    int state;//触发状态
}st_onesensortrigger_statu;

//升级包信息
typedef struct{
    char url[256];
    char version[64];
    int size;
}st_updatapackage_info;

//天概要索引信息
typedef struct{
    uint16_t year;
    uint8_t month;
    uint8_t day;
}st_day;
typedef struct{
    int year;
    int month;
    int daysnum;//一个月内录像的天数
    st_day days[31];//一个月内录像天概要信息
}st_days_indx;

//24小时索引
typedef struct{
    int year;
    int month;
    int day;
    int hours;
    int minutes;
    int seconds;
}st_time;
typedef struct{
    st_time starttime;
    st_time endtime;
}st_int_times;
typedef struct{
    int version;
    int type;
    int num;//了
    st_int_times *times;
}st_times_indx;

typedef struct{
//    int         ret;
    char        id[64];
    char        ip[20];
    int         port;
    char 		roomid[64];
    char		viewkey[64];
    int         type;
}st_relayinfo;

typedef struct{
    int     totalnum;
}st_viewerinfo;
#endif // TRANSPORT_ST_H

