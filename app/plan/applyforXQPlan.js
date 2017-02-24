/**
 * Created by CrossZhu@huipay on 2017/2/24.
 */

import React, { Component } from 'react';
import { AppRegistry, Navigator, Text, View } from 'react-native';

class applyforXQPlan extends Component{
    render(){
        return(
            <Navigator
             initialRoute={{title:'喜鹊计划',index:0}}
             renderScene={(route, navigator)=>{
                 return
             }}
            />
        )
    }
}