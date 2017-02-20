/**
 * Created by huibei on 17/2/7.
 */


import {NativeModules} from 'react-native'

// const Base_url = "http://www.xiteng.com/xitenggame/"
const Base_url = "http://114.251.53.22/xitenggamejar/"

var PersonManager = NativeModules.PersonManager

function sendNetRequest(...props) {
    this.url = props.shift(1);
    this.options = props.shift(1);
    return fetch(this.url, Object.assign({}, this.options))
        .then((response) => {
            return response.json()
        })
}

function getAccessInfo() {
    var p = new Promise(function(resolve, reject){
            PersonManager.getAccessInfo((error, info) => {
                if (!error) {
                    var accessInfo = info[0]
                    resolve(accessInfo)
                } else {
                    reject(error);
                }
            })
    })
    return p
}

function requestData(url,param,method) {
    var getAccInfo = getAccessInfo()
    return new Promise(function (resolve,reject) {
        getAccInfo.then((accessInfo)=>{
            param["accessInfo"] = accessInfo
            url = Base_url + url
            var p = sendNetRequest(url,{
                method: method,
                body: JSON.stringify(param),
                headers: {
                    'Content-Type': 'application/json',
                },
            })
            resolve(p.then((data)=>data))
        })
    })
}

/**
 * 最新投注信息
 * @param pageNo
 * @param pageSize
 * @param method
 * @returns {*}
 */
export function getRecentBetList(pageNo, pageSize,method='post') {
    var params = {
        "size":pageSize,
        "pageNo":pageNo,
        "sortProperties":["time"],
        "direction":"DESC",
    }
    return requestData('getJustNowWithStockList',params,method)
}


/**
 * login
 * @param name
 * @param pwd
 */
export function login(name,pwd) {
    var params = {
        name:name,
        password:pwd
    }
    return requestData('login',params,method)
}

/**
 * 晒单详情
 * @param orderId
 * @returns {*}
 */
export function shareOrderDetail(orderId,shareType,url,method='post') {
    var params = {}
    params[shareType] = orderId
    return requestData(url,params,method)
}


