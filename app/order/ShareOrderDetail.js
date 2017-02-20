/**
 * Created by huibei on 17/2/14.
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
    Dimensions,
    ScrollView
} from 'react-native';

var {width, height} = Dimensions.get('window');

import {shareOrderDetail} from '../util/NetUtil'

class UserInfoView extends Component {
    render() {
        var userInfo = this.props.userInfo
        var userName = userInfo.userName
        var userIcon = userInfo.userIcon
        var time = userInfo.time
        var sex = userInfo.sex
        var sexUrl = require('../../assets/man.png')
        if (sex == 'woman') {
            sexUrl = require('../../assets/woman.png')
        }
        return <View style={styles.userinfo_container}>
            <Image
                style={{width: 40, height: 40, borderRadius: 3, marginLeft: 10}}
                source={{uri: userIcon}}/>
            <View style={{marginLeft: 10}}>
                <View style={{flexDirection: 'row', alignItems: 'center'}}>
                    <Text style={{color: '#333333', fontSize: 14}}>{userName}</Text>
                    <Image
                        style={{width: 14, height: 14, marginLeft: 6}}
                        source={sexUrl}/>
                </View>
                <Text style={{color: '#333333', fontSize: 12}}>{time}</Text>
            </View>
        </View>
    }
}

/**
 *中奖
 */
class ProductInfoPrizeView extends Component {
    render() {
        var productCommentInfo = this.props.data
        if (!productCommentInfo)return null
        var {awardInfo,showTime} = productCommentInfo

        var profitType = productCommentInfo.awardTypeName=='week' ? '本周收益' : productCommentInfo.awardTypeName=='month'? '本月收益':'本年收益'
        return <View style={{
            flexDirection: 'row',
            justifyContent: 'space-between',
            alignItems: 'center',
            borderBottomColor: '#f5f5f5',
            borderBottomWidth: 12
        }}>
            <View style={{flexDirection: 'row'}}>
                <Image
                    style={{width: 80, height: 80, marginLeft: 12, marginTop: 10, marginBottom: 10,borderWidth:1,borderColor:'#f4f4f4'}}
                    source={{uri:awardInfo.picUrl}}/>
                <View style={{marginLeft: 10}}>
                    <Text style={styles.text_margin}>{awardInfo.name}</Text>
                    <Text style={[styles.text_margin,styles.text_color]}>获奖类型：{awardInfo.awardType}</Text>
                    <Text style={[styles.text_margin,styles.text_color]}>开奖时间:{showTime}</Text>
                    <View style={{flexDirection: 'row', alignItems: 'center'}}>
                        <Text style={[styles.text_color]}>{profitType}:</Text>
                        <Image
                            source={require('../../assets/icon_xiteng_s.png')}
                            style={{width: 10, height: 13,marginLeft:2}}/>
                        <Text style={{color: 'red', marginLeft: 4}}>{awardInfo.profit}</Text>
                    </View>
                </View>
            </View>
            <View>
                <Image
                    style={{width: 36, height: 36, marginRight: 10}}
                    source={require('../../assets/fortune.png')}/>
            </View>
        </View>
    }
}

/**
 * 商城兑换
 */
class ProductInfoShoppingView extends Component {
    render() {
        var productInfoList = this.props.data.productInfoList
        if (!productInfoList)return null
        var cells = productInfoList.map((data, index) => {
            var {productName, price, picUrl} = data
            return <View
                style={{
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    borderBottomColor: '#f5f5f5',
                    borderBottomWidth: 12,
                }}
                key={index}>
                <View style={{flexDirection: 'row'}}>
                    <Image
                        style={{width: 80, height: 80, marginLeft: 12, marginTop: 10, marginBottom: 10,borderWidth:1,borderColor:'#F4F4F4'}}
                        source={{uri: picUrl}}/>
                    <View style={{marginLeft: 10,justifyContent:'center'}}>
                        <Text style={styles.text_margin}>{productName}</Text>
                        <View style={{flexDirection: 'row', alignItems: 'center',marginTop:10}}>
                            <Image
                                source={require('../../assets/icon_xiteng_s.png')}
                                style={{width: 10, height: 13}}/>
                            <Text style={{color: 'red', marginLeft: 4}}>{price}</Text>
                        </View>
                    </View>
                </View>
            </View>
        })
        return <View>
            {cells}
        </View>
    }
}

/**
 * 零元夺宝
 */
