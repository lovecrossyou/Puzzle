/**
 * Created by huibei on 17/2/23.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    TextInput,
    View,
    PixelRatio,
    NavigatorIOS,
    Dimensions,
    TouchableOpacity,
    ListView,
    Modal,
    NativeModules

} from 'react-native';
import Image from 'react-native-image-progress'
import ProgressPie from 'react-native-progress/Pie'
import SGListView from 'react-native-sglistview'
import ImageViewer from 'react-native-image-zoom-viewer'
import {shalongcommentlist} from '../util/NetUtil'
var personManager = NativeModules.PersonManager

const {width, height} = Dimensions.get('window')

const picMargin = 10
const picRowCount = 4
let pageNo = 1
const pageSize = 15
const picSize = (width - picMargin * (picRowCount + 1)) / picRowCount

class Header extends Component {
    render() {
        const {userIconUrl, userName, time, sex}  = this.props.data
        var sexUrl = require('../../assets/man.png')
        if (sex != '男') {
            sexUrl = require('../../assets/woman.png')
        }
        return <View style={styles.userinfo_container}>
            <TouchableOpacity onPress={()=>{
                personManager.headClick()
            }}>
                <Image
                    style={{width: 40, height: 40, borderRadius: 3, marginLeft: 10}}
                    source={{uri: userIconUrl}}/>
            </TouchableOpacity>
            <View style={{marginLeft: 10,justifyContent:'center'}}>
                <View style={{flexDirection: 'row',alignItems:'flex-start'}}>
                    <Text style={{color: '#333333', fontSize: 14}}>{userName}</Text>
                    <Image
                        style={[{width: 14, height: 14, marginLeft: 6},styles.border_1]}
                        source={sexUrl}/>
                </View>
                <Text style={{color: '#333333', fontSize: 11}}>{time}</Text>
            </View>
        </View>
    }
}

class ImageItem extends Component{
    render(){
        var {index,showModal,head_img} = this.props
        return <TouchableOpacity
                key={index}
                onPress={()=>{
                    var showModal = !this.state.showModal
                    this.setState({
                    showModal:showModal,
                    showIndex:index
                })
            }}>
                <Image
                    style={[styles.imageItem,styles.border_1]}
                    source={{uri:head_img}}
                />
            </TouchableOpacity>
    }
}

class Content extends Component {
    constructor() {
        super()
        this.state = {
            showModal: false,
            showIndex:0
        }
    }

    render() {
        const {content, contentImages}  = this.props.data
        var imgUrls = []
        contentImages.forEach(function (img,index) {
            imgUrls.push({'url': img.big_img})
        })

        var imagelist = []
        for(var i in contentImages){
            if(i%picRowCount == 0){
                var picM = contentImages[i]
                var picM1 = contentImages[i+1]
                var picM2 = contentImages[i+2]
                var picM3 = contentImages[i+3]

                var picView1 = null
                if(picM1==undefined){
                    picView1 = null
                }
                else{
                    picView1 = (<ImageItem index={i+1} head_img={picM1.head_img} showModal={false}/>)
                }

                var picView2 = null
                if(picM2==undefined){
                    picView2 = null
                }
                else {
                    picView2 = (<ImageItem index={i+2} head_img={picM2.head_img} showModal={false}/>)
                }

                var picView3 = null
                if(picM3==undefined){
                    picView3 = null
                }
                else {
                    picView3 = (<ImageItem index={i+3} head_img={picM3.head_img} showModal={false}/>)
                }

                var row = (<View
                    style={{flexDirection:'row'}}
                    key={i}>
                    <ImageItem index={i} head_img={picM.head_img} showModal={false}/>
                    {picView1}
                    {picView2}
                    {picView3}
                </View>)
            }
            imagelist.push(row)
        }

        /*var contentImageViews = contentImages.map((img, index) => {
            return <TouchableOpacity
                key={index}
                onPress={()=>{
                    var showModal = !this.state.showModal
                    this.setState({
                    showModal:showModal,
                    showIndex:index
                })
            }}>
                <Image
                    style={[styles.imageItem,styles.border_1]}
                    source={{uri: img.head_img}}
                />
            </TouchableOpacity>
        })*/

        return <View style={styles.container}>
            <View>
                <Text numberOfLines={9} style={{marginHorizontal:10,marginVertical:10}}>{content}</Text>
            </View>
            <View style={{flexDirection:'row',flexWrap:'wrap'}}>
                {imagelist}
            </View>
            <Modal visible={this.state.showModal} transparent={false}>
                <ImageViewer
                    imageUrls={imgUrls}
                    index={this.state.showIndex}
                    onClick={()=>{
                    var showModal = !this.state.showModal
                    this.setState({
                    showModal:showModal,
                   })
                }}
                />
            </Modal>
        </View>
    }
}

