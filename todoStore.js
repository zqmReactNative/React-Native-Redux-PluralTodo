import { createStore } from 'redux';

const defaultState = {
  todos: [{
    task: 'initial todo in stroe',
  }],
};

function todoStore(state = defaultState, action) {
  switch (action.type) {
    case 'ADD_TODO':
      return Object.assign({}, state, {
        todos: state.todos.concat([{
          task: action.task,
        }]),
      });
      break;
    default:
      return state;

  }
}

export default createStore(todoStore);
