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
    Modal
} from 'react-native';
import Image from 'react-native-image-progress'
import ProgressPie from 'react-native-progress/Pie'
import SGListView from 'react-native-sglistview'
import ImageViewer from 'react-native-image-zoom-viewer'
import {shalongcommentlist} from '../util/NetUtil'

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
            <Image
                style={{width: 40, height: 40, borderRadius: 3, marginLeft: 10}}
                source={{uri: userIconUrl}}/>
            <View style={{marginLeft: 10,justifyContent:'center'}}>
                <View style={{flexDirection: 'row',alignItems:'flex-start'}}>
                    <Text style={{color: '#333333', fontSize: 14}}>{userName}</Text>
                    <Image
                        style={{width: 14, height: 14, marginLeft: 6}}
                        source={sexUrl}/>
                </View>
                <Text style={{color: '#333333', fontSize: 11}}>{time}</Text>
            </View>
        </View>
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

        var contentImageViews = contentImages.map((img, index) => {
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
                    style={styles.imageItem}
                    source={{uri: img.head_img}}
                    key={index}
                />
            </TouchableOpacity>
        })

        return <View style={styles.container}>
            <View>
                <Text numberOfLines={9} style={{marginHorizontal:10,marginVertical:10}}>{content}</Text>
            </View>
            <View style={{flexDirection:'row',flexWrap:'wrap'}}>
                {contentImageViews}
            </View>
            <Modal visible={this.state.showModal} transparent={false}>
                <ImageViewer
                    imageUrls={imgUrls}
                    index={this.state.showIndex}
                    onClick={()=>{
                    var showModal = !this.state.showModal
                    this.setState({
                    showModal:showModal,
                   })}}
                    loadingRender={()=>{
                        return <View style={{flex:1,justifyContent:'center',alignItems:'center'}}>
                        <Image style={{height:30,width:30}} source={require('../../assets/loading.gif')}/>
                     </View>
                }}
                />
            </Modal>
        </View>
    }
}


class Footer extends Component {
    render() {
        return <View
            style={[styles.row,{marginTop:20,justifyContent:'space-between',alignItems:'center',borderBottomColor:'#f5f5f5',borderBottomWidth:1}]}>
            <View style={[styles.row,{paddingBottom:6}]}>
                <Text style={styles.footerText}>100 点赞</Text>
                <Text style={styles.footerText}>200 赞赏</Text>
                <Text style={styles.footerText}>999 评论</Text>
            </View>
            <TouchableOpacity style={{marginRight:10,paddingBottom:6}}>
                <Image source={require('../../assets/operation_more.png')} style={{width:28,height:28}}/>
            </TouchableOpacity>
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
        return <SGListView
            style={styles.flex}
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
        marginLeft: picMargin,
        marginBottom: picMargin / 2
    },
    footerText: {
        color: 'gray',
        fontSize: 11,
        marginLeft: 10
    }
}