//点赞 评论 赞赏 通用组件
class MoreItem extends Component{
    render(){
        var {text,icon} = this.props.data
        return <TouchableOpacity style={{alignItems:'center',flexDirection:'row',justifyContent:'space-around'}}>
            <Image source={icon} style={{width:28,height:28}}/>
            <Text style={{fontSize:11,color:'gray',paddingRight:4}}>{text}</Text>
        </TouchableOpacity>
    }
}


class Footer extends Component {
    constructor(){
        super()
        this.state = {
            more_opacity:0
        }
    }

    render() {
        return <View
            style={[styles.row,{marginTop:20,justifyContent:'space-between',alignItems:'center',borderBottomColor:'#f5f5f5',borderBottomWidth:1}]}>
            <View style={[styles.row,{paddingBottom:6,width:100,flexGrow:3}]}>
                <Text style={styles.footerText}>100 点赞</Text>
                <Text style={styles.footerText}>200 赞赏</Text>
                <Text style={styles.footerText}>999 评论</Text>
            </View>
            <View style={[styles.row,{justifyContent:'flex-end',flexGrow:4}]}>
                <View
                    style={[styles.row,{marginBottom:4,justifyContent:'space-around',alignItems:'center',backgroundColor:'#f5f5f5',borderRadius:4,opacity:this.state.more_opacity},styles.border_1]}>
                    <MoreItem data={{text:'点赞',icon:require('../../assets/operation_more.png')}}/>
                    <MoreItem data={{text:'评论',icon:require('../../assets/operation_more.png')}}/>
                    <MoreItem data={{text:'赞赏',icon:require('../../assets/operation_more.png')}}/>
                </View>
                <TouchableOpacity
                    style={{paddingRight:6}}
                onPress={()=>{
                    var opacity = this.state.more_opacity
                    opacity = Math.abs(1-opacity)
                    this.setState({
                        more_opacity:opacity
                    })
                }}>
                    <Image source={require('../../assets/operation_more.png')} style={{width:28,height:28}}/>
                </TouchableOpacity>
            </View>
        </View>
    }
}

class ShalongCell extends Component {
    render() {
        const {data} = this.props
        return <TouchableOpacity style={[styles.container]}>
            <Header data={data}/>
            <Content data={data}/>
            <Footer data={data}/>
        </TouchableOpacity>
    }
}

export default class ShalongList extends Component {
    constructor() {
        super()
        this.state = {
            commentlist: [],
            dataSource: new ListView.DataSource({
                rowHasChanged: (row1, row2) => row1 !== row2,
            }),
            isLast: false
        }
    }

    componentDidMount() {
        this.fetchData()
    }

    fetchData() {
        shalongcommentlist(pageNo, pageSize).then((data) => {
            var list = data["content"]
            var last = data.last
            var oldlist = this.state.commentlist
            if (list.length) {
                oldlist = oldlist.concat(list)
                pageNo++
            }
            this.setState({
                commentlist: oldlist,
                dataSource: this.state.dataSource.cloneWithRows(oldlist),
                last: last
            })
        })
    }


    renderData(data) {
        return <ShalongCell data={data}/>
    }

    render() {
        return <View style={{flex:1,justifyContent:'space-between'}}>
            <SGListView
                dataSource={this.state.dataSource}
                renderRow={this.renderData}
                initialListSize={1}
                onEndReached={this.fetchData.bind(this)}
                onEndReachedThreshold={10}
                pageSize={pageSize}
                scrollRenderAheadDistance={1}
                stickyHeaderIndices={[]}
                renderFooter={()=>{
                if(this.state.isLast)return null
                return <LoadMoreFooter/>
            }}>
            </SGListView>
            <View style={{backgroundColor:'red',height:40}}>

            </View>
        </View>
    }
}

class LoadMoreFooter extends Component {
    render() {
        return <View style={{height:44,justifyContent:'center',alignItems:'center'}}>
            <Image style={{height:30,width:30}} source={require('../../assets/loading.gif')}/>
        </View>
    }
}


const styles = {
    container: {
        flex: 1
    },
    row: {
        flex: 1,
        flexDirection: 'row'
    },
    userinfo_container: {
        flexDirection: 'row',
        alignItems: 'center',
        borderBottomColor: '#f5f5f5',
        borderBottomWidth: 1,
        paddingBottom: 10,
        paddingTop: 10
    },
    imageItem: {
        width: picSize,
        height: picSize,
        marginLeft: picMargin
        // marginBottom: picMargin / 2
    },
    footerText: {
        color: 'gray',
        fontSize: 10,
        marginLeft: 6
    },
    border_1:{
        borderColor:'#f5f5f5',
        borderWidth:1/PixelRatio.get()
    }
}