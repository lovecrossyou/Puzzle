/**
 * Created by huibei on 17/2/21.
 */
export const types = {
    sendComment:'SEND',
    getTitle:'GET_TITLE',
    getContent:'GET_CONTENT',
    getImages:'GET_IMAGES',
    setTitle:'SET_TITLE',
    setContent:'SET_CONTENT',
    setImages:'SET_IMAGES',
    setUploadOn:'UploadOn'

}

const initialState = {
    title:'评论标题',
    content:'评论内容',
    images:[],
    uploadOn:false
}

export const actionCreators = {
    setTitle:(title)=>{
        return {type:'SET_TITLE',title:title}
    },
    setContent:(content)=>{
        return {type:'SET_CONTENT',content:content}
    },
    setImages:(images)=>{
        return {type:'SET_IMAGES',images:images}
    },
    uploadOn:(isOn)=>{
        return {
            type:'UploadOn',uploadOn:isOn
        }
    }
}

export const reducer = (state=initialState,action)=>{
    var {title,content,images,uploadOn} = action
    switch(action.type){
        case types.setTitle:{
            return {
                ...state,
                title:title
            }
        }
        case types.setContent:{
            return {
                ...state,
                content:content
            }
        }
        case types.setImages:{
            return {
                ...state,
                images:[...images]
            }
        }
        case types.setUploadOn:{
            return {
                ...state,
                uploadOn:uploadOn
            }
        }
        default:
            return state
    }

    return state
}