/**
 * Created by CrossZhu@huipay on 2017/2/24.
 */

import React, { Component } from 'react';
import { AppRegistry, Navigator, Text, View,TouchableOpacity,TouchableHighlight } from 'react-native';

import JoinXQPlan from './JoinXQPlan'

import {NavigationBarRouteMapper} from '../common/NavigatorConfig'

class XQHome extends Component{
    render(){
           return <View style={{backgroundColor:'#f5f5f5',flex:1}}>
               <TouchableOpacity
                   style={{justifyContent:'center',alignItems:'center'}}
                   onPress={()=>{
                this.props.navigator.push({
                    title:'加入喜鹊',
                    component:JoinXQPlan
                })
            }}>
                   <Text>Join</Text>
               </TouchableOpacity>
           </View>
    }
}


export default class ApplyforXQPlan extends Component{
    render(){
        return (
            <Navigator
                initialRoute={{component:XQHome}}
                renderScene={(route, navigator) => {
                let Component = route.component;
                return <Component {...route.params} navigator={navigator} />
              }}
                configureScene={(route, routeStack) => Navigator.SceneConfigs.PushFromRight}
                navigationBar={
                    <Navigator.NavigationBar
                        routeMapper={NavigationBarRouteMapper}
                        style={{backgroundColor: 'gray'}}/>
                }
            />)
    }
}