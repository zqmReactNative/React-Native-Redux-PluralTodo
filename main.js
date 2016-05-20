import React, { Component } from 'react';
import { StyleSheet, Navigator, View, Text, ListView } from 'react-native';

import TaskList from './TaskList';
import TaskForm from './TaskForm';

import store from './todoStore';

export default class Main extends Component {

  constructor(props, context)
  {
    super(props, context);
    // this.state = {
    //   todos:[
    //     {task: 'Learn React Native'},
    //     {task: 'Learn Rudex'},
    //   ],
    // }
    this.state = store.getState();
    store.subscribe(()=> {
      this.setState(store.getState());
    });
  }

  onAddStarted = ()=>{
    console.log('on add started');
    this.nav.push({name: 'TaskForm'})
  }

  onCancel = ()=>{
    console.log('cancelled!');
    this.nav.pop();
  }
  onAdd = (task)=>{
    console.log('a task was added : ' + task);
    // this.state.todos.push({task});
    // this.setState({
    //   todos: this.state.todos
    // });
    store.dispatch({
      type: 'ADD_TODO',
      task,
    });

    this.nav.pop();
  }

  onDone = (todo)=>{
    console.log('todo was completed : ' + todo.task);
    const filteredTodos = this.state.todos.filter(
      (filterTodo) => {
        return filterTodo !== todo;
      }
    );
    this.setState({todos: filteredTodos});
  }

  _renderScene = (route, navigator)=>{
    switch (route.name) {
      case 'TaskForm':
        return (
          <TaskForm onAdd={this.onAdd} onCancel={this.onCancel} />
        );
        break;
      default:
        console.log('todos.length : ' + this.state.todos.length);
        return (
          <TaskList
            todos={this.state.todos}
            onAddStarted={this.onAddStarted}
            onDone={this.onDone}
            />
        );

    }
  }



  render() {
    return (
      <Navigator
        initialRoute={{name: 'List'}}
        renderScene={this._renderScene}
        configureScene={
          (route)=>{
            return Navigator.SceneConfigs.FloatFromBottom;
          }
        }
        ref={(
          (nav)=>{this.nav=nav}
        )}
        />
    );
  }
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    // paddingTop: 64,
  },
});
