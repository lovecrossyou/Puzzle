/**
 * Created by huibei on 17/2/16.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    TextInput,
    View,
    PixelRatio,
    Image,
    TouchableOpacity,
    NativeModules,
    NativeAppEventEmitter
} from 'react-native';

var personManager = NativeModules.PersonManager

class ShareItem extends Component{
    render(){
        const {title,icon,action} = this.props
        return <View >
            <TouchableOpacity style={{marginBottom:10,alignItems:'center'}} onPress={()=>{
                action(title)
            }}>
                <Image
                    source={icon}
                    style={{width:44,height:44,marginBottom:6}}
                    resizeMode='stretch'
                />
                <Text style={styles.text}>{title}</Text>
            </TouchableOpacity>
        </View>
    }
}

export default class CommentShareView extends Component{
    constructor(props){
        super(props)
        this.state = {
            showWeChat:false
        }
    }


    _share(platform){
        personManager.shareTo(platform)
    }

    _reportClick(){
        personManager.reportClick()
    }

    _blacklist(){
        personManager.blackList()
    }

    _shareItems(){
        return <View style={styles.itemContainer}>
            <ShareItem title="微信好友" icon={require('../../assets/jnq_icon_wechat.png')} action={this._share.bind(this)}/>
            <ShareItem title="微信朋友圈" icon={require('../../assets/jnq_icon_wechat.png')} action={this._share.bind(this)}/>
            <ShareItem title="新浪微博" icon={require('../../assets/share_btn_weibo.png')} action={this._share.bind(this)}/>
            <ShareItem title="QQ好友" icon={require('../../assets/share_btn_qq.png')} action={this._share.bind(this)}/>
        </View>
    }

    componentDidMount(){
        personManager.isWeChatInstall((error, info) => {
            if (!error) {
                var wechatInstall = info[0]
                this.setState({
                    showWeChat:parseInt(wechatInstall)==1? true : false
                })
            } else {
                reject(error);
            }
        })
    }

    render(){
        var shareItems = this.state.showWeChat ? this._shareItems() : null
        return <View>
            <View style={{margin:20}}>
                <Text style={{color:'gray'}}>分享到</Text>
            </View>
            {shareItems}
            <View style={[styles.itemContainer]}>
                <ShareItem title="举报" icon={require('../../assets/report.png')} action={this._reportClick.bind(this)}/>
                <ShareItem title="拉黑" icon={require('../../assets/blacklist.png')} action={this._blacklist.bind(this)}/>
                <ShareItem title="" />
                <ShareItem title="" />
            </View>
            <TouchableOpacity
                style={{justifyContent:'center',alignItems:'center',height:60}}
                 onPress={()=>{
                     personManager.cancelClick()
                 }}>
                <Text style={{color:'gray', fontSize:16,width:120,textAlign:'center'}}>取消</Text>
            </TouchableOpacity>
        </View>
    }
}

const styles = {
    itemContainer:{
        flexDirection:'row',
        justifyContent:'space-around',
        borderBottomWidth:1/PixelRatio.get(),
        borderBottomColor:'#EAEAEA',
        marginTop:10
    },
    item:{
        width:70,
        height:80,
        margin:10
    },
    text:{
        color:'gray',
        fontSize:12
    }
}