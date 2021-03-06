import React, { Component, PropTypes } from 'react';
import { StyleSheet, View, Text, ListView, TouchableHighlight } from 'react-native';

import TaskRow from './TaskRow';

export default class TaskList extends Component {

  static propTypes = {
    todos: PropTypes.arrayOf(PropTypes.object).isRequired,
    onAddStarted: PropTypes.func.isRequired,
    onDone: PropTypes.func.isRequired,
  }
  constructor(props, context)
  {
    super(props, context);
    const ds = new ListView.DataSource({
      rowHasChanged:(r1, r2)=> r1 !== r2,
    });
    console.log('props.todos.length : ' + props.todos.length);
    this.state = {
      dataSource: ds.cloneWithRows(props.todos),
    };
  }

  componentWillReceiveProps(nextProps) {
    const dataSource = this.state.dataSource.cloneWithRows(nextProps.todos);

    this.setState({ dataSource });
  }

  _onDone = ()=>{
    if (this.props.onDone) {
      this.props.onDone();
    }
  }

  _renderRow(rowData){
    console.log('_renderRow');
    return (
      <TaskRow todo={rowData} onDone={this._onDone}/>
    );
  }

  render() {

    return (
      <View style={styles.container}>
        <ListView
          dataSource={this.state.dataSource}
          renderRow={this._renderRow}
          />
        <TouchableHighlight
          style={styles.button}
          onPress={this.props.onAddStarted}
          >
          <Text style={styles.buttonText}>
            Add One Cell
          </Text>
        </TouchableHighlight>
      </View>

    );
  }
}

const styles = StyleSheet.create({
  container: {
    paddingTop: 40,
    backgroundColor: '#e7e7e7',
    flex: 1,
    justifyContent: 'flex-start',
  },
  button:{
    backgroundColor: '#333',
    height: 60,
    borderWidth: 1,
    borderColor: '#333',
    margin: 20,
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonText:{
    color: '#fafafa',
    fontSize: 20,
    fontWeight: '300',
  },
});