class ProductInfoDuoBaoView extends Component {
    render() {
        var purchaseGameInfo = this.props.purchaseGameInfo
        if (!purchaseGameInfo)return null
        var productName = purchaseGameInfo.productName
        var description = purchaseGameInfo.description
        var stage = purchaseGameInfo.stage
        var bidCount = purchaseGameInfo.bidCount
        var luckCode = purchaseGameInfo.luckCode
        var finishTime = purchaseGameInfo.finishTime
        var pic = purchaseGameInfo.pic

        return <View style={{
            flexDirection: 'row',
            justifyContent: 'space-between',
            alignItems: 'center',
            borderBottomColor: '#f5f5f5',
            borderBottomWidth: 12
        }}>
            <View style={{flexDirection: 'row'}}>
                <Image
                    style={{width: 80, height: 80, marginLeft: 12, marginTop: 10, marginBottom: 30}}
                    source={{uri: pic}}/>
                <View style={{marginLeft: 10}}>
                    <Text style={styles.text_margin}>{productName}</Text>
                    <Text style={[styles.text_margin,styles.text_color]}>期数：{stage}</Text>
                    <View style={{flexDirection: 'row', alignItems: 'center'}}>
                        <Text style={styles.text_color}>参与份数:</Text>
                        <Text style={{color: 'red', marginLeft: 6}}>{bidCount}</Text>
                    </View>
                    <View style={{flexDirection: 'row', alignItems: 'center'}}>
                        <Text style={styles.text_color}>幸运号:</Text>
                        <Text style={{color: 'red', marginLeft: 6}}>{luckCode}</Text>
                    </View>
                    <Text style={[styles.text_margin,styles.text_color]}>揭晓时间:{finishTime}</Text>
                </View>
            </View>
            <View>
                <Image
                    style={{width: 36, height: 36, marginRight: 10}}
                    source={require('../../assets/fortune.png')}/>
            </View>
        </View>
    }
}

class CommentView extends Component {
    render() {
        var {pictures, content} = this.props
        var picView = []
        if (pictures) {
            picView = pictures.map((pic, index) => {
                return <Image
                    style={{width: width - 20, height: width - 20, marginTop: 10}}
                    source={{uri: pic.big_img}}
                    resizeMode='cover'
                    key={index}/>
            })
        }
        return <View style={{marginTop: 10,alignItems:'center'}}>
            <View>
                <Text style={{textAlign: 'left', margin: 6}}>{content}</Text>
            </View>
            {picView}
        </View>
    }
}


export default class ShareOrderDetail extends Component {
    constructor(props) {
        super(props)
        this.state = {
            data: undefined
        }
    }

    componentDidMount() {
        this.fetchData()
    }

    fetchData() {
        var {orderId, shareType, url} = this.props
        shareOrderDetail(orderId, shareType, url).then((json) => {
            this.setState({
                data: json,
            })
        })
    }

    _loadingView(){
        return <View style={{flex:1,alignItems:'center',justifyContent:'center'}}>
            <Image
                source={require('../../assets/loading.gif')}
                style={{width:45,height:36}}/>
        </View>
    }

    render() {
        if (!this.state.data)return this._loadingView()
        var {orderId, shareType, url} = this.props

        var productCommentInfo = this.state.data.productCommentInfo

        var userName = this.state.data.userName
        var userIcon = this.state.data.userIcon
        var time = this.state.data.time
        var sex = this.state.data.userSex

        var userInfo = {
            userName, userIcon, time, sex
        }
        var content = ''
        var purchaseGameInfo = this.state.data.purchaseGameInfo

        var productView = null
        var pictures = []

        if (shareType == "exchangeOrderId") {
            //礼品订单
            productView = <ProductInfoShoppingView data={this.state.data}/>
            pictures = productCommentInfo.contentImages
            var userName = productCommentInfo.userName
            var userIcon = productCommentInfo.userIconUrl
            var time = productCommentInfo.createTime
            var sex = productCommentInfo.userSex
            userInfo = {
                userName, userIcon, time, sex
            }
            content = productCommentInfo.content
        }
        else if (shareType == "stockWinOrderShowId") {
            //投注中奖
            productView = <ProductInfoPrizeView data={this.state.data}/>
            pictures = this.state.data.pictures
            content = this.state.data.content
            userInfo = this.state.data.userInfo
            userInfo.userIcon = userInfo.userIconUrl
            userInfo.time = this.state.data.showTime
        }
        else {
            productView = <ProductInfoDuoBaoView purchaseGameInfo={purchaseGameInfo}/>
            pictures = this.state.data.pictures
            content = this.state.data.content

        }
        return <ScrollView>
            <UserInfoView userInfo={userInfo}/>
            {productView}
            <CommentView pictures={pictures} content={content}/>
        </ScrollView>
    }
}

const styles = {
    userinfo_container: {
        flexDirection: 'row',
        height: 60,
        alignItems: 'center',
        borderBottomColor: '#f5f5f5',
        borderBottomWidth: 1,
        marginLeft: 10
    },
    text_margin: {
        marginTop: 6
    },
    text_color:{
        color:'#666666'
    }
}
