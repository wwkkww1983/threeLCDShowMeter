#ifndef WORKMODEL
#define WORKMODEL

enum workModel
{
    SIMPLE_MODEL,
    NORMAL_MODEL,
    COMPLEX_MODEL
};

enum PicType {
       NAVI_BACK_LEFT,
       NAVI_BACK_RIGHT,
       NAVI_DIRECT_END,
       NAVI_DIRECT_GO,
       NAVI_DIRECT_GO2_LEFT,
       NAVI_DIRECT_GO2_RIGHT,
       NAVI_DIRECT_GO3_MIDDLE,
       NAVI_DIRECT_GON_LEFT,
       NAVI_DIRECT_GON_RIGHT,
       NAVI_DIRECT_GO_STRAIGHT,
       NAVI_DIRECT_TOUNDABOUT,
       NAVI_DIRECT_TUNNEL,
       NAVI_DIRECT_TURN_BACK,
       NAVI_DIRECT_TURN_LEFT,
       NAVI_DIRECT_TURN_LITTLE_LEFT,
       NAVI_DIRECT_TURN_LITTLE_RIGHT,
       NAVI_DIRECT_TURN_RIGHT,
       NAVI_DIRECT_TURN_RIGHT_BACK,
       NAVI_GATEWAY_LEFT_TO_STRAIGHT,
       NAVI_GATEWAY_RIGHT_TO_STRAIGHT,
       NAVI_START,
       NAVI_TITLE_CHARGE,
       NAVI_TITLE_ENTRANCE,
       NAVI_TITLE_ENTRANCE_LEFT,
       NAVI_TITLE_ENTRANCE_RIGHT,
       NAVI_TITLE_EXIT,
       NAVI_TITLE_EXIT_LEFT,
       NAVI_TITLE_EXIT_RIGHT,
       NAVI_DIRECT_OTHER,
       /*以上均为转向信息*/

       NAVI_ROAD,//车道图
       NAVI_CROSS,//路口放大图
       NAVI_CAMERA,//摄像头，预留
       NAVI_LOGO,//搜狗语音提示的图标
       NAVI_SPEED_LIMITE,//限速
       NAVI_INFO_TYPE_OTHER,

    NAVI_WORD_VOICE,//语音提示文字信息
    //3.距离和转向信息，eg,前方500米左转。用此标志位。
       NAVI_WORD_DISTANCE_TURN,//xx米后转弯
       NAVI_WORD_ROAD_TURN,//转弯后进入xx路
       NAVI_WORD_DISTANCE_DEST,//距离目的地xx米
       NAVI_WORD_TIME_DEST,//距离目的地xx:xx到达
       NAVI_WORD_OTHER,//其它文字信息

       NAVI_EXIT,
       /*4.手机导航程序退出标志.在退出导航时，当点击“确认”之后，调用下面的函数sendSimpleWord()*/
   };

#define SPEED_ID 1000
#define DIAL_ID 1001

//use in "void ctrl(int model, String data);"
enum ctrlInfoType {
    DAY_NIGHT,
    RESOLUTION,
};


int DIR_MAX = NAVI_DIRECT_OTHER;
int ROAD_MAX = NAVI_ROAD;
int CROSS_MAX = NAVI_CROSS;
int CAMERA_MAX = NAVI_CAMERA;
int LOGO = NAVI_LOGO;
int TYPE_OTHER = NAVI_INFO_TYPE_OTHER;

#endif // WORKMODEL

