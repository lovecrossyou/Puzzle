/**
 * Created by huibei on 17/2/17.
 */
import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    TextInput,
    Animated,
    Keyboard,
    Platform,
    LayoutAnimation,
    ScrollView,
    TouchableOpacity,
    PixelRatio,
    NavigatorIOS,
    Image,
    Dimensions,
    Modal,
    NativeModules
} from 'react-native';
import Toast, {DURATION} from 'react-native-easy-toast'
import ImagePicker from 'react-native-image-crop-picker'

import {actionCreators} from './SendCommentReducer'
var personManager = NativeModules.PersonManager

const MIN_COMPOSER_HEIGHT = 60
const {width, height} = Dimensions.get('window')

const picMargin = 10
const picRowCount = 4
const picSize = (width - picMargin * (picRowCount + 1)) / picRowCount

import {uploadImageRequest, sendComment} from '../util/NetUtil'
class KeyboardTool extends Component {
    _openPicker() {
        var sendAction = this.props.sendAction
        ImagePicker.openPicker({
            multiple: true
        }).then(images => {
            sendAction(images)
        })
    }

    _openCamera(){
        ImagePicker.openCamera({width: 300,height: 400,cropping: true})
            .then(image => {
                alert('xxxx')
                sendAction(image)
            })
    }

    render() {
        return <View
            style={{backgroundColor:'#f7f7f8',height:MIN_COMPOSER_HEIGHT,flexDirection:'row',justifyContent:'space-between'}}>
            <View style={{flexDirection:'row',alignItems:'center',margin:10}}>
                <TouchableOpacity
                    style={styles.item}
                    onPress={this._openCamera.bind(this)}>
                    <Image
                        source={require('../../assets/icon_camera.png')}
                        style={{width:40,height:40}}/>
                </TouchableOpacity>
                <TouchableOpacity
                    style={styles.item}
                    onPress={this._openPicker.bind(this)}>
                    <Image
                        source={require('../../assets/blacklist.png')}
                        style={{width:34,height:34}}/>
                </TouchableOpacity>
            </View>
            <View style={{flexDirection:'row',alignItems:'center',marginRight:15}}>
                <TouchableOpacity onPress={()=>{
                    Keyboard.dismiss()
                }}>
                    <Image
                        source={require('../../assets/arrow_down.png')}
                        style={{width:20,height:10}}/>
                </TouchableOpacity>
            </View>
            <Toast ref="toast" position='top'/>
        </View>
    }
}

class SendComment extends Component {
<<<<<<< HEAD

