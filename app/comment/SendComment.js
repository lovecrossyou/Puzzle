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
    NavigatorIOS
} from 'react-native';
import Toast, {DURATION} from 'react-native-easy-toast'
import ImagePicker from 'react-native-image-crop-picker';
var options = {
    title: 'Select Avatar',
    customButtons: [
        {name: 'fb', title: 'Choose Photo from Facebook'},
    ],
    storageOptions: {
        skipBackup: true,
        path: 'images'
    }
}
const MIN_COMPOSER_HEIGHT = 60

class KeyboardTool extends Component {
    render() {
        return <View
            style={{backgroundColor:'#f7f7f8',height:MIN_COMPOSER_HEIGHT,flexDirection:'row',justifyContent:'space-between'}}>
            <View style={{flexDirection:'row',alignItems:'center',margin:10}}>
                <TouchableOpacity
                    style={styles.item}
                    onPress={()=>{
                        ImagePicker.openCamera({width: 300,height: 400,cropping: true})
                            .then(image => {
                                console.log(image)
                            })}}>
                    <Text>拍照</Text>
                </TouchableOpacity>
                <TouchableOpacity
                    style={styles.item}
                    onPress={()=>{
                        ImagePicker.openPicker({multiple: true})
                            .then(images => {
                                console.log(images);
                            })}}>
                    <Text>相册</Text>
                </TouchableOpacity>
            </View>
            <View style={{flexDirection:'row',alignItems:'center',marginRight:10}}>
                <TouchableOpacity onPress={()=>{
                    Keyboard.dismiss()
                }}>
                    <Text>关闭</Text>
                </TouchableOpacity>
            </View>
        </View>
    }
}

class SendComment extends Component {
    onMainViewLayout(e) {
        const layout = e.nativeEvent.layout
        this.setMaxHeight(layout.height-64);
        this.setState({
            messagesContainerHeight: this.prepareMessagesContainerHeight(layout.height-64)
        })
    }

    renderMainView() {
        return (
            <Animated.View
                style={{height: this.state.messagesContainerHeight}}>
                <View style={{borderBottomColor:'#D4D4D4',borderBottomWidth:1/PixelRatio.get()}}>
                    <TextInput
                        placeholder='请输入标题'
                        editable={true}
                        style={{height:24,margin:10}}/>
                </View>
                <View style={{alignItems:'center',marginLeft:10}}>
                    <TextInput
                        placeholder='正文'
                        editable={true}
                        multiline={true}
                        style={{height:100}}/>
                </View>
            </Animated.View>
        );
    }

    componentWillMount() {
        LayoutAnimation.linear();

    }

    constructor(props) {
        super(props)

        this._keyboardHeight = 0;
        this.state = {
            composerHeight: MIN_COMPOSER_HEIGHT,
            messagesContainerHeight: null,
        }
        this.keyboardWillShowListener = Keyboard.addListener('keyboardWillShow', this.onKeyboardWillShow.bind(this));
        this.keyboardDidHideListener = Keyboard.addListener('keyboardWillHide', this.onKeyboardWillHide.bind(this));
        this.keyboardWillChangeFrameListener = Keyboard.addListener('keyboardWillChangeFrame', this.keyboardWillChangeFrame.bind(this))
    }

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
        this.refs.toast.show('Show!' + newMsgRawHeight);
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
        this.refs.toast.show('Hide!' + newMsgRawHeight);
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
                <KeyboardTool/>
                <Toast ref="toast" position='top'/>
            </ScrollView>
        );
    }
}

export default class NavigatorIOSComment extends Component {
    render() {
        return (
            <NavigatorIOS
                initialRoute={{
          component: SendComment,
          title: '发表评论',
        }}
                barTintColor='#4964ef'
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