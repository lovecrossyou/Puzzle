/**
 * Created by huibei on 17/2/7.
 */


import {NativeModules} from 'react-native'

const Base_url = "http://www.xiteng.com/xitenggame/"
// const Base_url = "http://114.251.53.22/xitenggamejar/"
const ImageUrl = "http://114.251.53.22/imageserver/"

const AppKey = "b5958b665e0b4d8cae77d28e1ad3f521"
const AppSecret = "71838ae252714085bc0fb2fc3f420110"


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

function getMd5(param) {
    return new Promise(function (res, rej) {
        PersonManager.getMd5(param, (err, info) => {
            res(info)
        })
    })
}

export function uploadImageRequest(url, images) {
    var getAccInfo = getAccessInfo()
    return new Promise(function (resolve, reject) {
        getAccInfo.then((accessInfo) => {
            getMd5(AppSecret).then((signature)=>{
                var accessInfo = {
                    'app_key': AppKey,
                    'access_token': '',
                    'signature': signature
                }

                url = ImageUrl + url
                var formData = new FormData()
                images.forEach(function(uri,index){
                    let file = {uri: uri.path, type: 'multipart/form-data', name: index + '.jpg'}
                    formData.append("file", file)
                })
                return fetch(url, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'Content-Type': 'multipart/form-data'
                    }
                })
                    .then((response) => response.json())
                    .then((responseData) => {
                        resolve(responseData)
                    })
                    .catch((error) => {
                        reject(error)
                    })
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
            resolve(p.then((data) => data).catch((error) => {
                reject(error)
            }))
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

/**
 * 发表评论
 * @param url
 * @param stockGameId
 * @param imageUrls
 * @param content
 * @returns {*}
 */
export function sendComment(url,stockGameId=0,imageUrls,content) {
    var params = {
        "stockGameId": stockGameId,
        "imageUrls": imageUrls,
        "content": content,
    }
    return requestData(url, params, 'POST')
}

export function shalongcommentlist(pageNo,pageSize,commentType='all') {
    var params = {
        "pageNo": pageNo,
        "size": pageSize,
        "commentType": commentType,
    }
    return requestData('commentList', params, 'POST')
}

