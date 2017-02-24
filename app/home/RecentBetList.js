/**
 * Created by huibei on 17/2/7.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    PixelRatio,
    ListView,
    TouchableOpacity,
    NativeModules
} from 'react-native';
import Image from 'react-native-image-progress'

import codePush from "react-native-code-push"
import {dateDistanceByNow} from '../util/DateUtil'

var personManager = NativeModules.PersonManager

import {getRecentBetList} from '../util/NetUtil'
let _pageNo = 0;
const _pageSize = 20;
class LoadMoreFooter extends Component{
    render(){
        return <View style={{height:44,justifyContent:'center',alignItems:'center'}}>
            <Image style={{height:30,width:30}} source={require('../../assets/loading.gif')}/>
        </View>
    }
}

class BetCell extends Component {
    render() {
        var userIconUrl = this.props.data.userIconUrl
        var time = this.props.data.time
        var timeDesc = dateDistanceByNow(time)
        return <TouchableOpacity
                style={[styles.cellContainer, styles.row]}
                activeOpacity={1}
                onPress={()=>{
                    personManager.goUserHomePageEvent(this.props.data.userId)
                }}>
            <View style={[styles.leftContainer, styles.row]}>
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={()=>{
                        personManager.goUserProfileEvent(this.props.data.userId)
                    }}>
                    <Image style={[styles.logo,styles.border_1]} source={{uri: userIconUrl}}/>
                </TouchableOpacity>
                <View>
                    <Text style={{marginTop: 12, marginLeft: 6}}>{this.props.data.userName}</Text>
                    <Text style={{marginTop: 10, marginLeft: 6,color:'gray',fontSize:11}}>{timeDesc}</Text>
                </View>
            </View>
            <View style={styles.rightContainer}>
                <Image
                    source={require('../../assets/icon_xiteng_s.png')}
                    style={{width: 10, height: 13, marginRight: 4}}/>
                <Text style={{color: 'red'}}>{this.props.data.guessXitbAmount}</Text>
            </View>
        </TouchableOpacity>
    }
}

export default class RecentBetList extends Component {
    constructor() {
        super()
        this.state = {
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            loaded: false,
            isLast:false,
            datas:[]
        }
    }

    componentDidMount() {
        this.fetchData();
    }

    fetchData() {
        if(this.state.datas.length>=100){
            return
        }
        getRecentBetList(_pageNo, _pageSize)
            .then((data)=>{
                var list = data["content"]
                var last = data.last
                var oldlist = this.state.datas
                if(!oldlist){
                    oldlist = []
                }
                _pageNo+=1
                oldlist = oldlist.concat(list)
                this.setState({
                    dataSource: this.state.dataSource.cloneWithRows(oldlist),
                    loaded: true,
                    isLast:last,
                    datas:oldlist
                })
            })
    }

    renderData(data) {
        return (<BetCell data={data}/>)
    }

    render() {
        return <ListView
            style={styles.container}
            dataSource={this.state.dataSource}
            renderRow={this.renderData}
            onEndReached={this.fetchData.bind(this)}
            onEndReachedThreshold={10}
            renderFooter={()=>{
                if(this.state.datas.length>=100)return null
                if(this.state.isLast)return null
                return <LoadMoreFooter/>
            }}
        >
        </ListView>
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1
    },
    row: {
        flexDirection: 'row'
    },
    logo: {
        width: 44,
        height: 44,
        marginTop: 10,
        marginLeft: 10
    },
    cellContainer: {
        justifyContent: 'space-between',
        height: 64,
        borderBottomWidth:1/PixelRatio.get(),
        borderBottomColor:'#F2F2F2'
    },
    rightContainer: {
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: 10,
        flexDirection: 'row'
    },
    leftContainer: {
        // justifyContent: 'center',
        // alignItems: 'center'
    },
    border_1:{
        borderColor:'#f5f5f5',
        borderWidth:1/PixelRatio.get()
    }
})