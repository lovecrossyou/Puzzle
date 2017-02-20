/**
 * Created by huibei on 17/2/8.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    TextInput,
    View,
    PixelRatio,
    TouchableOpacity,
    Image,
    Dimensions,
    NativeModules
} from 'react-native';

import {getAccessInfo} from '../util/NetUtil'

var personManager = NativeModules.PersonManager
var {height, width} = Dimensions.get('window')
class HeaderView extends Component{
    render(){
        return <View>
            <View style={styles.centerContainer}>
                <Image style={{height:60,width:60}} source={require('../../assets/logo.png')}></Image>
                <Text style={{fontSize:18,marginTop:6}}>喜腾</Text>
            </View>
            <View style={styles.centerContainer}>
                <TouchableOpacity
                    style={{ justifyContent:'center',height:40,width:width-30,marginTop:64+20,backgroundColor:'blue',borderRadius:4,alignItems:'center'}}
                    onPress={()=>{
                        personManager.registeWeChat()
                    }}>
                    <Text style={{color:'white',fontSize:16}}>微信安全注册</Text>
                </TouchableOpacity>
                <Text style={{color:'gray',marginTop:20}}>微信官方授权安全快捷</Text>
            </View>
        </View>
    }
}


class FooterView extends Component{
    render(){
        return <View style={styles.footer}>
            <TouchableOpacity onPress={()=>{
                personManager.goLogin()
            }}>
                <Text style={{color:'gray'}}>已有喜腾帐号?</Text>
            </TouchableOpacity>
        </View>
    }
}


export default class FirstLogin extends Component{
    render(){
        return <View style={styles.container}>
            <HeaderView />
            <FooterView />
        </View>
    }
}


const styles = StyleSheet.create({
    container:{
        justifyContent:'space-between',
        height:height
    },
    centerContainer:{
        alignItems:'center',
        justifyContent:'center'
    },
    header:{

    },
    footer:{
        height:30,
        marginBottom:64+44,
        alignItems:'center',
        justifyContent:'center'
    }
})
