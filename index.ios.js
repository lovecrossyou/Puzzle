/**
 * Created by zhulizhe on 2017/2/6.
 */
'use strict';

import React from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View
} from 'react-native';

// 最新投注记录
import RecentBetList from './app/home/RecentBetList'
// 我的二维码
import MyQRCodeShare from './app/share/MyQRCodeShare'
//登录首页
import FirstLogin from './app/login/FirstLogin'
import Login from './app/login/Login'
import UserInfoView from './app/order/ShareOrderDetail'
//分享
import CommentShareView from './app/share/CommentShareView'
//发表评论
import SendComment from './app/comment/SendComment'
import codePush from 'react-native-code-push'

let codePushOptions = {checkFrequency: codePush.CheckFrequency.ON_APP_RESUME};

class Puzzle extends React.Component {
    render() {
        var pageName = this.props['page']
        switch (pageName) {
            case 'home': {
                return (
                    <RecentBetList />
                )
            }
            case 'share': {
                return (
                    <MyQRCodeShare />
                )
            }
            case 'login': {
                return (<FirstLogin />)
            }
            case 'main_login': {
                return <Login />
            }
            case 'share_order': {
                var orderId = this.props['orderId']
                var shareType = this.props['shareType']
                var url = this.props['url']
                return <UserInfoView orderId={orderId} shareType={shareType} url={url}/>
            }
            case 'share_comment':{
                return <CommentShareView />
            }
            case 'send_comment':{
                return (<SendComment />)
            }
        }
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#FFFFFF',
    },
    highScoresTitle: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    scores: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
});

// Module name
Puzzle = codePush(codePushOptions)(Puzzle)
AppRegistry.registerComponent('Puzzle', () => Puzzle);