    constructor(props) {
        super(props)

        this._keyboardHeight = 0;
        this.state = {
            composerHeight: MIN_COMPOSER_HEIGHT,
            messagesContainerHeight: null,
            pictures:[]
=======
    constructor(props) {
        super(props)
        const {store} = this.props
        const {uploadOn} = store.getState()
        this.store = store
        this._keyboardHeight = 0
        this.state = {
            composerHeight: MIN_COMPOSER_HEIGHT,
            messagesContainerHeight: null,
            pictures: [],
            uploadOn: uploadOn
>>>>>>> 31a3d874c3381e06a302b8a96b343d64143e1262
        }
        this.keyboardWillShowListener = Keyboard.addListener('keyboardWillShow', this.onKeyboardWillShow.bind(this));
        this.keyboardDidHideListener = Keyboard.addListener('keyboardWillHide', this.onKeyboardWillHide.bind(this));
        this.keyboardWillChangeFrameListener = Keyboard.addListener('keyboardWillChangeFrame', this.keyboardWillChangeFrame.bind(this))
<<<<<<< HEAD
=======

>>>>>>> 31a3d874c3381e06a302b8a96b343d64143e1262
    }

    onMainViewLayout(e) {
        const layout = e.nativeEvent.layout
        this.setMaxHeight(layout.height - 64);
        this.setState({
            messagesContainerHeight: this.prepareMessagesContainerHeight(layout.height - 64)
        })
    }

<<<<<<< HEAD
    _getPictures(){
        var pics = this.state.pictures
        var picViews = pics.map((pic,index)=>{
            return <Image source={pic} style={{width:60,height:60}}></Image>
        })
=======

    _addPicture(images) {
        var pics = this.state.pictures
        this.setState({
            pictures: [...images, ...pics]
        })
        this.store.dispatch(actionCreators.setImages(images))
    }

    _getPictures() {
        var pics = this.state.pictures
        var picViews = pics.map((pic, index) => {
            return <Image source={{uri:pic.path}}
                          style={{width:picSize,height:picSize,marginLeft:picMargin,marginTop:picMargin}}
                          key={index}
            />
        })
        return picViews
>>>>>>> 31a3d874c3381e06a302b8a96b343d64143e1262
    }

    renderMainView() {
        return (
            <Animated.View
                style={{height: this.state.messagesContainerHeight}}>
                <View style={{borderBottomColor:'#D4D4D4',borderBottomWidth:1/PixelRatio.get()}}>
                    <TextInput
                        placeholder='请输入标题'
                        editable={true}
                        style={{height:24,margin:10}}
                        onChangeText={(text)=>{
                            this.store.dispatch(actionCreators.setTitle(text))
                        }}
                    />
                </View>
<<<<<<< HEAD
                <View style={{alignItems:'center',justifyContent:'center',backgroundColor:'green',paddingLeft:10}}>
=======
                <View style={{alignItems:'center',justifyContent:'center',paddingLeft:10}}>
>>>>>>> 31a3d874c3381e06a302b8a96b343d64143e1262
                    <TextInput
                        placeholder='正文'
                        editable={true}
                        multiline={true}
                        style={{height:100}}
                        onChangeText={(text)=>{
                             this.store.dispatch(actionCreators.setContent(text))
                        }}
                    />
                </View>
                <View style={{flexDirection:'row',flexWrap:'wrap'}}>
                    {this._getPictures()}
                </View>
                <View style={{flexDirection:'row'}}>
                    {this._getPictures()}
                </View>
            </Animated.View>
        );
    }

    componentWillMount() {
        LayoutAnimation.linear()
    }

<<<<<<< HEAD
=======

    componentDidMount() {
        const {store} = this.props

        this.unsubscribe = store.subscribe(() => {
            var {uploadOn} = store.getState()
            this.setState({
                uploadOn: uploadOn
            })
        })
    }

    componentWillUnmount() {
        this.unsubscribe()
    }

>>>>>>> 31a3d874c3381e06a302b8a96b343d64143e1262
    setKeyboardHeight(height) {
        this._keyboardHeight = height;
    }

    getKeyboardHeight() {
        return this._keyboardHeight;
    }

    prepareMessagesContainerHeight(value) {
        return new Animated.Value(value)
    }

    keyboardWillChangeFrame(e) {
        console.log(JSON.stringify(e))
    }

    onKeyboardWillShow(e) {
        this.setKeyboardHeight(e.endCoordinates ? e.endCoordinates.height : e.end.height);
        const newMsgRawHeight = this.getMaxHeight() - (this.state.composerHeight) - this.getKeyboardHeight()
        const newMessagesContainerHeight = this.prepareMessagesContainerHeight(newMsgRawHeight);
        LayoutAnimation.easeInEaseOut();

        this.setState({
            messagesContainerHeight: newMessagesContainerHeight,
        });
    }

    setMaxHeight(height) {
        this._maxHeight = height;
    }

    getMaxHeight() {
        return this._maxHeight;
    }

    onKeyboardWillHide(e) {
        this.setKeyboardHeight(0);
        const newMsgRawHeight = this.getMaxHeight() - this.getKeyboardHeight()
        const newMessagesContainerHeight = this.prepareMessagesContainerHeight(newMsgRawHeight);
        LayoutAnimation.easeInEaseOut();

        this.setState({
            messagesContainerHeight: newMessagesContainerHeight,
        });
    }

    render() {
        return (
            <ScrollView
                keyboardShouldPersistTaps='always'
                style={styles.container}
                bounces={false}
                scrollEnabled={false}
                onLayout={this.onMainViewLayout.bind(this)}>
                {this.renderMainView()}
                <KeyboardTool sendAction={this._addPicture.bind(this)}/>
                <Modal
                    visible={this.state.uploadOn}
                    transparent={true}
                    animationType="fade"
                    underlayColor="#a9d9d4">
                    <View
                        style={{flex:1,justifyContent:'center',alignItems:'center',opacity:0.4,backgroundColor:'black'}}>
                        <Text style={{color:'white'}}>正在发布...</Text>
                    </View>
                </Modal>
                <Toast ref="toast" position='top'/>
            </ScrollView>
        );

}    }

export default class NavigatorIOSComment extends Component {
<<<<<<< HEAD
    _handleNavigationRequest(){
        alert('xxxx')
=======
    _handleNavigationRequest() {
        const {store} = this.props
        const {title, content, images} = store.getState()
        store.dispatch(actionCreators.uploadOn(true))
        //图片上传
        if (images.length) {
            this._uploadImageRequest(images).then((imageUrls) => {
                this._sendComment(imageUrls, content)
            })
        }
        else {
            this._sendComment(images, content)
        }
    }

    _uploadImageRequest(images) {
        const {store} = this.props
        return new Promise((res, rej) => {
            uploadImageRequest('uploads', images).then((imageDatas) => {
                var imageUrls = [];
                imageDatas.forEach(function (imgData, index) {
                    var {big_img, head_img} = imgData
                    imageUrls.push({
                        'big_img': big_img,
                        'head_img': head_img
                    })
                })
                res(imageUrls)
            })
        })
    }

    _sendComment(imageUrls, content) {
        const {store} = this.props
        sendComment('addComment', 0, imageUrls, content).then((res) => {
            store.dispatch(actionCreators.uploadOn(false))
            personManager.popView()
        })
>>>>>>> 31a3d874c3381e06a302b8a96b343d64143e1262
    }

    render() {
        const {store} = this.props
        const {title, content} = store.getState()
        return (
            <NavigatorIOS
                initialRoute={{
<<<<<<< HEAD
                    component: SendComment,
                    title: '发表评论',
                    rightButtonTitle: '发布',
                    passProps: { sendClickProp:this._handleNavigationRequest.bind(this)},
                    onRightButtonPress: () => this._handleNavigationRequest()}}
=======
                component: SendComment,
                title: '发表评论',
                rightButtonTitle: '发布',
                leftButtonTitle: '取消',
                passProps:{store:store},
                onRightButtonPress: () => this._handleNavigationRequest(),
                onLeftButtonPress:()=>{
                     personManager.popView()
                }}}
>>>>>>> 31a3d874c3381e06a302b8a96b343d64143e1262
                barTintColor='#4964ef'
                tintColor="#ffffff"
                titleTextColor="#ffffff"
                style={{flex: 1}}
                />
            )
        }
}


SendComment.defaultProps = {
    isAnimated: Platform.select({
        ios: true,
        android: false
    }),
}
 
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#FFFFFF',
    },
    item: {
        width: 60,
        margin: 10
    }
});