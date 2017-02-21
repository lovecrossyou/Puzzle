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
}

const initialState = {
    title:'评论标题',
    content:'评论内容',
    images:[]
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
    }
}

export const reducer = (state=initialState,action)=>{
    var {title,content,images} = action
    switch(action.type){
        case types.sendComment:{

        }
        case types.setTitle:{
            return {...state,title}
        }
        case types.setContent:{
            return {...state,content}
        }
        case types.setImages:{
            return {...state,images}
        }
    }

    return state
}