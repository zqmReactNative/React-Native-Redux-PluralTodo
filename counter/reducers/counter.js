// counter.js
import * as types from '../actions/actionTypes';

const initialState = {
  count: 0,
};

export default function counter(state:initialState, action) {
  switch (action.type) {
    case types.INCREASE:
      return {
        ...state,
        count: state.count+1
      };
      break;
    case types.DECREASE:
    return {
      ...state,
      count: state.count-1
    };
      break;
    default:
      state,

  }
}
