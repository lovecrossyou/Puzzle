/**
 * Created by zhulizhe on 2017/2/25.
 */
import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Navigator,
    TouchableOpacity
} from 'react-native';
export var NavigationBarRouteMapper = {
    LeftButton(route, navigator, index, navState) {
        if (index > 0) {
            return (
                <TouchableOpacity style={{ margin: 15,width:60,height:40}} onPress={() => {
                    if (index > 0) {
                        navigator.pop();
                    }
                } }>
                    <Text style={{color:'white'}}>返回</Text>
                </TouchableOpacity>
            )
        } else {
            return null
        }
    },

    RightButton(route, navigator, index, navState) {
        return null;
    },

    Title(route, navigator, index, navState) {
        return (
            <TouchableOpacity style={{ flex: 1, justifyContent: 'center' }}>
                <Text style={{ color: 'white', margin: 10, fontSize: 16 }}>
                    {route.title}
                </Text>
            </TouchableOpacity>
        );
    }
}