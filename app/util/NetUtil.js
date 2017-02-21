/**
 * Created by huibei on 17/2/7.
 */


import {NativeModules} from 'react-native'

// const Base_url = "http://www.xiteng.com/xitenggame/"
const Base_url = "http://114.251.53.22/xitenggamejar/"
const ImageUrl = "http://114.251.53.22/imageserver/"

const  AppKey = "b5958b665e0b4d8cae77d28e1ad3f521"
const  AppSecret = "71838ae252714085bc0fb2fc3f420110"


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
    var p = new Promise(function (resolve, reject) {
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

function uploadImageRequest(url,param) {
    var getAccInfo = getAccessInfo()
    return new Promise(function (resolve, reject) {
        getAccInfo.then((accessInfo) => {
            // @"app_key":AppKey,
            //     @"access_token":@"",
            // @"signature":[PZMMD5 digest:AppSecret]




            param["accessInfo"] = accessInfo
            url = ImageUrl + url
            let formData = new FormData()
            var imageFiles = images.map((uri, index) => {
                return {uri: uri, type: 'multipart/form-data', name: index + '.jpg'}
            })
            formData.append("file", imageFiles)
            return fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
                body: formData,
            })
                .then((response) => response.text())
                .then((responseData) => {
                    resolve(p.then((responseData) => responseData))
                })
                .catch((error) => {
                    console.error('error', error)
                })
        })
    })
}

function requestData(url, param, method) {
    var getAccInfo = getAccessInfo()
    return new Promise(function (resolve, reject) {
        getAccInfo.then((accessInfo) => {
            param["accessInfo"] = accessInfo
            url = Base_url + url
            var p = sendNetRequest(url, {
                method: method,
                body: JSON.stringify(param),
                headers: {
                    'Content-Type': 'application/json',
                },
            })
            resolve(p.then((data) => data))
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
export function getRecentBetList(pageNo, pageSize, method = 'post') {
    var params = {
        "size": pageSize,
        "pageNo": pageNo,
        "sortProperties": ["time"],
        "direction": "DESC",
    }
    return requestData('getJustNowWithStockList', params, method)
}


/**
 * login
 * @param name
 * @param pwd
 */
export function login(name, pwd) {
    var params = {
        name: name,
        password: pwd
    }
    return requestData('login', params, method)
}

/**
 * 晒单详情
 * @param orderId
 * @returns {*}
 */
export function shareOrderDetail(orderId, shareType, url, method = 'post') {
    var params = {}
    params[shareType] = orderId
    return requestData(url, params, method)
}


export function getUploadImageUrls(images, url) {
    let formData = new FormData()
    var imageFiles = images.map((uri, index) => {
        return {uri: uri, type: 'multipart/form-data', name: index + '.jpg'}
    })
    formData.append("file", imageFiles)
    return fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'multipart/form-data',
        },
        body: formData,
    })
        .then((response) => response.text())
        .then((responseData) => {

            console.log('responseData', responseData)
        })
        .catch((error) => {
            console.error('error', error)
        })
}

