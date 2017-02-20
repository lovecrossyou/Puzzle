/**
 * Created by huibei on 17/2/8.
 */
export function dateDistanceByNow(dateString){
    var timeDesc = ''
    var time = dateString.replace(/-/g,"/")
    var date = new Date(time)
    var now = new Date()
    var t =now.getTime() - date.getTime();
    var d=0;
    var h=0;
    var m=0;
    var s=0;
    if(t>=0){
        d=Math.floor(t/1000/60/60/24);
        h=Math.floor(t/1000/60/60%24);
        m=Math.floor(t/1000/60%60);
        s=Math.floor(t/1000%60);
    }
    if(d>0){
        timeDesc= dateString
    }
    else if(h>0){
        timeDesc= h +'小时前'
    }
    else if(m>0){
        timeDesc= m +'分钟前'
    }
    else if(s>0){
        timeDesc= '刚刚'
    }
    return timeDesc
}