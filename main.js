import React, { Component } from 'react';
import { StyleSheet, Navigator, View, Text, ListView } from 'react-native';

import TaskList from './TaskList';
import TaskForm from './TaskForm';

export default class Main extends Component {

  constructor(props, context)
  {
    super(props, context);
    this.state = {
      todos:[
        {task: 'Learn React Native'},
        {task: 'Learn Rudex'},
      ],
    }
  }

  onAddStarted = ()=>{
    console.log('on add started');
    this.nav.push({name: 'TaskForm'})
  }

  _renderScene = (route, navigator)=>{
    switch (route.name) {
      case 'TaskForm':
        return (
          <TaskForm />
        );
        break;
      default:
        return (
          <TaskList
            todos={this.state.todos}
            onAddStarted={this.onAddStarted}
            />
        );

    }
  }



  render() {
    return (
      <Navigator
        initialRoute={{name: 'List'}}
        renderScene={this._renderScene}
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
